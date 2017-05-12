# Actually installs jenkins, rather than waiting for the master to push the JAR
class repose_jenkins::slave(
  $deploy_key = undef,
  $deploy_key_pub = undef,
  $repo_key = undef,
  $repo_key_pub = undef,
  $saxon_ee_license = undef
) {

  include repose_jenkins

  include repose_jenkins::gpgkey

  # ensure docker is installed to verify releases, and give the docker0
  # bridge a static IP to match firewall rules
  class { 'docker':
    bip => '172.17.0.1/16',
  }

  # Docker requires certain iptables rules to be setup for containers to
  # access the internet. Docker will automatically setup these rules when the
  # service is run. However, the firewall Puppet module will purge the rules
  # that Docker set up whenever it runs. Setting the iptables rules through
  # the firewall module should solve this issue.
  firewallchain { 'DOCKER:nat:IPv4':
    ensure => 'present',
    purge  => 'true',
  }->
  firewall { '200 route local through DOCKER':
    table    => 'nat',
    chain    => 'PREROUTING',
    proto    => 'all',
    dst_type => 'LOCAL',
    jump     => 'DOCKER',
  }->
  firewall { '201 OUTPUT LOCAL through DOCKER':
    table       => 'nat',
    chain       => 'OUTPUT',
    proto       => 'all',
    destination => '! 127.0.0.0/8',
    dst_type    => 'LOCAL',
    jump        => 'DOCKER',
  }->
  firewall { '202 MASQUERADE output interface not docker0':
    table    => 'nat',
    chain    => 'POSTROUTING',
    proto    => 'all',
    source   => '172.17.0.0/16',
    outiface => '! docker0',
    jump     => 'MASQUERADE',
  }->
  firewall { '203 RETURN input interface docker0':
    table   => 'nat',
    chain   => 'DOCKER',
    proto   => 'all',
    iniface => 'docker0',
    jump    => 'RETURN',
  }

  firewallchain { 'DOCKER:filter:IPv4':
    ensure => 'present',
    purge  => 'true',
  }->
  firewallchain { 'DOCKER-ISOLATION:filter:IPv4':
    ensure => 'present',
    purge  => 'true',
  }->
  firewall { '300 FORWARD to DOCKER-ISOLATION':
    table => 'filter',
    chain => 'FORWARD',
    proto => 'all',
    jump  => 'DOCKER-ISOLATION',
  }->
  firewall { '301 route to docker0 through DOCKER':
    table    => 'filter',
    chain    => 'FORWARD',
    proto    => 'all',
    outiface => 'docker0',
    jump     => 'DOCKER',
  }->
  firewall { '302 ACCEPT states to docker0 FORWARD':
    table    => 'filter',
    chain    => 'FORWARD',
    proto    => 'all',
    outiface => 'docker0',
    ctstate  => ['RELATED', 'ESTABLISHED'],
    action   => 'accept',
  }->
  firewall { '303 ACCEPT docker0 to not docker0 FORWARD':
    table    => 'filter',
    chain    => 'FORWARD',
    proto    => 'all',
    iniface  => 'docker0',
    outiface => '! docker0',
    action   => 'accept',
  }->
  firewall { '304 ACCEPT docker0 to docker0 FORWARD':
    table    => 'filter',
    chain    => 'FORWARD',
    proto    => 'all',
    iniface  => 'docker0',
    outiface => 'docker0',
    action   => 'accept',
  }->
  firewall { '305 RETURN DOCKER-ISOLATION':
    table => 'filter',
    chain => 'DOCKER-ISOLATION',
    proto => 'all',
    jump  => 'RETURN',
  }

  $jenkins_home = '/var/lib/jenkins'

  class{"repose_gradle":
    user      => 'jenkins',
    user_home => "${jenkins_home}",
    daemon    => false,
    require  => User["jenkins"],
  }

  class{"repose_maven":
    user      => 'jenkins',
    user_home => "${jenkins_home}",
    require  => User["jenkins"],
  }

  # anything that's going to run jenkins stuff will need rpm
  package { 'rpm':
    # I don't think we care about the version here...
    ensure => present,
  }

  package { 'expect':
    # This is needed by the rpm-maven-plugin
    ensure => present,
  }

  package { 'dpkg-sig':
    # This is needed by the jdeb maven plugin
    ensure => present,
  }

  package { 'gcc':
    # This is needed by API-Checker's use of Nailgun
    ensure => present,
  }


  group { 'jenkins':
    ensure => present,
  }

  group { 'docker':
    ensure => present,
  }

  user { 'jenkins':
    ensure     => present,
    gid        => 'jenkins',
    groups     => 'docker',
    home       => $jenkins_home,
    shell      => '/bin/bash',
    managehome => true,
    require    => Group['docker'],
  }


  #all this key stuff may actually need to be moved back up
  #dependening on wether or not master is the guy trying to push the packages to the repo
  file { "${jenkins_home}/.ssh":
    ensure  => directory,
    owner   => jenkins,
    group   => jenkins,
    mode    => '0700',
  }

  file{ "${jenkins_home}/.ssh/id_rsa":
    ensure  => file,
    mode    => 0600,
    owner   => jenkins,
    group   => jenkins,
    content => "${deploy_key}",
    require => File["${jenkins_home}/.ssh"],
  }

  file{ "${jenkins_home}/.ssh/id_rsa.pub":
    mode    => 0600,
    owner   => jenkins,
    group   => jenkins,
    content => "${deploy_key_pub}",
    require => File["${jenkins_home}/.ssh"],
  }

  file{ "${jenkins_home}/.ssh/repo_key":
    mode    => 0600,
    owner   => jenkins,
    group   => jenkins,
    content => "${repo_key}",
    require => File["${jenkins_home}/.ssh"],
  }

  file{ "${jenkins_home}/.ssh/repo_key.pub":
    mode    => 0600,
    owner   => jenkins,
    group   => jenkins,
    content => "${repo_key_pub}",
    require => File["${jenkins_home}/.ssh"],
  }

  file{ "${jenkins_home}/saxon_ee":
    ensure  => directory,
    owner   => jenkins,
    group   => jenkins,
    mode    => 0750,
    require => User['jenkins'],
  }

  file { "${jenkins_home}/saxon_ee/saxon-license.lic":
    ensure  => file,
    owner   => jenkins,
    group   => jenkins,
    mode    => 0440,
    content => "${saxon_ee_license}",
    require => File["${jenkins_home}/saxon_ee"],
  }

}
