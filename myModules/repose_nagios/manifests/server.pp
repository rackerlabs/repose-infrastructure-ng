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

#nagios3 is going to bring along a pile of apache dependencies I don't want.
# but it also makes dependency hell. Disk space is cheap, we just won't run apache2 at all
    service{ 'apache2':
        ensure => stopped,
        enable => false,
        require => Package['nagios3'],
        before => Service['nginx'],
    }

#TODO: papertrail logs, beyond default syslog stuff
}