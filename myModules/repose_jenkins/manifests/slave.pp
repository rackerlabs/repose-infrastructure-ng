# Actually installs jenkins, rather than waiting for the master to push the JAR
class repose_jenkins::slave(
  $deploy_key = undef,
  $deploy_key_pub = undef,
  $repo_key = undef,
  $repo_key_pub = undef,
  $saxon_ee_license = undef,
  $groups = [],
  $java_package = 'openjdk-8-jdk'
) {

  class { 'repose_jenkins':
    java_package => $java_package
  }

  include repose_jenkins::gpgkey

  group { 'jenkins':
    ensure => present,
  }

  user { 'jenkins':
    ensure     => present,
    gid        => 'jenkins',
    groups     => $groups,
    home       => $repose_jenkins::jenkins_home,
    shell      => '/bin/bash',
    managehome => true,
  }


  file { "${repose_jenkins::jenkins_home}/.ssh":
    ensure  => directory,
    owner   => jenkins,
    group   => jenkins,
    mode    => '0700',
  }

  file{ "${repose_jenkins::jenkins_home}/.ssh/id_rsa":
    ensure  => file,
    mode    => 0600,
    owner   => jenkins,
    group   => jenkins,
    content => "${deploy_key}",
    require => File["${repose_jenkins::jenkins_home}/.ssh"],
  }

  file{ "${repose_jenkins::jenkins_home}/.ssh/id_rsa.pub":
    mode    => 0600,
    owner   => jenkins,
    group   => jenkins,
    content => "${deploy_key_pub}",
    require => File["${repose_jenkins::jenkins_home}/.ssh"],
  }

  file{ "${repose_jenkins::jenkins_home}/.ssh/repo_key":
    mode    => 0600,
    owner   => jenkins,
    group   => jenkins,
    content => "${repo_key}",
    require => File["${repose_jenkins::jenkins_home}/.ssh"],
  }

  file{ "${repose_jenkins::jenkins_home}/.ssh/repo_key.pub":
    mode    => 0600,
    owner   => jenkins,
    group   => jenkins,
    content => "${repo_key_pub}",
    require => File["${repose_jenkins::jenkins_home}/.ssh"],
  }

  file{ "${repose_jenkins::jenkins_home}/saxon_ee":
    ensure  => directory,
    owner   => jenkins,
    group   => jenkins,
    mode    => 0750,
    require => User['jenkins'],
  }

  file { "${repose_jenkins::jenkins_home}/saxon_ee/saxon-license.lic":
    ensure  => file,
    owner   => jenkins,
    group   => jenkins,
    mode    => 0440,
    content => "${saxon_ee_license}",
    require => File["${repose_jenkins::jenkins_home}/saxon_ee"],
  }

}
