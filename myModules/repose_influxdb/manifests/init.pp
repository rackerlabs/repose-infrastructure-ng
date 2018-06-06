class repose_influxdb (
  $influxdb_admin_username = undef,
  $influxdb_admin_password = undef,
  $influxdb_performance_db = undef,
) {
  if($influxdb_admin_username == undef) {
    fail("Must have InfluxDB's Admin username configured")
  }
  if($influxdb_admin_password == undef) {
    fail("Must have InfluxDB's Admin password configured")
  }
  if($influxdb_performance_db == undef) {
    fail("Must have the name of the Performance DB configured")
  }

  # todo: redundant include -- base::nginx::autohttps already provides this
  include ssl_cert

  firewall { '101 InfluxDB access':
    dport  => '8086',
    action => 'accept',
  }

  firewall { '102 Graphite listener access':
    source      => '192.168.3.0/24',
    destination => '192.168.3.0/24',
    dport       => '2003',
    action      => 'accept',
  }

  firewall { '103 UDP listener access':
    proto       => 'udp',
    source      => '192.168.3.0/24',
    destination => '192.168.3.0/24',
    dport       => '8089',
    action      => 'accept',
  }

  exec { 'apt-get-update':
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    command => "apt-get update",
  }

  package { 'apt-transport-https':
    ensure  => present,
    require => Exec['apt_update'],
  }

  $cbs_mount_point = '/mnt/cbs'

  class { 'influxdb::server':
    http_auth_enabled      => true,
    http_https_enabled     => true,
    http_https_certificate => '/etc/ssl/certs/openrepose.crt',
    http_https_private_key => '/etc/ssl/keys/openrepose.key',
    http_max_row_limit     => 10000,
    meta_dir               => "$cbs_mount_point/influxdb/meta",
    data_dir               => "$cbs_mount_point/influxdb/data",
    wal_dir                => "$cbs_mount_point/influxdb/wal",
    graphite_options       => {
      enabled              => true,
      database             => $influxdb_performance_db,
      name-separator       => '_',
      templates            => [
        "gatling.*.*.*.*.* measurement.repose_version.measurement.request.status.field",
        "gatling.*.*.users.*.* measurement.repose_version.measurement.measurement.request.field",
        "jmxtrans.* measurement.repose_version.test_name..measurement.field",
      ],
    },
    udp_options            => {
      enabled              => true,
      database             => $influxdb_performance_db,
    },
    require                => [
      Package['apt-transport-https'],
      Exec['apt_update'],
    ]
  }

  #make sure the influxdb user is in the ssl-keys group
  user { "influxdb":
    ensure  => present,
    groups  => ["ssl-keys"],
    require => [
      Class["ssl_cert"],
      Package['influxdb'],
    ]
  }

  package { 'curl':
    ensure  => present,
  }

  exec { 'create-influxdb-user':
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    command => "curl -iv -G https://influxdb.openrepose.org:8086/query --data-urlencode \"q=CREATE USER $influxdb_admin_username WITH PASSWORD '$influxdb_admin_password' WITH ALL PRIVILEGES\"",
    require => Class["influxdb::server"],
  }

  exec { 'create-influxdb-database':
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    command => "curl -iv -G https://influxdb.openrepose.org:8086/query --data-urlencode \"q=CREATE DATABASE $influxdb_performance_db\" -u $influxdb_admin_username:$influxdb_admin_password",
    require => Class["influxdb::server"],
  }

  $influxdb_backups = "$cbs_mount_point/backups"
  $targetName = 'performance_influxdb'
  $duplicityScript = "/usr/local/bin/duplicity_$targetName.rb"

  backup_cloud_files::target { $targetName:
    target            => $influxdb_backups,
    cf_username       => hiera('rs_cloud_username'),
    cf_apikey         => hiera('rs_cloud_apikey'),
    cf_region         => 'DFW',
    duplicity_options => '--full-if-older-than 15D --volsize 250 --exclude-other-filesystems --no-encryption',
  }

  file{ "/usr/local/bin/influxdb-backup-compress.sh":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => 0754,
    source => "puppet:///modules/repose_influxdb/influxdb-backup-compress.sh",
  }

  cron { 'influxdb_backup':
    ensure  => present,
    command => "/usr/local/bin/influxdb-backup-compress.sh $influxdb_performance_db $influxdb_backups",
    user    => 'root',
    hour    => 5,
    minute  => 0,
    require => Package['influxdb'],
  }

  cron { 'duplicity_backup':
    ensure  => present,
    command => $duplicityScript,
    user    => root,
    hour    => 6,
    minute  => 0,
    require => Backup_cloud_files::Target[$targetName],
  }

  cron { 'influxdb_cleanup':
    ensure   => present,
    command  => "find $influxdb_backups/ -type f -mtime +7 -name \"*.gz\" -execdir rm -- {} +",
    user     => root,
    hour     => 3,
    minute   => 0,
    require  => Backup_cloud_files::Target[$targetName],
  }

  cron { 'duplicity_cleanup':
    ensure   => present,
    # escape the `\` and `$` characters so that neither Puppet nor the shell interpolate
    # we literally want to pass `$url` as an argument to the Duplicity script
    command  => "$duplicityScript remove-older-than 30D --extra-clean --force \\\$url",
    user     => root,
    hour     => 3,
    minute   => 0,
    require  => Backup_cloud_files::Target[$targetName],
  }

  include base::nginx::autohttps

  file { "/etc/nginx/conf.d/influxdb.conf":
    ensure  => file,
    mode    => 0644,
    owner   => root,
    group   => root,
    content => template("repose_influxdb/nginx.conf.erb"),
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  #Papertrail the influxdb logs
  $papertrail_port = hiera("base::papertrail_port", 1)
  class { 'remotesyslog':
    port => $papertrail_port,
    logs => [
      '/var/log/influxdb/influxd.log'
    ],
  }
}
