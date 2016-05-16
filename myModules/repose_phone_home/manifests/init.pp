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
    manage_package_repo => true,
    server_package_name => 'mongodb-org',
    version             => '2.6.9',
  }

  class {'::mongodb::server':
    port    => $mongo_port,
    verbose => true,
    auth    => true,
  }

  mongodb::db { $mongo_dbname:
    user     => $mongo_username,
    password => $mongo_password,
    roles    => 'readWrite',
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
      'id'      => '7DE3B25953451D589081071ED823DD83CE616558',
      'content' => '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.10 (GNU/Linux)
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3vhD
-----END PGP PUBLIC KEY BLOCK-----',
    },
  }

  package{ "repose-phone-home":
    ensure  => present,
    require => [
      Apt::Source['repose'],
      Exec['apt_update'],
    ],
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
    require => [
      Mongodb::Db["$mongo_dbname"],
      Package['repose-phone-home'],
      File['/opt/repose-phone-home/application.properties'],
    ],
  }

  firewall{ '101 http access':
    dport  => [80, 8080],
    proto  => tcp,
    action => accept,
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
