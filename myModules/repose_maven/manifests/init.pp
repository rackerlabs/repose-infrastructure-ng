#Installs maven and settings for uploading to our repo
class repose_maven(
  $maven_version = "3.2.2",
  $user = undef,
  $user_home = "/home/${user}",
  $inova_username = undef,
  $inova_password = undef,
  $research_nexus_username = undef,
  $research_nexus_password = undef
) {

  #Installs maven
  class{ "maven::maven":
    version => "${maven_version}",
  }

  #Installs settings and sets up maven opts
  maven::environment { 'maven-jenkins':
    user       => "${user}",
    home       => "${user_home}",
    maven_opts => '-Xms512m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=512m -XX:-UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled',
    require    => Class['java'],
  }

  #Link to the common spot for ease of use
  file{ "/opt/maven":
    ensure  => link,
    target  => "/opt/apache-maven-${maven_version}",
    require => Class['java'],
  }

  file { "${user_home}/.m2":
      ensure  => directory,
      owner   => $user,
      group   => $user,
      mode    => '0755',
  }

  file{ "${user_home}/.m2/settings.xml":
      mode    => 0600,
      owner   => $user,
      group   => $user,
      content => template("repose_maven/m2settings.xml.erb"),
      require => File["${user_home}/.m2"]
  }
}