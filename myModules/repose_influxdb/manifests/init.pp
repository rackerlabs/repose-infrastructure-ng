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

  $influxdb_graphite_port = 13002

  include ssl_cert

  firewall { '100 InfluxDB access':
    dport  => 8086,
    proto  => tcp,
    action => accept,
  }

  firewall { '101 Graphite access':
    dport  => $influxdb_graphite_port,
    proto  => tcp,
    action => accept,
  }

  exec { 'apt-get-update':
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    command => "apt-get update",
  }

  package { 'apt-transport-https':
    ensure  => present,
    require => Exec['apt_update'],
  }

  class { 'influxdb::server':
    http_auth_enabled      => true,
    http_https_enabled     => true,
    http_https_certificate => '/etc/ssl/certs/openrepose.crt',
    http_https_private_key => '/etc/ssl/keys/openrepose.key',
    http_max_row_limit     => 10000,
    graphite_options       => {
      enabled              => true,
      database             => $influxdb_performance_db,
      bind-address         => ":$influxdb_graphite_port",
      name-separator       => '_',
      templates            => [
        "gatling.*.*.*.* measurement.measurement.request.status.field",
        "gatling.*.users.*.* measurement.measurement.measurement.request.field",
      ],
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

  $influxdb_backups = '/srv/influxdb-backups'
  backup_cloud_files::target { 'performance_influxdb':
    target            => $influxdb_backups,
    cf_username       => hiera('rs_cloud_username'),
    cf_apikey         => hiera('rs_cloud_apikey'),
    cf_region         => 'DFW',
    duplicity_options => '--full-if-older-than 15D --volsize 250 --exclude-other-filesystems --no-encryption',
  }

  cron { 'influxdb_backup':
    ensure  => present,
    command => "influxd backup -database $influxdb_performance_db $influxdb_backups",
    user    => 'root',
    hour    => 5,
    minute  => 0,
    require => Package['influxdb'],
  }

  cron { 'duplicity_backup':
    ensure  => present,
    command => '/usr/local/bin/duplicity_performance_influxdb.rb',
    user    => root,
    hour    => 6,
    minute  => 0,
    require => Backup_cloud_files::Target['performance_influxdb'],
  }

  # schedule a clean up of the backups once a month
  cron { 'influxdb_cleanup':
    ensure   => present,
    command  => "find $influxdb_backups/ -type f -mtime +30 -name \"*.gz\" -execdir rm -- {} +",
    user     => root,
    monthday => 1,
    hour     => 3,
    minute   => 0,
    require  => Backup_cloud_files::Target['performance_influxdb'],
  }

  cron { 'duplicity_cleanup':
    ensure   => present,
    command  => '/usr/local/bin/duplicity_performance_influxdb.rb remove-older-than 1M --force \$url',
    user     => root,
    monthday => 1,
    hour     => 3,
    minute   => 0,
    require  => Backup_cloud_files::Target['performance_influxdb'],
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
