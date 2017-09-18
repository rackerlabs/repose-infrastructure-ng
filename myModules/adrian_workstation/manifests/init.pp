class adrian_workstation {
  class{'basic_workstation':
    user      => 'adrian',
    fullName  => 'Adrian George',
    email     => 'adrian.george@rackspace.com',
    sso       => 'adrian.george',
  }

  include google_chrome

  package { ['hexchat', 'nautilus-dropbox']:
    ensure  => present,
  }

  include apt
  apt::source { 'vivaldi':
    location => 'http://repo.vivaldi.com/stable/deb/',
    release  => 'stable',
    repos    => 'main',
    key      => {
      'id'     => 'ED18652D86E25D422EA7CE132CC26F777B8B44A1',
    },

    notify => Exec['apt_update'],
  }
  package { 'vivaldi-stable':
    ensure  => present,
    require => Apt::Source['vivaldi'],
  }
}
