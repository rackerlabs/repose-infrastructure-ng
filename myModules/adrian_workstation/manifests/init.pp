class adrian_workstation {
  class{'basic_workstation':
    user      => 'adrian',
    fullName  => 'Adrian George',
    email     => 'adrian.george@rackspace.com',
    sso       => 'adrian.george',
  }

  include google_chrome

  package { ['hexchat', 'dropbox']:
    ensure  => present,
  }
}
