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

class { ['base::fw_pre', 'base::fw_post']: }

node 'puppet.openrepose.org' {
    include default_node
    include puppet_master
}

node /^build-slave-[0-9]*\.openrepose\.org$/ {
    include default_node
    include repose_jenkins::build_slave
}

node /^intense-slave-[0-9]*\.openrepose\.org$/ {
    include default_node
    include repose_jenkins::build_slave
}

node /^legacy-slave-[0-9]*\.openrepose\.org$/ {
    include default_node
    include repose_jenkins::legacy_slave
}

node /^performance-slave-[0-9]*\.openrepose\.org$/ {
    include default_node
    include repose_jenkins::performance_slave
}

node "jenkins.openrepose.org" {
    include default_node
    include repose_jenkins::master
}

node "nexus.openrepose.org" {
    include default_node
    # this server has been rebuilt
    # TODO: Update the manifest.
    #include repose_nexus
}

node "redirects.openrepose.org" {
    include default_node
    include repose_redirects
}

node "nagios.openrepose.org" {
    include default_node
    include repose_nagios::server
}

node "influxdb.openrepose.org" {
    include default_node
    include repose_influxdb
}

node "grafana.openrepose.org" {
    include default_node
    include repose_grafana
}

node "adrian-new-work-laptop.openrepose.org" {
    include adrian_workstation
}

node "phone-home.openrepose.org" {
    include default_node
    include repose_phone_home
}
