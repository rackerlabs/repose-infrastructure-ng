class repose_nagios::server {
    include repose_nagios

    include base::nginx::autohttps
    include base::nginx::php

    file{ '/etc/nginx/conf.d/nagios.conf':
        ensure  => file,
        mode    => 0644,
        owner   => root,
        group   => root,
        content => template('repose_nagios/nginx.conf.erb'),
        require => Package['nginx', 'nagios3'],
        notify  => Service['nginx'],
    }

# TODO: ensure that there's a mailserver on this box too
#TODO: configure postfix for sending only
#TODO: should probably have this in base
    package{ 'postfix':
        ensure => present,
    }

    package{ 'nagios3':
        ensure  => present,
        require => Package['nginx', 'postfix']
    }

#TODO: papertrail logs, beyond default syslog stuff
}