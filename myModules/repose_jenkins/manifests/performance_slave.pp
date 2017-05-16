class repose_jenkins::performance_slave {

  include 'repose_jenkins::modern_slave'

  package { ['build-essential', 'software-properties-common', 'python-software-properties', 'python-pip',
             'python2.7-dev', 'python-setuptools', 'sshpass', 'libffi-dev', 'libssl-dev']:
    ensure => present,
  }

  python::pip { 'markupsafe' :
    pkgname => 'markupsafe',
  }

  python::pip { 'ansible' :
    pkgname => 'ansible',
    ensure  => '2.3.0.0',
  }

  python::pip { 'pyrax' :
    pkgname => 'pyrax',
  }

  python::pip { 'six' :
    pkgname      => 'six',
    install_args => '--upgrade',
  }}
