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
        command => "tar xf ${archive}",
        cwd     => '/opt',
        creates => "/opt/nexus-${version}",
        path    => ['/bin', '/usr/bin']
    }
}