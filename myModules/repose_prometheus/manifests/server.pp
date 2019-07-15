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
    # TODO: Move alerts config to hiera
    alerts         => {
      'groups' => [
        {
          'name'  => 'alert.rules',
          'rules' => [
            {
              'alert'       => 'InstanceDown',
              'expr'        => 'up == 0',
              'for'         => '5m',
              'labels'      => {
                'severity'    => 'critical',
              },
              'annotations' => {
                'summary'     => 'Instance {{ $labels.instance }} down',
                'description' => '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.',
              },
            },
            {
              'alert'       => 'PackagesOutdated',
              'expr'        => 'apt_upgrades_pending > 0',
              'for'         => '15m',
              'labels'      => {
                'severity'    => 'warning',
              },
              'annotations' => {
                'summary'     => 'Instance {{ $labels.instance }} has outdated packages installed',
                'description' => '{{ $labels.instance }} of job {{ $labels.job }} has had outdated packages for more than 15 minutes.',
              },
            },
            {
              'alert'       => 'PuppetAgentDown',
              'expr'        => 'node_systemd_unit_state{name="puppet.service",state="active"} == 0',
              'for'         => '5m',
              'labels'      => {
                'severity'    => 'warning',
              },
              'annotations' => {
                'summary'     => 'Instance {{ $labels.instance }} is not running a Puppet agent',
                'description' => '{{ $labels.instance }} of job {{ $labels.job }} has not been running a Puppet agent for more than 5 minutes.',
              },
            },
            {
              'alert'       => 'NodeExporterDown',
              'expr'        => 'node_systemd_unit_state{name="node_exporter.service",state="active"} == 0',
              'for'         => '5m',
              'labels'      => {
                'severity'    => 'warning',
              },
              'annotations' => {
                'summary'     => 'Instance {{ $labels.instance }} is not running a Node exporter',
                'description' => '{{ $labels.instance }} of job {{ $labels.job }} has not been running a Node exporter for more than 5 minutes.',
              },
            },
            {
              'alert'       => 'RackspaceMonitoringDown',
              'expr'        => 'node_systemd_unit_state{name="rackspace-monitoring-agent.service",state="active"} == 0',
              'for'         => '5m',
              'labels'      => {
                'severity'    => 'warning',
              },
              'annotations' => {
                'summary'     => 'Instance {{ $labels.instance }} is not running Rackspace monitoring',
                'description' => '{{ $labels.instance }} of job {{ $labels.job }} has not been running Rackspace monitoring for more than 5 minutes.',
              },
            },
            {
              'alert'       => 'HighCpuUsage',
              'expr'        => '(100 - (avg by (instance) (irate(node_cpu_seconds_total{job="node",mode="idle"}[5m])) * 100)) >= 85',
              'for'         => '5m',
              'labels'      => {
                'severity'    => 'warning',
              },
              'annotations' => {
                'summary'     => 'Instance {{ $labels.instance }} has high CPU usage',
                'description' => '{{ $labels.instance }} has high CPU usage.',
              },
            },
            {
              'alert'       => 'LowMemory',
              'expr'        => 'round(node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100) <= 20',
              'for'         => '5m',
              'labels'      => {
                'severity'    => 'warning',
              },
              'annotations' => {
                'summary'     => 'Instance {{ $labels.instance }} is low on available memory',
                'description' => '{{ $labels.instance }} of job {{ $labels.job }} has {{ $value }}% available memory.',
              },
            },
            {
              'alert'       => 'LowDiskSpace',
              'expr'        => 'round(node_filesystem_avail_bytes{fstype!="tmpfs"} / node_filesystem_size_bytes{fstype!="tmpfs"} * 100) <= 20',
              'for'         => '5m',
              'labels'      => {
                'severity'    => 'warning',
              },
              'annotations' => {
                'summary'     => 'Instance {{ $labels.instance }} is low on disk space (/dev/xvda1)',
                'description' => '{{ $labels.instance }} of job {{ $labels.job }} has {{ $value }}% free disk space on /dev/xvda1.',
              },
            },
            {
              'alert'       => 'SslCertExpiring',
              'expr'        => 'probe_ssl_earliest_cert_expiry - time() < 86400 * 30',
              'for'         => '5m',
              'labels'      => {
                'severity'    => 'critical',
              },
              'annotations' => {
                'summary'     => 'Instance {{ $labels.instance }} has an expiring SSL certificate',
                'description' => '{{ $labels.instance }} has an SSL certificate expiring soon.',
              },
            },
          ],
        },
      ],
    },
    # TODO: Move scrape config to hiera
    scrape_configs => [
      {
        'job_name'        => 'prometheus',
        'scrape_interval' => '10s',
        'scrape_timeout'  => '5s',
        'static_configs'  => [
          {
            'targets' => [
              'localhost:9090',
            ],
            # Part of the Puppet module default -- an example of how to add arbitrary labels for a job
            # 'labels'  => {
            #   'alias' => 'Prometheus',
            # },
          },
        ],
      },
      {
        'job_name'        => 'node',
        'scrape_interval' => '10s',
        'scrape_timeout'  => '5s',
        'static_configs'  => [
          {
            # Node exporter targets should be added here
            'targets' => [
              'localhost:9100',
              'grafana.openrepose.org:9100',
              'nagios.openrepose.org:9100',
              'redirects.openrepose.org:9100',
              'influxdb.openrepose.org:9100',
              'puppet.openrepose.org:9100',
              'phone-home.openrepose.org:9100',
              'jenkins.openrepose.org:9100',
              'build-slave-01.openrepose.org:9100',
              'build-slave-02.openrepose.org:9100',
              'build-slave-03.openrepose.org:9100',
              'build-slave-04.openrepose.org:9100',
              'build-slave-05.openrepose.org:9100',
              'build-slave-06.openrepose.org:9100',
              'build-slave-07.openrepose.org:9100',
              'build-slave-08.openrepose.org:9100',
              'build-slave-09.openrepose.org:9100',
              'build-slave-10.openrepose.org:9100',
              'intense-slave-01.openrepose.org:9100',
              'intense-slave-02.openrepose.org:9100',
              'performance-slave-01.openrepose.org:9100',
              'performance-slave-02.openrepose.org:9100',
              'performance-slave-03.openrepose.org:9100',
              'legacy-slave-01.openrepose.org:9100',
            ],
          },
        ],
      },
      {
        'job_name'        => 'blackbox',
        'metrics_path'    => '/probe',
        'params'          => {
          'module' => [
            'http_2xx',
          ],
        },
        'scrape_interval' => '60s',
        'scrape_timeout'  => '5s',
        'static_configs'  => [
          {
            # HTTPS targets should be added here
            'targets' => [
              'https://prometheus.openrepose.org',
              'https://jenkins.openrepose.org',
            ],
          },
        ],
        'relabel_configs' => [
          {
            'source_labels' => [
              '__address__',
            ],
            'target_label'  => '__param_target',
          },
          {
            'source_labels' => [
              '__param_target',
            ],
            'target_label'  => 'instance',
          },
          {
            'replacement'   => 'localhost:9115',
            'target_label'  => '__address__',
          },
        ],
      },
    ],
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
