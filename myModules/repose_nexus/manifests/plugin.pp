class repose_nexus::plugin(
    $bundle = $name,
    $creates = undef,
) {
    if ! $bundle {
        fail("A nexus plugin bundle zip file must be specified")
    }

    if ! $creates {
        fail("Need to specify a directory the bundle will create")
    }

    include repose_nexus::user
    include repose_nexus::work_directory

    exec{ "extract-${bundle}":
        command     => "unzip ${bundle}",
        cwd         => "/srv/sonatype-work/nexus/plugin-repository",
        creates     => $creates,
        path        => ['/bin', '/usr/bin'],
        require     => Class['repose_nexus::work_directory'],
        refreshonly => true,
        notify      => Service['nexus'],
    }

}