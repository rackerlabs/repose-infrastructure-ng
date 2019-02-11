class repose_nexus {

    include repose_nexus::nexus
    include repose_nexus::user

    $apt_plugin ='/srv/sonatype-work/nexus-apt-plugin-1.0.1-bundle.zip'

    file{ 'nexus-apt-bundle':
        path    => $apt_plugin,
        ensure  => file,
        owner   => 'nexus',
        group   => 'nexus',
        mode    => '0444',
        source  => "puppet:///modules/repose_nexus/nexus-apt-plugin-1.0.1-bundle.zip",
        require => Class['repose_nexus::user', 'repose_nexus::work_directory'];
    }

# setup some plugins
    repose_nexus::plugin{ "${apt_plugin}":
        plugin_folder => 'nexus-apt-plugin-1.0.1',
        require       => File['nexus-apt-bundle'],
    }

}