class basic_workstation::hosts(
  $username = undef
) {

  package { 'clusterssh':
    ensure => present,
  }

  #hosts
  host { 'jenkins-master':
    ip  => '104.130.124.20',
  }

  host { 'jenkins-build-slave-01':
    ip  => '166.78.186.146',
  }

  host { 'jenkins-build-slave-02':
    ip  => '166.78.186.175',
  }

  host { 'jenkins-build-slave-03':
    ip  => '166.78.135.191',
  }

  host { 'jenkins-build-slave-04':
    ip  => '166.78.135.193',
  }

  host { 'jenkins-build-slave-05':
    ip  => '166.78.135.194',
  }

  host { 'jenkins-build-slave-06':
    ip  => '166.78.135.196',
  }

  host { 'jenkins-build-slave-07':
    ip  => '166.78.135.200',
  }

  host { 'jenkins-build-slave-08':
    ip  => '166.78.135.214',
  }

  host { 'jenkins-build-slave-09':
    ip  => '166.78.135.220',
  }

  host { 'jenkins-build-slave-10':
    ip  => '166.78.151.210',
  }

  host { 'jenkins-intense-slave-01':
    ip  => '166.78.145.70',
  }

  host { 'jenkins-intense-slave-02':
    ip  => '166.78.145.86',
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

  host { 'prometheus':
    ip => '104.130.132.138',
  }

  host { 'puppet':
    ip => '162.209.77.69',
  }

  host { 'redirects':
    ip => '104.239.240.195',
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

  host { 'nexus':
    ip => '162.209.78.219',
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