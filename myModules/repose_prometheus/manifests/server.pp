class repose_prometheus::server {

  # While it would be nice to re-use the autohttps class, we want to expose multiple
  # endpoints on this host (Prometheus and Alertmanager, at least) which means
  # proxying from port 443 to the correct endpoint becomes a challenge.
  # Particularly because Prometheus and Alertmanager link to themselves in some
  # way and there is not always an easy way to update that link to point to
  # nginx instead.
  # While we could separate our services across multiple hosts to address this
  # issue, we only want to maintain a single host for Prometheus for now.
  #
  # Redirect HTTP traffic to HTTPS
  # include base::nginx::autohttps
  include base::nginx

  # Set up Postfix to enable sending email alerts
  include base::mail_sender

  # Allow connections to Alertmanager (so that email links work)
  firewall { '200 Alertmanager':
    dport  => '9093',
    action => 'accept',
  }

  firewall { '201 Blackbox Exporter':
    dport  => '9115',
    action => 'accept',
  }

  # Terminate SSL using Nginx and proxy to Prometheus
  file { '/etc/nginx/sites-enabled/prometheus.openrepose.org':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/repose_prometheus/nginx/sites-enabled/prometheus.openrepose.org",
    require => [
      Package['nginx'],
      File['/etc/nginx/nginx-ssl.conf'],
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
