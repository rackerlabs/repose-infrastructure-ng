
# Installs base layer, but no jenkins itself. Perfect for a slave configuration.
class jenkins {

    include common_utils
    include manual_java
    include manual_groovy
    include manual_maven
    include manual_gradle
    include git

    $jenkins_home = '/var/lib/jenkins'
    $iptables_dir = '/etc/sysconfig'

    package {'expect':
        ensure      => 'installed',
    }


    package { 'rpm-build':
        ensure => '4.8.0-37.el6',
    }

    group {'jenkins':
        ensure => present,
    }

    user {'jenkins':
        ensure     => present,
        gid        => 'jenkins',
        home       => $jenkins_home,
        shell      => '/bin/bash',
        managehome => true,
    }

    ssh_authorized_key {'jenkins':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAuy/VESlo9iZAa9YQbEv9JGvvEsRKC3HxW2XivlDchGOxUNfrdaBGtFjMPe5rf6Qlv1hJ8bvHqZgCQIWYigRF45GXPJXGCaMWFoADG5+Mtr4SfoOWE8i6rVRphaKdIDV+UlhNQWlr4Cw/K4sgJB671qbSQjkn1H2uHiECMB1iUBtE8aOyDQm2bNzHh2sVyrDbUDm7zU354dIo84r3HhHVsK+3d0IhkiIhtWXc7IH4wL0pJ8B2Iv6FVLsQlY+pibGBPQzns25j83bPN01tj2JAxe6EqgsUyIJVu3Hb4UpFWkWquLQnOg0xbRHP/UnK5bQb/NI1ly/HKvt9xxQH8cEERQ==',
        user    => 'jenkins'
    }

    file { "${jenkins_home}/.ssh":
        ensure  => directory,
        owner   => jenkins,
        group   => jenkins,
        mode    => '0700',
    }

    file { ["${jenkins_home}/.m2", "${jenkins_home}/.gradle", "${jenkins_home}/plugins"]:
        ensure  => directory,
        owner   => jenkins,
        group   => jenkins,
        mode    => '0755',
        require => User['jenkins']
    }


    file { '/etc/localtime':
        ensure => present,
        source => '/usr/share/zoneinfo/US/Central',
    }

    ### Configure Networking

    file { "${iptables_dir}/iptables":
        ensure  => present,
        source  => 'puppet:///modules/jenkins/iptables',
        owner   => root,
        group   => root,
        mode    => '0644'
    }

    service { 'iptables':
        ensure    => running,
        enable    => true,
        subscribe => File['/etc/sysconfig/iptables'],
    }

}
