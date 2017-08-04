class repose_grafana {
  package { 'apt-transport-https':
    ensure  => present,
  }

  class { 'grafana':
    install_method => 'repo',
    version        => '4.4.2',
    cfg            => {
      app_mode => 'production',
      users    => {
        allow_sign_up => false,
      },
    },
    require => Package['apt-transport-https'],
  }

  firewall { '101 http access':
    dport  => ['80', '3000'],
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '102 forward port 80 to 3000':
    table   => 'nat',
    chain   => 'PREROUTING',
    proto   => 'tcp',
    dport   => '80',
    jump    => 'REDIRECT',
    toports => '3000'
  }

  $grafana_backups = '/srv/grafana-backups'
  backup_cloud_files::target { 'performance_grafana':
    target            => $grafana_backups,
    cf_username       => hiera('rs_cloud_username'),
    cf_apikey         => hiera('rs_cloud_apikey'),
    cf_region         => 'DFW',
    duplicity_options => '--full-if-older-than 15D --volsize 250 --exclude-other-filesystems --no-encryption',
  }

  cron { 'grafana_backup':
    ensure  => present,
    command => "cp -rf /var/lib/grafana $grafana_backups",
    user    => 'root',
    hour    => 12,
    minute  => 0,
    require => Class['grafana'],
  }

  cron { 'duplicity_backup':
    ensure  => present,
    command => '/usr/local/bin/duplicity_performance_grafana.rb',
    user    => root,
    hour    => 13,
    minute  => 0,
    require => Backup_cloud_files::Target['performance_grafana'],
  }

  # schedule a clean up of the backups once a month
  cron { 'duplicity_cleanup':
    ensure   => present,
    command  => '/usr/local/bin/duplicity_performance_grafana.rb remove-older-than 1M --force \$url',
    user     => root,
    monthday => 1,
    hour     => 3,
    minute   => 0,
    require  => Backup_cloud_files::Target['performance_grafana'],
  }

  #Papertrail the grafana logs
  $papertrail_port = hiera("base::papertrail_port", 1)
  class { 'remotesyslog':
    port => $papertrail_port,
    logs => [
      '/var/log/grafana/grafana.log'
    ],
  }
}
