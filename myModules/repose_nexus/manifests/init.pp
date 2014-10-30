class repose_nexus {

    include repose_nexus::nexus
    include repose_nexus::user

    file{ 'nexus-apt-bundle':
        ensure  => file,
        owner   => 'nexus',
        group   => 'nexus',
        mode    => 0444,
        source  => "puppet:///modules/repose_nexus/nexus-apt-plugin-1.0.1-bundle.zip",
        require => Class['repose_nexus::user'];
    }

# setup some plugins
    repose_nexus::plugin{ 'nexus-apt-plugin-1.0.1-bundle.zip':
        plugin_folder => 'nexus-apt-plugin-1.0.1',
        require       => File['nexus-apt-bundle'],
    }

}