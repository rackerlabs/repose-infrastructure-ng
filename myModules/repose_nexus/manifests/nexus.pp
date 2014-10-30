class repose_nexus::nexus(
    $version = "2.10.0-02",
    $location = "/opt/nexus",
    $work_directory = "/srv/sonatype-work"
) {
# a wrapper class for the sonatype nexus setup

    include java

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
        path    => '/opt/nexus',
        ensure  => link,
        target  => "/opt/nexus-${version}",
        require => Exec['nexus-untar'],
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
        mode   => 0755,
    }

    file{ '/opt/nexus/conf/nexus.properties':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 0644,
        source  => "puppet:///modules/repose_nexus/nexus.properties",
        require => File['nexus-symlink'],
    }

    file{ '/srv/sonatype-work':
        ensure  => directory,
        owner   => 'nexus',
        group   => 'nexus',
        mode    => 0755,
        require => [User['nexus'], Group['nexus']],
    }

    file{ '/srv/sonatype-work/nexus':
        ensure  => directory,
        owner   => 'nexus',
        group   => 'nexus',
        mode    => 0755,
        require => File['/srv/sonatype-work'],
    }

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

    service{ 'nexus':
        ensure  => running,
        enable  => true,
        require => [
            Class['java'],
            User['nexus'],
            File['nexus-symlink', '/etc/init.d/nexus', '/opt/nexus/']
        ],
    }
}