class repose_jenkins::performance_slave {

  include 'repose_jenkins::modern_slave'

  package { ['build-essential', 'software-properties-common', 'python-software-properties', 'python-pip',
             'python2.7-dev', 'python-setuptools', 'sshpass', 'libffi-dev', 'libssl-dev']:
    ensure  => present,
  }
}
