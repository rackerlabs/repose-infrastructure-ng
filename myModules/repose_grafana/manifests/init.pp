class repose_grafana {
  package { 'apt-transport-https':
    ensure  => present,
  }

  class { 'grafana':
    install_method => 'repo',
    version        => '4.2.0',
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
}
