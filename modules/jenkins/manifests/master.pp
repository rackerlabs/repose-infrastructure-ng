
# Actually installs jenkins, rather than waiting for the master to push the JAR
class jenkins::master {
    include common_utils
    include manual_java
    include manual_groovy
    include manual_maven
    include manual_gradle
    include git

    $jenkins_home = '/var/lib/jenkins'
    $iptables_dir = '/etc/sysconfig'

    yumrepo { 'jenkins':
        baseurl     => 'http://pkg.jenkins-ci.org/redhat',
        descr       => 'The jenkins repository',
        enabled     => '1',
    }

    exec { 'rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key':
        path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
        refreshonly => true,
        subscribe   => Yumrepo['jenkins'],
        require     => Yumrepo['jenkins'],
    }

    package { 'jenkins':
        ensure      => '1.538-1.1',
        require     => Exec['rpm --import \
            http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key'],
    }

    file { "${jenkins_home}/hudson.tasks.Maven.xml":
        ensure  => present,
        source  => 'puppet:///modules/jenkins_master/maven-plugin-config',
        owner   => jenkins,
        group   => jenkins,
        mode    => '0644',
        require => Package['jenkins']
    }

    file { "/etc/sysconfig/jenkins":
        ensure  => present,
        source  => 'puppet:///modules/jenkins_master/jenkins-sysconfig',
        owner   => root,
        group   => root,
        mode    => '0600',
        require => Package['jenkins'],
    }

    service { 'jenkins':
        ensure      => running,
        require     => [Package['jenkins'], Class['manual_java'], File['/etc/sysconfig/jenkins']],
        enable      => true
    }


}