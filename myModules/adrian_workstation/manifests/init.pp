class adrian_workstation {
  class{'basic_workstation':
    user      => 'adrian',
    fullName  => 'Adrian George',
    email     => 'adrian.george@rackspace.com',
    sso       => 'adrian.george',
  }

  include google_chrome

  package { 'nautilus-dropbox':
    ensure  => present,
  }

  include apt
  apt::source { 'vivaldi':
    location => 'http://repo.vivaldi.com/stable/deb/',
    release  => 'stable',
    repos    => 'main',
    key      => {
      'id'     => '68AEAE71F9FA158703C1CBBC8D04CE49EFB20B23',
    },

    notify => Exec['apt_update'],
  }
  package { 'vivaldi-stable':
    ensure  => present,
    require => Apt::Source['vivaldi'],
  }
}
