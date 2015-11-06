# Aggregates all the various dev tools we use
class basic_workstation::dev_tools(
  $user = undef,
  $name = undef,
  $email = undef,
  $user_home = "/home/$user"
) {
  #java
  class{ 'java':
    distribution => 'jdk',
    package      => 'openjdk-7-jdk',
    version      => 'present',
  }

  #groovy
  class{'groovy':
    version => '2.4',
  }

  #scala
  include 'scala'

  #maven
  class{"repose_maven":
    user => "${user}",
  }

  #gradle
  include repose_gradle

  #intellij idea
  class{ 'idea::ultimate':
    version => '15.0',
    build   => '143.381.42',
  }

  #network tools
  package {['stunnel4', 'wireshark']:
    ensure => present,
  }

  #git
  package {['git', 'gitk']:
    ensure => present
  }

  file {"$user_home/.gitconfig":
    content => template("basic_workstation/gitconfig"),
    owner   => $user,
    group   => $user,
    require => Package['git']
  }

  #debug tools
  package {'visualvm':
    ensure => present
  }

  #VMs for testing
  include virtualbox
  include vagrant

  #vim
  package {'vim-gnome':
    ensure => present
  }
}
