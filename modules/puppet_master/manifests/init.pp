class puppet_master {

    # using https://github.com/TomPoulton/hiera-eyaml
    # need our eyaml backend
    package{"hiera-eyaml":
        ensure   => installed,
        provider => 'gem',
    }

    package{"mod_passenger":
        ensure => present,
    }

    package{"mod_ssl":
        ensure => present,
    }

    package{"httpd":
        ensure => present,
    }

    file{"/srv/puppetmaster":
        ensure => directory,
        owner => root,
        group => root,
        mode => "0755",
    }

    file{"/srv/puppetmaster/public":
        ensure => directory,
        owner => root,
        group => root,
        mode => "0755",
        require => File['/srv/puppetmaster']
    }

    file{"/srv/puppetmaster/config.ru":
        ensure => file,
        owner => root,
        group => root,
        mode => "0644",
        require => File['/srv/puppetmaster'],
        notify => Service['httpd'],
    }

    # this is using the keys provided by puppetmaster when it installs,
    # a rebuild from zero would require resigning all the keys from the various puppet agents.
    # possibly something we'd want to puppetize? heh
    file{"/etc/httpd/conf.d/puppetmaster.conf":
        ensure => file,
        owner => root,
        group => root,
        mode => 0664,
        content => template("puppet_master/puppetmaster-vhost.conf.erb"),
        require => Package['httpd', 'mod_passenger'],
        notify => Service['httpd'],
    }

    file{"/etc/httpd/conf.d/welcome.conf":
        ensure => absent,
        backup => false,
    }

    service{"httpd":
        ensure => running,
        enable => true,
        require => [
            Package['httpd', 'mod_passenger', 'mod_ssl'],
            File['/etc/httpd/conf.d/puppetmaster.conf',
                 '/srv/puppetmaster/public',
                 '/srv/puppetmaster/config.ru',
                 '/etc/httpd/conf.d/welcome.conf'
                ]
        ]
    }
}