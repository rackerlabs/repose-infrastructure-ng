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

node "prometheus.openrepose.org" {
    include default_node
    include repose_prometheus::server
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
