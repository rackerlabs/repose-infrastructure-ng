#Installs gradle
class repose_gradle(
  $version = '4.10',
  $base_url = 'http://downloads.gradle.org/distributions',
  $user = undef,
  $user_home = "/home/${user}",
  $daemon = true,
  $research_nexus_username = undef,
  $research_nexus_password = undef,
  $openrepose_nexus_username = undef,
  $openrepose_nexus_password = undef,
  $docker_hub_username = undef,
  $docker_hub_password = undef,
  $signing_passphrase = undef,
  $publish_key = undef,
  $publish_secret = undef,
) {

  #downloads and explodes the given version
  archive { "gradle-${version}":
    ensure          => present,
    path            => "/tmp/gradle-${version}-all.zip",
    extract         => true,
    extract_path    => '/opt',
    creates         => '/opt/gradle-${version}',
    source          => "${base_url}/gradle-${version}-all.zip",
    checksum_verify => false,
  }

  file { "${user_home}/.gradle":
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }

  file {"$user_home/.gradle/gradle.properties":
    content => template("repose_gradle/gradle.properties.erb"),
    owner   => $user,
    group   => $user,
    mode    => 0600,
    require => File["${user_home}/.gradle"]
  }

  #links it for conveince
  file {'gradle-symlink':
    path    => '/opt/gradle',
    ensure  => link,
    target  => "/opt/gradle-${version}",
    require => Archive["gradle-${version}"]
  }

  #adds it to the path
  file {'/etc/profile.d/append-gradle-path.sh':
    mode    => 644,
    content => 'PATH=$PATH:/opt/gradle/bin',
    require => File['gradle-symlink'],
  }
}
