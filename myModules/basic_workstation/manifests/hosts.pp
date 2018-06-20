class basic_workstation::hosts(
  $username = undef
) {

  package { 'clusterssh':
    ensure => present,
  }

  #hosts
  host { 'jenkins-master':
    ip  => '104.130.136.216',
  }

  host { 'jenkins-build-slave-01':
    ip  => '192.237.202.250',
  }

  host { 'jenkins-build-slave-02':
    ip  => '192.237.213.179',
  }

  host { 'jenkins-build-slave-03':
    ip  => '192.237.202.214',
  }

  host { 'jenkins-build-slave-04':
    ip  => '166.78.186.17',
  }

  host { 'jenkins-build-slave-05':
    ip  => '198.101.238.138',
  }

  host { 'jenkins-legacy-slave-01':
    ip => '166.78.135.180',
  }

  host { 'jenkins-performance-slave-01':
    ip => '104.239.140.74',
  }

  host { 'jenkins-performance-slave-02':
    ip => '174.143.130.100',
  }

  host { 'jenkins-performance-slave-03':
    ip => '23.253.109.45',
  }

  host { 'jenkins-slave-10':
    ip => '23.253.99.94',
  }

  host { 'jenkins-slave-11':
    ip => '23.253.99.171',
  }

  host { 'jenkins-slave-12':
    ip => '23.253.94.140',
  }

  host { 'jenkins-slave-13':
    ip => '23.253.99.251',
  }

  host { 'nagios':
    ip => '104.239.133.25',
  }

  host { 'puppet-master':
    ip => '104.239.240.48',
  }

  host { 'nginx':
    ip => '23.253.237.132',
  }

  host { 'sonar':
    ip => '23.253.235.84',
  }

  host { 'phone-home':
    ip => '162.209.78.12',
  }

  host { 'influxdb':
    ip => '162.242.254.160',
  }

  host { 'grafana':
    ip => '104.130.2.85',
  }

  #cluster config
  file { '/etc/clusters':
    source  => 'puppet:///modules/basic_workstation/clusters_config',
  }

  #ssh config
  file {"/home/$username/.ssh":
    ensure  => directory,
    mode    => '0700',
    owner   => $username,
    group   => $username,
  }

  file {"/home/$username/.ssh/config":
    owner   => $username,
    group   => $username,
    mode    => '0600',
    source  => 'puppet:///modules/basic_workstation/ssh_config',
    require => File["/home/$username/.ssh"],
  }

}