# Installs base layer, but no jenkins itself. Perfect for a slave configuration.
# also used by the master, basically anything that wants to run our jenkins jobs
# Depends on garethr/remotesyslog to activate remote syslog for things on this host
class repose_jenkins(
    $deploy_key = undef,
    $deploy_key_pub = undef,
) {

    $jenkins_home = '/var/lib/jenkins'
    $github_key_info = hiera_hash("base::github_host_key", { "key" => "DEFAULT", "type" => "ssh-rsa" })

    case $operatingsystem {
        debian: {
            info("Can support debian")
            include apt
            # This is where Open JDK 8 is located.
            class { 'apt::backports':
              notify => Exec['apt_update'],
            }

            apt::pin { 'backports_java':
              packages => ['ca-certificates-java', 'openjdk-8-jre-headless', 'openjdk-8-jre', 'openjdk-8-jdk'],
              priority => 500,
              release  => 'jessie-backports',
              require  => Class['apt::backports'],
              notify   => Exec['apt_update'],
            }
        }
        ubuntu: {
            info("Can support ubuntu")
            include apt
        }
        default: { fail("Unrecognized OS for repose_jenkins") }
    }

    # todo: on first run, the Java 8 package is not available
    # By installing via package, we ensure that Java 8 can be installed.
    class { 'java':
        distribution => 'jdk',
        package      => 'openjdk-8-jdk',
        version      => 'latest',
    }

    package { 'git':
        ensure => present,
    }

    # Jenkins master needs a git config so that it can talk to the scm plugin
    # Also needed by any of the release builds for when they do a git push
    file { "${jenkins_home}/.gitconfig":
        ensure => file,
        mode   => '0664',
        owner  => jenkins,
        group  => jenkins,
        source => "puppet:///modules/repose_jenkins/jenkins-gitconfig",
    }

    Sshkey<|title == 'github.com'|> {
        ensure => present,
        name   => $github_key_info["name"],
        key    => $github_key_info["key"],
        type   => $github_key_info["type"],
        target => "${jenkins_home}/.ssh/known_hosts"
    }

    ssh_authorized_key { 'jenkins':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => $deploy_key_pub,
        user    => 'jenkins'
    }

    file { "${jenkins_home}/.ssh":
      ensure  => directory,
      owner   => jenkins,
      group   => jenkins,
      mode    => '0700',
    }

    file { "${jenkins_home}/.ssh/id_rsa":
      ensure  => file,
      mode    => '0600',
      owner   => jenkins,
      group   => jenkins,
      content => "${deploy_key}",
      require => File["${jenkins_home}/.ssh"],
    }

    file { "${jenkins_home}/.ssh/id_rsa.pub":
      ensure  => file,
      mode    => '0600',
      owner   => jenkins,
      group   => jenkins,
      content => "ssh-rsa ${deploy_key_pub} Jenkins Key",
      require => File["${jenkins_home}/.ssh"],
    }
}
