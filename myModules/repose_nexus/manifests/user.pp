class repose_nexus::user {
    group{ 'nexus':
        ensure => present,
        gid    => 5000,
    }

    user{ 'nexus':
        ensure  => present,
        uid     => 5000,
        gid     => 5000,
        home    => '/srv/sonatype-work',
        shell   => '/bin/bash',
        require => Group['nexus'],
    }
}