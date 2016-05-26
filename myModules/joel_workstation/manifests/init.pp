class joel_workstation {
  class{'basic_workstation':
    user      => 'joelrizner',
    fullName  => 'Joel Rizner',
    email     => 'joel.rizner@rackspace.com',
    sso       => 'joel0111',
  }

  include google_chrome

  package { ['hexchat', 'nautilus-dropbox']:
    ensure  => present,
  }
}
