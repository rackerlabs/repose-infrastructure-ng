define repose_nexus::plugin(
    $bundle = $name,
    $plugin_folder = undef,
) {
    if ! $bundle {
        fail("A nexus plugin bundle zip file must be specified")
    }

    if ! $plugin_folder {
        fail("Need to specify a directory the bundle will create")
    }

    include repose_nexus::user
    include repose_nexus::work_directory

    exec{ "extract-${bundle}":
        command     => "unzip ${bundle}",
        cwd         => "/srv/sonatype-work/nexus/plugin-repository",
        creates     => "/srv/sonatype-work/nexus/plugin-repository/${plugin_folder}",
        path        => ['/bin', '/usr/bin'],
        require     => Class['repose_nexus::work_directory'],
        notify      => Service['nexus'],
    }

}