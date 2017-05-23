class repose_jenkins::performance_slave(
  $cloud_username = undef,
  $cloud_api_key = undef
) {

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
  }

  file { "${repose_jenkins::jenkins_home}/.raxpub":
    content => template("repose_jenkins/.raxpub.erb"),
    owner   => jenkins,
    group   => jenkins,
  }

  file { "${repose_jenkins::jenkins_home}/.ssh/authorized_keys":
    mode    => 0600,
    owner   => jenkins,
    group   => jenkins,
    content => "${repose_jenkins::slave::deploy_key_pub}",
    require => File["${repose_jenkins::jenkins_home}/.ssh"],
  }

  file { "${repose_jenkins::jenkins_home}/.ssh/config":
    owner   => jenkins,
    group   => jenkins,
    source  => "puppet:///modules/repose_jenkins/slave_ssh_config",
    require => File["${repose_jenkins::jenkins_home}/.ssh"],
  }
}
