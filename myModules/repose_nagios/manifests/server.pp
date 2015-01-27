class repose_nagios::server(
    $nagios_admin_user = undef,
    $nagios_admin_pass = undef,
    $nagios_ht_salt = undef
) {
    include repose_nagios

    include base::nginx::autohttps
    include base::nginx::php
    include base::nginx::fcgiwrap

    file{ '/etc/nginx/conf.d/nagios.conf':
        ensure  => file,
        mode    => 0644,
        owner   => root,
        group   => root,
        content => template('repose_nagios/nginx.conf.erb'),
        require => [
            Package['nginx', 'nagios3', 'fcgiwrap', 'php5-fpm'],
            Htpasswd[$nagios_admin_user],
            File['/etc/nginx/conf.d/nagios_htpasswd']
        ],
        notify  => Service['nginx'],
    }

    file{ '/etc/nginx/conf.d/nagios_htpasswd':
        ensure  => file,
        mode    => 0640,
        owner   => root,
        group   => 'www-data',
        require => [
            Package['nginx'],
            Htpasswd[$nagios_admin_user]
        ],
    }

    htpasswd { $nagios_admin_user:
        cryptpasswd => ht_crypt($nagios_admin_pass, $nagios_ht_salt),
        target      => '/etc/nginx/conf.d/nagios_htpasswd',
        require     => Package['nginx'],
        notify      => Service['nginx'],
    }

    file{ '/etc/nagios3/cgi.cfg':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 0644,
        content => template('repose_nagios/cgi.cfg.erb'),
        require => [
            Package['nagios3']
        ],
        notify  => Service['nagios3'],
    }

    service{ 'nagios3':
        ensure  => running,
        enable  => true,
        require => Package['nagios3'],
    }

#TODO: ensure that there's a mailserver on this box too
#TODO: configure postfix for sending only
#TODO: should probably have this in base
    package{ 'postfix':
        ensure => present,
    }

    package{ 'nagios3':
        ensure  => present,
        require => Package['nginx', 'postfix']
    }

#nagios3 is going to bring along a pile of apache dependencies I don't want.
# but it also makes dependency hell. Disk space is cheap, we just won't run apache2 at all
    service{ 'apache2':
        ensure  => stopped,
        enable  => false,
        require => Package['nagios3'],
        before  => Service['nginx'],
    }


#TODO: papertrail logs, beyond default syslog stuff

}