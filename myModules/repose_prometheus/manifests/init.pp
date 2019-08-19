# Sets up Prometheus exporters which enable the exposure of data about the host.
class repose_prometheus {

  # TODO: Set up TLS and basic auth for exporter endpoints to ensure secure,
  # TODO: authorized communication.
  # TODO: Some variant of the autohttps class can be used since the autohttps
  # TODO: class itself does not play nice with exporters or other servers on the host.

  $textfile_directory = '/var/lib/node_exporter/textfile_collector'
  $textfile_scripts_directory = '/opt/node_exporter/scripts'
  $textfile_directories = ['/var/lib/node_exporter', $textfile_directory]
  $textfile_scripts_directories = ['/opt/node_exporter', $textfile_scripts_directory]

  # Set up Nginx to handle basic authentication
  include base::nginx::basic_auth

  firewall { '800 Nginx proxy to Node Exporter':
    dport  => '19100',
    action => 'accept',
  }

  # Terminate SSL using Nginx, enforce basic auth, and proxy to Prometheus
  file { '/etc/nginx/sites-available/node_exporter':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/repose_prometheus/nginx/sites-available/node_exporter",
    require => [
      Package['nginx'],
      File['/etc/nginx/nginx-ssl.conf'],
    ],
  }

  file { '/etc/nginx/sites-enabled/node_exporter':
    ensure  => link,
    target  => '/etc/nginx/sites-available/node_exporter',
    require => [
      File['/etc/nginx/sites-available/node_exporter'],
    ],
    notify  => Service['nginx'],
  }

  class { 'prometheus::node_exporter':
    version            => '0.18.1',
    collectors_enable => [
      'systemd',
    ],
    collectors_disable => [
      'arp',
      'bcache',
      'bonding',
      'conntrack',
      'edac',
      'entropy',
      'hwmon',
      'infiniband',
      'ipvs',
      'loadavg',
      'mdadm',
      'nfs',
      'nfsd',
      'pressure',
      'timex',
      'xfs',
      'zfs',
    ],
    extra_options => "--collector.textfile.directory='$textfile_directory'",
  }

  file { $textfile_directories:
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { $textfile_scripts_directories:
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { "$textfile_scripts_directory/apt.sh":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => "puppet:///modules/repose_prometheus/apt.sh",
    require => File[$textfile_scripts_directory],
  }

  cron { 'apt-textfile':
      ensure  => present,
      command => "/bin/bash $textfile_scripts_directory/apt.sh > $textfile_directory/apt.prom.$$ && mv $textfile_directory/apt.prom.$$ $textfile_directory/apt.prom",
      user    => 'root',
      hour    => '*/4',
      minute  => 0,
      require => [
        File["$textfile_scripts_directory/apt.sh"],
        File[$textfile_directory],
      ],
  }
}
