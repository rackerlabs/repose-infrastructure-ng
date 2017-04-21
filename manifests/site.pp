# we want all firewall resources purged, so only the puppet ones apply
resources { "firewall":
    purge => true
}
# resources { 'firewallchain':
#     purge => true,
# }

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

    # have to actually include it!
    include repose_nagios::client
}

node 'puppet.openrepose.org' inherits default {
    include puppet_master
}

node jenkinsSlaves inherits default {
    include repose_jenkins
}

node /^slave[1-9]\.openrepose\.org$/ inherits jenkinsSlaves {

}

node "jenkins-proto.openrepose.org" inherits default {
    include repose_jenkins
    include base::nginx::autohttps

    # TODO: Fix the coordination between the repose_jenkins::master class and
    # the repose_jenkins class.
    # Note that repose_jenkins::master includes repose_jenkins.
    # The jenkins resource in repose_jenkins::master attempts to create a user
    # and group that were already created by the repose_jenkins class,
    # which fails the application of this manifest for this node.
    # This resource also attempts to create a number of directories already
    # created by the repose_jenkins class, which also fails the application of
    # this manifest for this node.
    #
    # include repose_jenkins::master
}

node "sonar.openrepose.org" inherits default {
    include repose_sonar
}

node "mumble.openrepose.org" inherits default {
    include mumble_server
}

# this server has been deleted
node "nexus.openrepose.org" inherits default {
    include repose_nexus
}

node "redirects.openrepose.org" inherits default {
    include repose_redirects
}

node "nagios.openrepose.org" inherits default {
    include repose_nagios::server
}

node "influxdb.openrepose.org" inherits default {
    include repose_influxdb
}

node "adrian-home-desktop-vm.openrepose.org" {
    include adrian_workstation
}

node "adrian-home-laptop-vm.openrepose.org" {
    include adrian_workstation
}

node "adrian-new-work-laptop.openrepose.org" {
    include adrian_workstation
}

node "joelrizner-latitude-e7450.openrepose.org" {
    include joel_workstation
}

node "phone-home.openrepose.org" inherits default {
    include repose_phone_home
}

node "work-desktop.openrepose.org" {
    include adrian_workstation
}
