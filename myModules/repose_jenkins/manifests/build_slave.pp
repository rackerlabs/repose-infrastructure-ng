class repose_jenkins::build_slave {

  class { 'repose_jenkins::modern_slave':
    groups => 'docker'
  }

  class { 'repose_maven':
    user      => 'jenkins',
    user_home => "${repose_jenkins::jenkins_home}",
    require   => User["jenkins"],
  }

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

  group { 'docker':
    ensure => present,
  }

  package { 'gcc':
    # This is needed by API-Checker's use of Nailgun
    ensure => present,
  }

  class { 'python' :
    version    => '2.7',
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'absent',
    gunicorn   => 'absent',
  }

  python::pip { 'docutils':
    pkgname => 'docutils',
  }
}
