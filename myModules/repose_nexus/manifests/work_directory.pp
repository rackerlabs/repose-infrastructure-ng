class repose_nexus::work_directory {
    include repose_nexus::user

    file{ '/srv/sonatype-work':
        ensure  => directory,
        owner   => 'nexus',
        group   => 'nexus',
        mode    => '0755',
        require => Class['repose_nexus::user'],
    }

    file{ '/srv/sonatype-work/nexus':
        ensure  => directory,
        owner   => 'nexus',
        group   => 'nexus',
        mode    => '0755',
        require => File['/srv/sonatype-work'],
    }

    file{'/srv/sonatype-work/nexus/plugin-repository':
        ensure => directory,
        owner => "nexus",
        group => "nexus",
        mode => '0755',
        require => File['/srv/sonatype-work/nexus'],
    }
}