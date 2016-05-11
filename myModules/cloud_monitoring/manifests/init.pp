##
# uses a hiera auto-complete variable cloud_monitoring::token
# just make sure that's in your hiera somewhere, and then you win a trophy
class cloud_monitoring(
    $token = "NOT CONFIGURED"
) {

    # package url and where the signature is
    $package_url = "http://stable.packages.cloudmonitoring.rackspace.com"
    $signing_url = "https://monitoring.api.rackspacecloud.com/pki/agent"

    # can only support debian flavors at this point.
    case $operatingsystem{
        debian: {
            info("Can support debian")
            include apt
            apt::source { 'rackspace_monitoring':
                location   => "${package_url}/debian-${lsbdistcodename}-x86_64",
                release    => "cloudmonitoring",
                repos      => "main",
                key        => "D05AB914",
                key_source => "${signing_url}/linux.asc"
            }
        }
        ubuntu: {
            info("Can support ubuntu")
            include apt
            apt::source { 'rackspace_monitoring':
                location   => "${package_url}/ubuntu-${lsbdistrelease}-x86_64",
                release    => "cloudmonitoring",
                repos      => "main",
                key        => "D05AB914",
                key_source => "${signing_url}/linux.asc"
            }
        }
        default: { fail("Unrecognized OS for cloud_monitoring") }
    }

    package{ ['rackspace-monitoring-agent', 'aptitude']:
        ensure  => present,
        require => [
            Apt::Source['rackspace_monitoring'],
            Exec['apt_update'],
        ],
    }

    file{ "/etc/rackspace-monitoring-agent.cfg":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 0600,
        content => template("cloud_monitoring/rackspace-monitoring-agent.cfg.erb"),
    }

    service{ "rackspace-monitoring-agent":
        ensure  => running,
        enable  => true,
        require => [
            File["/etc/rackspace-monitoring-agent.cfg"],
            Package["rackspace-monitoring-agent"]
        ],
    }
}
