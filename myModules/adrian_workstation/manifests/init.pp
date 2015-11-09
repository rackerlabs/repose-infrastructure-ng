class adrian_workstation {
  class{'basic_workstation':
    user  => 'adrian',
    name  => 'Adrian George',
    email => 'adrian.george@rackspace.com',
    sso   => 'adrian.george',
  }

  include google_chrome

  apt::ppa { 'ppa:gwendal-lebihan-dev/hexchat-stable':
    require => Class['basic_workstation']
  }

  package { 'hexchat':
    ensure  => present,
    require => Apt::Ppa['ppa:gwendal-lebihan-dev/hexchat-stable'],
  }
}
