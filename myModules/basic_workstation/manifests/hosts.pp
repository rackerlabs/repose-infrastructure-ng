class basic_workstation::hosts(
  $username = undef
) {

  package { 'clusterssh':
    ensure => present,
  }

  #hosts
  host { 'jenkins-master':
    ip  => '23.253.73.121',
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
    ip => '174.143.130.208',
  }

  host { 'mumble':
    ip => '23.253.107.17',
  }

  host { 'nagios':
    ip => '104.239.133.25',
  }

  host { 'performance':
    ip => '166.78.190.199',
  }

  host { 'puppet-master':
    ip => '23.253.105.35',
  }

  host { 'nginx':
    ip => '23.253.237.132',
  }

  host { 'sonar':
    ip => '23.253.234.86',
  }

  host { 'phone-home':
    ip => '162.209.77.79',
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