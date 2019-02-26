class puppet_master(
    $puppet_version = "6.2.0-1${lsbdistcodename}"
) {
    # Hold the Puppet Server package at the desired version so that Nagios does not
    # alert us of updates that we don't want to consume.
    apt::pin { 'puppet_server':
        packages => 'puppetserver',
        version  => $puppet_version,
        priority => 1001,
    }

    # using https://github.com/TomPoulton/hiera-eyaml
    # need our eyaml backend
    package{ "hiera-eyaml":
        ensure   => installed,
        provider => 'gem',
    }

    # Since the keys created by puppetmaster when it installs are used to sign the puppet agents' keys,
    # a rebuild from zero will require resigning all the keys from each of the puppet agents.
    firewall{ '100 puppetmaster port':
        dport  => 8140,
        proto  => 'tcp',
        action => 'accept',
    }

    package{ 'puppetserver':
        ensure => present,
    }

    service{ "puppetserver":
        ensure  => running,
        enable  => true,
        require => [
            Package['puppetserver'],
            Firewall['100 puppetmaster port'],
        ]
    }

    file{ '/opt/puppetlabs/server/data/puppetserver/reports':
        mode    => '0750',
        require => Package["puppetserver"],
    }

    file{ '/etc/puppetlabs/puppet/eyaml':
        owner   => puppet,
        group   => puppet,
        mode    => '0750',
        require => Package["puppetserver"],
        recurse => true,
        purge   => false,
    }

    file{ "/usr/local/bin/puppet-repo-sync.sh":
        ensure => file,
        owner  => root,
        group  => root,
        mode   => '0754',
        source => "puppet:///modules/puppet_master/puppet-repo-sync.sh",
    }

    cron{ 'repo-sync':
        command => "/usr/local/bin/puppet-repo-sync.sh",
        user    => root,
        minute  => "*/15",
        require => File["/usr/local/bin/puppet-repo-sync.sh"]
    }

    cron { 'reports_cleanup':
        ensure  => present,
        command => "find /var/lib/puppet/reports/ -type f -mtime +60 -name \"*.yaml\" -execdir rm -- {} +",
        user    => root,
        hour    => 3,
        minute  => 0,
    }
}
