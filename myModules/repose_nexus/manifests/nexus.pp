class repose_nexus::nexus(
    $version = "2.10.0-02",
    $location = "/opt/nexus",
    $work_directory = "/srv/sonatype-work"
) {
# a wrapper class for the sonatype nexus setup

    include java

    include wget

    include repose_nexus::user
    include repose_nexus::work_directory

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
        notify  => Service['nexus'],
    }

    service{ 'nexus':
        ensure  => running,
        enable  => true,
        require => [
            Class['java', 'repose_nexus::user', 'repose_nexus::work_directory'],
            File['nexus-symlink', '/etc/init.d/nexus', '/opt/nexus/']
        ],
    }

    include base::nginx

    file{ '/etc/nginx/conf.d/10-nexus.conf':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 0644,
        content => template('repose_nexus/nginx.conf.erb'),
        require => Package['nginx'],
        notify  => Service['nginx'],
    }
}