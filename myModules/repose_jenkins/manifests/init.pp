# Installs base layer, but no jenkins itself. Perfect for a slave configuration.
# also used by the master, basically anything that wants to run our jenkins jobs
# Depends on garethr/remotesyslog to activate remote syslog for things on this host
class repose_jenkins(
    $java_package = 'openjdk-8-jdk'
) {

    $jenkins_home = '/var/lib/jenkins'
    $github_key_info = hiera_hash("base::github_host_key", { "key" => "DEFAULT", "type" => "ssh-rsa" })

    case $operatingsystem{
        debian: {
            info("Can support debian")
            include apt
            # This is where Open JDK 8 is located.
            class{ 'apt::backports':
              pin    => 500,
              notify => Exec['apt_update'],
            }
        }
        ubuntu: {
            info("Can support ubuntu")
            include apt
        }
        default: { fail("Unrecognized OS for repose_sonar") }
    }

# this should ensure we've got java on the system at jdk8. Installed via package
# it will give us JDK8 however.
# this is really stupid, for some reason it can't pick up the proper package version
# and is doing stupid things, so I have to tell it everything basically.
# the example42 one is more reliable, but I can't use it because it conflicts.
# this will get us whatever the latest version is at the time
# I don't know why it doesn't work like it's supposed to :|
# I'm really only using it at this point because the rtyler/jenkins module wants it :|
    class{ 'java':
        distribution => 'jdk',
        package      => $java_package,
        version      => 'present',
    }

    package { 'git':
        ensure => present,
    }

#jenkins master needs a git config so that it can talk to the scm plugin
# Also needed by any of the release builds for when they do a git push
    file{ "${jenkins_home}/.gitconfig":
        ensure => file,
        mode   => 0664,
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
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDRLK7eHYRbfj/NgIUlc8ECZD9EFwvj4ZvQDrkMX+4HBcpvQr6vVvQlezx7qtCnpZtPYbQvp0udxsfU9+ESlBMGcZBPjnJsKqlomYwaKcxaNKXe4FXGB9fi3si0fEt90pNBqTMjwOzzHj8jqu7PSz5A4tHfdNdJ+IN8IWI4S/YeqVXrdPtsM4Kpi/woSEYUd9Ma4ia/0fHjg4S6/Nb1cFFtx5OQejS6NIpOT3AcSkvOGfDQPHO3GhhZTufbmWeCiT4cOCgCZmlT6eDpl3R8eXWKIn6UGmBSfV1pqs7DFKSGMepV2HVsEtoButIlSfj2BP2mFJ6g1SstDsWCaw+jbtyN',
        user    => 'jenkins'
    }

    file { "${repose_jenkins::jenkins_home}/.ssh":
      ensure  => directory,
      owner   => jenkins,
      group   => jenkins,
      mode    => '0700',
    }

    file{ "${repose_jenkins::jenkins_home}/.ssh/id_rsa":
      ensure  => file,
      mode    => 0600,
      owner   => jenkins,
      group   => jenkins,
      content => "${deploy_key}",
      require => File["${repose_jenkins::jenkins_home}/.ssh"],
    }

    file{ "${repose_jenkins::jenkins_home}/.ssh/id_rsa.pub":
      mode    => 0600,
      owner   => jenkins,
      group   => jenkins,
      content => "${deploy_key_pub}",
      require => File["${repose_jenkins::jenkins_home}/.ssh"],
    }
}
