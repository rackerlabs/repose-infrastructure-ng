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

node /^build-slave-[0-9]*\.openrepose\.org$/ inherits default {
    include repose_jenkins::build_slave
}

node /^intense-slave-[0-9]*\.openrepose\.org$/ inherits default {
    include repose_jenkins::build_slave
}

node /^legacy-slave-[0-9]*\.openrepose\.org$/ inherits default {
    include repose_jenkins::legacy_slave
}

node /^performance-slave-[0-9]*\.openrepose\.org$/ inherits default {
    include repose_jenkins::performance_slave
}

node "jenkins.openrepose.org" inherits default {
    include repose_jenkins::master
}

node "sonar.openrepose.org" inherits default {
    include repose_sonar
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

node "grafana.openrepose.org" inherits default {
    include repose_grafana
}

node "adrian-new-work-laptop.openrepose.org" {
    include adrian_workstation
}

node "phone-home.openrepose.org" inherits default {
    include repose_phone_home
}
