#Installs gradle
class repose_gradle(
  $version = '2.8',
  $base_url = 'http://downloads.gradle.org/distributions',
  $sha256 = '65f3880dcb5f728b9d198b14d7f0a678d35ecd33668efc219815a9b4713848be',
  $user = undef,
  $user_home = "/home/${user}"
) {

  #downloads and explodes the given version
  archive{ "gradle-$version":
    ensure           => present,
    url              => "${base_url}/gradle-${version}-all.zip",
    follow_redirects => true,
    target           => "/opt",
    extension        => "zip",
    checksum         => false,
    digest_type      => 'sha256',
    digest_string    => $sha256,
  }

  file {"$user_home/.gradle/gradle.properties":
    content => template("repose_gradle/gradle.properties.erb"),
    owner   => "$user",
    group   => "$user",
    mode    => 0600,
  }

  #links it for conveince
  file{'gradle-symlink':
    path => '/opt/gradle',
    ensure => link,
    target => "/opt/gradle-${version}",
    require => Archive["gradle-${version}"]
  }
}