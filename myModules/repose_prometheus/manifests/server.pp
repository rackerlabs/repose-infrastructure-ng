class repose_prometheus::server {

  # Redirect HTTP traffic to HTTPS and handle basic authentication
  include base::nginx::autohttps
  include base::nginx::basic_auth

  # Set up Postfix to enable sending email alerts
  include base::mail_sender

  # Allow connections to Alertmanager
  firewall { '200 Alertmanager':
    dport  => '19093',
    action => 'accept',
  }

  # Terminate SSL using Nginx and proxy to Prometheus
  file { '/etc/nginx/sites-available/prometheus.openrepose.org':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/repose_prometheus/nginx/sites-available/prometheus.openrepose.org",
    require => [
      Package['nginx'],
      File['/etc/nginx/nginx-ssl.conf'],
    ],
    notify  => Service['nginx'],
  }

  file { '/etc/nginx/sites-enabled/prometheus.openrepose.org':
    ensure  => link,
    target  => '/etc/nginx/sites-available/prometheus.openrepose.org',
    require => [
      File['/etc/nginx/sites-available/prometheus.openrepose.org'],
    ],
    notify  => Service['nginx'],
  }

  class { 'prometheus::server':
    version        => '2.11.1',
    alertmanagers_config => [
      {
        'static_configs' => [
          {
            'targets' => [
              'localhost:9093',
            ],
          },
        ],
      },
    ],
    extra_options  => '--web.external-url=\'https://prometheus.openrepose.org\' --web.route-prefix=\'/\'',
  }

  class { 'prometheus::alertmanager':
    version   => '0.18.0',
    global    => {
      'smtp_smarthost' => 'localhost:25',
      'smtp_from'      => 'alertmanager@prometheus.openrepose.org',
    },
    route     => {
      'receiver'       => 'email',
      'group_by'       => [
        'alertname',
      ],
      'group_wait'     => '30s',
      'group_interval' => '5m',
      'repeat_interval'=> '2h',
    },
    receivers => [
      {
        'name'          => 'email',
        'email_configs' => [
          {
            'to'          => 'reposecore@rackspace.com',
            'require_tls' => false,
          },
        ],
      },
    ],
    extra_options  => '--web.external-url=\'https://prometheus.openrepose.org:19093\' --web.route-prefix=\'/\'',
  }

  class { 'prometheus::blackbox_exporter':
    version => '0.14.0',
    modules => {
      http_2xx => {
        prober => 'http',
      },
    },
  }
}
