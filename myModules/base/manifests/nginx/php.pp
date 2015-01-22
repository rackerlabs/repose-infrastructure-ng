class base::nginx::php {
# class to include php support in nginx

    include base::nginx

    package{ 'php5-fpm':
        ensure => present,
    }

    file{ '/etc/nginx/conf.d/php5-fpm.conf':
        ensure  => file,
        mode    => 0644,
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/base/nginx-php5-fpm-sock.conf',
        require => Package['nginx', 'php5-fpm'],
        notify  => Service['nginx'],
    }

}