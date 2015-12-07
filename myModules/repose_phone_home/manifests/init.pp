class repose_phone_home(
  $daemon_user    = undef,
  $daemon_group   = undef,
  $mongo_host     = "localhost",
  $mongo_port     = 27017,
  $mongo_username = undef,
  $mongo_password = undef,
) {

#  class {'::mongodb::globals':
#    manage_package_repo => true,
#  } ->
  class {'::mongodb::server':
    port    => $mongo_port,
    verbose => true,
    auth => true,
  }

  mongodb::db { 'phoneHomeReports':
    user     => $mongo_username,
    password => $mongo_password,
  }

  package{ "openjdk-6-jre-headless":
    ensure => absent,
  }

  package{ "openjdk-7-jre-headless":
    ensure => present,
  }

#  package{ "repose-phone-home":
#    ensure => present,
#  }

  file{ '/etc/repose-phone-home/repose-phone-home.cfg':
    ensure  => file,
    owner   => $daemon_user,
    group   => $daemon_group,
    mode    => 0600,
    content => template('repose_phone_home/repose-phone-home.cfg.erb'),
#    require => [
#      Package['repose-phone-home']
#    ],
    notify  => Service['repose-phone-home'],
  }

  service{ "repose-phone-home":
    ensure  => running,
    enable  => true,
  }

  firewall {'102 forward port 80 to 8080':
    table       => 'nat',
    chain       => 'PREROUTING',
    proto       => 'tcp',
    dport       => '80',
    jump        => 'REDIRECT',
    toports     => '8080'
  }
}
