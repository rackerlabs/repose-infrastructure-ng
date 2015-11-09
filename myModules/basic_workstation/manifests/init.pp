class basic_workstation(
  $user = undef,
  $name = undef,
  $email = undef,
  $user_home = "/home/$user",
  $sso = undef
) {

  include apt
  apt::ppa { 'ppa:mumble/release': }

  package { 'mumble':
    ensure  => present,
    require => Apt::Ppa['ppa:mumble/release'],
  }

  file {"$user_home/.bash_aliases":
    source => 'puppet:///modules/basic_workstation/bash_aliases',
    owner  => $user,
    group  => $user,
  }
}