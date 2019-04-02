class repose_grafana {
  class { 'grafana':
    install_method => 'repo',
    version        => '6.1.0',
    cfg            => {
      app_mode         => 'production',
      users            => {
        allow_sign_up  => false,
      },
      'auth.anonymous' => {
        enabled        => true,
      },
    },
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
  $targetName = 'performance_grafana'
  $duplicityScript = "/usr/local/bin/duplicity_$targetName.rb"

  backup_cloud_files::target { $targetName :
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
    command => $duplicityScript,
    user    => root,
    hour    => 13,
    minute  => 0,
    require => Backup_cloud_files::Target[$targetName],
  }

  # schedule a clean up of the backups once a month
  cron { 'duplicity_cleanup':
    ensure   => present,
    # escape the `\` and `$` characters so that neither Puppet nor the shell interpolate
    # we literally want to pass `$url` as an argument to the Duplicity script
    command  => "$duplicityScript remove-older-than 1M --force \\\$url",
    user     => root,
    monthday => 1,
    hour     => 3,
    minute   => 0,
    require  => Backup_cloud_files::Target[$targetName],
  }

  #Papertrail the grafana logs
  $papertrail_port = hiera("base::papertrail_port", 1)
  class {'papertrail':
    destination_host => 'logs.papertrailapp.com',
    destination_port => 0 + $papertrail_port,
    files            => [
      '/var/log/grafana/grafana.log',
      '/var/log/nginx/error.log'
    ],
  }
}
