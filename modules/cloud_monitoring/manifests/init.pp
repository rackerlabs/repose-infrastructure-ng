class cloud_monitoring {

    # Just a catch to fail if we're not on CentOS, Update appropriately for debians and such
    case $operatingsystem{
        centos: { info("Can support Centos 6") }
        default: { fail("Unrecognized OS for cloud_monitoring") }
    }

    # package url and where the signature is
    $package_url = "http://stable.packages.cloudmonitoring.rackspace.com"
    $signing_url = "https://monitoring.api.rackspacecloud.com/pki/agent"

    yumrepo{"rackspace_monitoring":
        descr => "Rackspace Cloud Monitoring",
        baseurl => "${package_url}/centos-6-x86_64",
        gpgkey => "${signing_url}/centos-6.asc",
        enabled => 1,
    }

    package{"rackspace-monitoring-agent":
        ensure => present,
        require => Yumrepo["rackspace_monitoring"],
    }

    #TODO: set up eyaml stuff for this guy
    file{"/etc/rackspace-monitoring-agent.cfg":
        ensure => present,
        owner => root,
        group => root,
        mode => 0600,
        source => "puppet:///modules/cloud_monitoring/rackspace-monitoring-agent.cfg",
    }

    service{"rackspace-monitoring-agent":
        ensure => running,
        enable => true,
        require => [
            File["/etc/rackspace-monitoring-agent.cfg"],
            Package["rackspace-monitoring-agent"]
        ],
    }

}