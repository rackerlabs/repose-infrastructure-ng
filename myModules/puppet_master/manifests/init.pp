class puppet_master {
# puppet master class for debian

# using https://github.com/TomPoulton/hiera-eyaml
# need our eyaml backend
    package{ "hiera-eyaml":
        ensure   => installed,
        provider => 'gem',
    }

    package{ "libapache2-mod-passenger":
        ensure => present,
    }

    exec{ "/usr/sbin/a2enmod ssl":
        require => Package["libapache2-mod-passenger"],
        creates => "/etc/apache2/mods-enabled/ssl.load",
    }

    exec{ "/usr/sbin/a2enmod headers":
        require => Package["libapache2-mod-passenger"],
        creates => "/etc/apache2/mods-enabled/headers.load",
    }

    exec{ "/usr/sbin/a2dissite default":
        require => Package["libapache2-mod-passenger"],
    }

    exec{ "/usr/sbin/a2ensite puppetmaster":
        require => [
            Package["libapache2-mod-passenger"],
            File["/etc/apache2/sites-available/puppetmaster"]
        ],
        creates => "/etc/apache2/sites-enabled/000-puppetmaster",
    }

    file{ "/srv/puppetmaster":
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => "0755",
    }

    file{ "/srv/puppetmaster/public":
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => "0755",
        require => File['/srv/puppetmaster']
    }

    file{ "/srv/puppetmaster/config.ru":
        ensure  => file,
        owner   => puppet,
        group   => puppet,
        mode    => "0644",
        source  => "puppet:///modules/puppet_master/config.ru",
        require => File['/srv/puppetmaster'],
        notify  => Service['apache2'],
    }

# this is using the keys provided by puppetmaster when it installs,
# a rebuild from zero would require resigning all the keys from the various puppet agents.
# possibly something we'd want to puppetize? heh
    file{ "/etc/apache2/sites-available/puppetmaster":
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 0664,
        content => template("puppet_master/puppetmaster-vhost.conf.erb"),
        require => Package['libapache2-mod-passenger'],
        notify  => Service['apache2'],
    }

    firewall{ '100 puppetmaster port':
        dport  => 8140,
        proto  => 'tcp',
        action => 'accept',
    }

    service{ "apache2":
        ensure  => running,
        enable  => true,
        require => [
            Package['libapache2-mod-passenger'],
            File['/etc/apache2/sites-available/puppetmaster',
            '/srv/puppetmaster/public',
            '/srv/puppetmaster/config.ru'
            ],
            Exec["/usr/sbin/a2enmod ssl", "/usr/sbin/a2enmod headers"],
            Firewall['100 puppetmaster port'],
        ]
    }

    file{ "/usr/local/bin/puppet-repo-sync.sh":
        ensure => file,
        owner  => root,
        group  => root,
        mode   => 0754,
        source => "puppet:///modules/puppet_master/puppet-repo-sync.sh",
    }

    cron{ 'repo-sync':
        command => "/usr/local/bin/puppet-repo-sync.sh",
        user    => root,
        minute  => "*/15",
        require => File["/usr/local/bin/puppet-repo-sync.sh"]
    }

    cron { 'reports_cleanup':
      ensure   => present,
      command  => "find /var/lib/puppet/reports/ -type f -mtime +60 -name \"*.yaml\" -execdir rm -- {} +",
      user     => root,
      hour     => 3,
      minute   => 0,
    }
}
