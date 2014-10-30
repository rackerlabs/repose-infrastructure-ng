class repose_nexus::nexus(
    $version = "2.10.0-02",
    $location = "/opt/nexus",
    $work_directory = "/srv/sonatype-work"
) {
# a wrapper class for the sonatype nexus setup

    include wget

    $archive = "/opt/nexus-${version}-bundle.tar.gz"

    wget::fetch{ 'fetch-nexus':
        source      => "http://download.sonatype.com/nexus/oss/nexus-${version}-bundle.tar.gz",
        destination => $archive,
        cache_dir   => '/var/cache/wget',
        before      => Exec['nexus-untar'],
        notify      => Exec['nexus-untar'],
    }

    exec{ 'nexus-untar':
        command     => "tar xf ${archive}",
        cwd         => '/opt',
        creates     => "/opt/nexus-${version}",
        path        => ['/bin', '/usr/bin'],
        notify      => Exec['nexus-dir-perms'],
        refreshonly => true,
    }

    file{ 'nexus-symlink':
        path   => '/opt/nexus',
        ensure => link,
        target => "/opt/nexus-${version}",
    }

    exec{ 'nexus-dir-perms':
        command     => "chown nexus:nexus logs tmp",
        cwd         => "/opt/nexus-${version}",
        path        => ['/bin', '/usr/bin'],
        require     => User['nexus'],
        refreshonly => true,
    }

    file{ '/etc/init.d/nexus':
        ensure => file,
        source => "puppet:///modules/repose_nexus/nexus",
        owner  => root,
        group  => root,
        mode   => 0744,
    }

    user{ 'nexus':
        ensure => present,
        uid    => 5000,
        gid    => 5000,
        home   => '/srv/sonatype-work',
        shell  => '/bin/bash',
    }

    service{ 'nexus':
        ensure  => running,
        enable  => true,
        require => [
            User['nexus'],
            File['nexus-symlink', '/etc/init.d/nexus']
        ],
    }
}