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
    include default_node
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
