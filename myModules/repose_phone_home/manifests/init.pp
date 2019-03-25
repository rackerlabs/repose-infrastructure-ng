class repose_phone_home(
  $daemon_user    = undef,
  $daemon_group   = undef,
  $mongo_host     = 'localhost',
  $mongo_port     = 27017,
  $mongo_username = undef,
  $mongo_password = undef,
  $mongo_dbname   = undef,
) {

  include apt
  class { 'apt::backports':
    notify => Exec['apt_update'],
  }

  apt::pin { 'backports_java':
    packages => ['ca-certificates-java', 'openjdk-7-jre-headless', 'openjdk-7-jre', 'openjdk-7-jdk'],
    priority => 500,
    release  => "${lsbdistcodename}-backports",
    require  => Class['apt::backports'],
    notify   => Exec['apt_update'],
  }

  class {'::mongodb::globals':
    manage_package_repo => true,
    server_package_name => 'mongodb-org',
    version             => '2.6.12',
    notify              => Exec['apt_update'],
  }

  class {'::mongodb::server':
    port    => 0 + $mongo_port,
    verbose => true,
    auth    => true,
  }

  mongodb::db { $mongo_dbname:
    user     => $mongo_username,
    password => $mongo_password,
    roles    => ['readWrite'],
  }

  apt::source { 'repose':
    location     => 'https://nexus.openrepose.org/repository/debian',
    architecture => 'all',
    release      => 'stable',
    repos        => 'main',
    key          => {
      'id'       => '52F39F131FE73BBC5AFCB3D0389195C8E7C89BBB',
      'source'   => 'https://nexus.openrepose.org/repository/el/RPM_GPG_KEY-openrepose',
    },
  }

  package{ "repose-phone-home":
    ensure  => present,
    require => [
      Apt::Source['repose'],
      Apt::Pin['backports_java']
    ],
  }

  file{ '/opt/repose-phone-home/application.properties':
    ensure  => file,
    owner   => $daemon_user,
    group   => $daemon_group,
    mode    => '0600',
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
