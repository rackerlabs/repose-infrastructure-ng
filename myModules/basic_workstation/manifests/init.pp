class basic_workstation(
  $user = undef,
  $fullName = undef,
  $email = undef,
  $user_home = "/home/$user",
  $sso = undef
) {

  class {'basic_workstation::dev_tools':
    user      => "${user}",
    fullName  => "${fullName}",
    email     => "${email}",
    user_home => "${user_home}",
  }

  class {'basic_workstation::hosts':
    username => "${user}",
  }

  class {'basic_workstation::gpgkey':
    user => "${user}",
  }

  file {"$user_home/.bash_aliases":
    source => 'puppet:///modules/basic_workstation/bash_aliases',
    owner  => $user,
    group  => $user,
  }
}
