class repose_redirects {
    include base::nginx

    file{ '/etc/nginx/conf.d/00-redirects.conf':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 0644,
        source  => "puppet:///modules/repose_redirects/nginx_redirects.conf",
        require => Package['nginx'],
        notify  => Service['nginx'],
    }
}