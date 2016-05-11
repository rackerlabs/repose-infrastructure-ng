##
# uses a hiera auto-complete variable cloud_monitoring::token
# just make sure that's in your hiera somewhere, and then you win a trophy
class cloud_monitoring(
    $token = "NOT CONFIGURED"
) {

# can do centos6 and debian at this point, I think
    case $operatingsystem{
        centos: { info("Can support Centos 6") }
        debian: {
            info("Can support debian")
            class { 'apt':
                frequency => always,
            }
        }
        ubuntu: {
            info("Can support ubuntu")
            class { 'apt':
                always_apt_update    => true,
                update_timeout       => 100,
                fancy_progress       => true,
            }
        }
        default: { fail("Unrecognized OS for cloud_monitoring") }
    }

# package url and where the signature is
    $package_url = "http://stable.packages.cloudmonitoring.rackspace.com"
    $signing_url = "https://monitoring.api.rackspacecloud.com/pki/agent"

    if( $operatingsystem == "centos" ){
        yumrepo{ "rackspace_monitoring":
            descr   => "Rackspace Cloud Monitoring",
            baseurl => "${package_url}/centos-6-x86_64",
            gpgkey  => "${signing_url}/centos-6.asc",
            enabled => 1,
        }

        package{ "rackspace-monitoring-agent":
            ensure  => present,
            require => Yumrepo["rackspace_monitoring"],
        }
    }

    if( $operatingsystem == "debian") {
        apt::source { 'rackspace_monitoring':
            location   => "${package_url}/debian-${lsbdistcodename}-x86_64",
            release    => "cloudmonitoring",
            repos      => "main",
            key        => "D05AB914",
            key_source => "${signing_url}/linux.asc"
        }

        package{ ['rackspace-monitoring-agent', 'aptitude']:
            ensure  => present,
            require => [
                Apt::Source['rackspace_monitoring'],
                Exec['apt_update'],
            ],
        }
    }

    if( $operatingsystem == "ubuntu" ) {
        apt::source { 'rackspace_monitoring':
            location   => "${package_url}/ubuntu-${lsbdistrelease}-x86_64",
            release    => "cloudmonitoring",
            repos      => "main",
            key        => "D05AB914",
            key_source => "${signing_url}/linux.asc"
        }

        package{ ['rackspace-monitoring-agent', 'aptitude']:
            ensure  => present,
            require => [
                Apt::Source['rackspace_monitoring'],
                Exec['apt_update'],
            ],
        }
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