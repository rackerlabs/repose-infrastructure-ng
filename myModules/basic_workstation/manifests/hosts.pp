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

  host { 'jenkins-slave-1':
    ip  => '23.253.107.170',
  }

  host { 'jenkins-slave-2':
    ip  => '104.130.141.56',
  }

  host { 'jenkins-slave-3':
    ip  => '23.253.76.22',
  }

  host { 'jenkins-slave-4':
    ip => '23.253.76.118',
  }

  host { 'jenkins-slave-5':
    ip => '23.253.245.21',
  }

  host { 'jenkins-slave-6':
    ip => '23.253.105.232',
  }

  host { 'jenkins-slave-7':
    ip => '23.253.242.98',
  }

  host { 'jenkins-slave-8':
    ip => '23.253.102.99',
  }

  host { 'jenkins-slave-9':
    ip => '23.253.242.9',
  }

  host { 'mumble':
    ip => '23.253.107.117',
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
    ip => '162.209.77.79',
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