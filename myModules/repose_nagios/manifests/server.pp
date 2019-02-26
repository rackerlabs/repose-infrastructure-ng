class repose_nagios::server(
    $nagios_admin_user = undef,
    $nagios_admin_pass = undef,
    $nagios_ht_salt = undef
) {
    include repose_nagios

    include base::nginx::autohttps
    include base::nginx::php
    include base::nginx::fcgiwrap

    include base::mail_sender

    $accounts = {
        $nagios_admin_user => $nagios_admin_pass,
    }
    file{ '/etc/nginx/conf.d/nagios_htpasswd':
        ensure  => file,
        mode    => '0640',
        owner   => root,
        group   => 'www-data',
        require => [
            Package['nginx']
        ],
        content => template('repose_nagios/htpasswd.erb'),
        notify      => Service['nginx'],
    }

    file{ '/etc/nginx/conf.d/nagios.conf':
        ensure  => file,
        mode    => '0644',
        owner   => root,
        group   => root,
        content => template('repose_nagios/nginx.conf.erb'),
        require => [
            Package['nginx', 'nagios3', 'fcgiwrap', 'php5-fpm'],
            File['/etc/nginx/conf.d/nagios_htpasswd']
        ],
        notify  => Service['nginx'],
    }

    file{ '/etc/nagios3/cgi.cfg':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
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

    package{ 'nagios3':
        ensure  => present,
        require => Package['nginx', 'postfix']
    }

    package{ 'nagios-nrpe-plugin':
        ensure => present,
    }

#nagios3 is going to bring along a pile of apache dependencies I don't want.
# but it also makes dependency hell. Disk space is cheap, we just won't run apache2 at all
    service{ 'apache2':
        ensure  => stopped,
        enable  => false,
        require => Package['nagios3'],
        before  => Service['nginx'],
    }

    file{ '/etc/nagios3/conf.d':
        ensure       => directory,
        mode         => '0755',
        owner        => root,
        group        => root,
        recurse      => true,
        source       => "puppet:///modules/repose_nagios/nagios_config",
        purge        => true,
        recurselimit => 1,
        require      => Package['nagios3', 'nagios-nrpe-plugin'],
        notify       => Service['nagios3']
    }

    file{ '/etc/nagios3/nagios.cfg':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => "puppet:///modules/repose_nagios/nagios.cfg",
        require => Package['nagios3'],
        notify  => Service['nagios3'],
    }

#these guys are needed to enable external commands
    file{ '/var/lib/nagios3/rw':
        ensure  => directory,
        owner   => nagios,
        group   => www-data,
        mode    => '2710',
        require => Package['nagios3'],
    }

    file{ '/var/lib/nagios3':
        ensure  => directory,
        owner   => nagios,
        group   => nagios,
        mode    => '0751',
        require => Package['nagios3'],
    }

# set up ruby-nagios, because I can aggregate stuff and have less noise!
    package{ 'ruby-nagios':
        ensure   => present,
        provider => 'gem',
        before   => File['/etc/nagios3/conf.d'],
    }

#TODO: papertrail logs, beyond default syslog stuff

}