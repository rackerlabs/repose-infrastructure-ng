
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

    # just setting swap size to a 4GB swapfile no matter what
    # if this becomes a problem in the future, change it, or make it more dynamic
    # the base::swap class will base it on the size of the ram, if not specified
    base::swap { 'swapfile':
        swapfile => '/swapfile',
        swapsize => 4096,
    }
}

node 'puppet.openrepose.org' inherits default {
    include puppet_master
}

node jenkinsSlaves inherits default {
    include repose_jenkins
}

#TODO: eventually make this a regexp for all numbered slaves
node "slave4.openrepose.org" inherits jenkinsSlaves {

}

node "slave5.openrepose.org" inherits jenkinsSlaves {
    
}

node "jenkins-proto.openrepose.org" inherits default {
    include repose_jenkins
    include repose_jenkins::master
}

node "sonar-ng.openrepose.org" inherits default {
    include repose_sonar
}
