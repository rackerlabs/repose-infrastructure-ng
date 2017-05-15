class repose_jenkins::modern_slave(
  $groups = []
) {

  class { 'repose_jenkins::slave':
    groups => $groups
  }

  class{"repose_gradle":
    user      => 'jenkins',
    user_home => "${repose_jenkins::jenkins_home}",
    daemon    => false,
    require   => User["jenkins"],
  }

}
