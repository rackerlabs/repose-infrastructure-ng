class base::nginx::php {
# class to include php support in nginx

    include base::nginx

    package{ 'php5-fpm':
        ensure => present,
    }


    # fortunately the default debian php5-fpm configs are sufficient
    service{ 'php5-fpm':
        ensure => running,
        enable => true,
        require => Package['php5-fpm'],
    }

    file{ '/etc/nginx/conf.d/20-php5-fpm.conf':
        ensure  => file,
        mode    => 0644,
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/base/nginx/php5-fpm-sock.conf',
        require => [
            Package['nginx', 'php5-fpm'],
            Service['php5-fpm'],
        ],
        notify  => Service['nginx'],
    }

}