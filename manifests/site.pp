
# we want all firewall resources purged, so only the puppet ones apply
resources { "firewall":
    purge => true
}

Firewall {
    before  => Class['base::fw_post'],
    require => Class['base::fw_pre'],
}


node default {
    include users
    include base
    include cloud_monitoring

    # include the pre and post firewall stuff for all hosts
    class { ['base::fw_pre', 'base::fw_post']: }
    class { 'firewall': }
}

node 'puppet.openrepose.org' inherits default {
    include puppet_master
}

node jenkinsSlaves inherits default {
    # need
    # jdk, git, maven, gradle
    # special deploy ssh keys
    include jenkins
}