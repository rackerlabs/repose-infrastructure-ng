class base::nginx::fcgiwrap {
# class to include cgi support in nginx using fcgiwrap

    include base::nginx

    package{ 'fcgiwrap':
        ensure => present,
    }

    service{ 'fcgiwrap':
        ensure  => running,
        enable  => true,
        require => Package['fcgiwrap'],
    }

    file{ '/etc/nginx/conf.d/10-fcgiwrap.conf':
        ensure  => file,
        mode    => 0644,
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/base/nginx/fcgiwrap.conf',
        require => [
            Package['nginx', 'fcgiwrap'],
            Service['fcgiwrap'],
        ],
        notify  => Service['nginx'],
    }
}