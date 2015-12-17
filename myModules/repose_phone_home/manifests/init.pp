class repose_phone_home(
  $daemon_user    = undef,
  $daemon_group   = undef,
  $mongo_host     = "localhost",
  $mongo_port     = 27017,
  $mongo_username = undef,
  $mongo_password = undef,
  $mongo_dbname   = undef,
) {

  class {'::mongodb::globals':
    version => 2.6,
  }

  class {'::mongodb::server':
    port    => $mongo_port,
    verbose => true,
    auth => true,
  }

  mongodb::db { $mongo_dbname:
    user     => $mongo_username,
    password => $mongo_password,
  }

  package{ "openjdk-6-jre-headless":
    ensure => absent,
  }

  package{ "openjdk-7-jre-headless":
    ensure => present,
  }

  apt::source { 'repose':
    location => 'http://repo.openrepose.org/debian',
    release  => 'stable',
    repos    => 'main',
    key      => {
      'id'     => '52F39F131FE73BBC5AFCB3D0389195C8E7C89BBB',
      'server' => 'pgp.mit.edu',
    },
  }

  package{ "repose-phone-home":
    ensure => present,
    require => Apt::Source['repose'],
  }

  file{ '/opt/repose-phone-home/application.properties':
    ensure  => file,
    owner   => $daemon_user,
    group   => $daemon_group,
    mode    => 0600,
    content => template('repose_phone_home/application.properties.erb'),
    require => [
      Package['repose-phone-home']
    ],
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
