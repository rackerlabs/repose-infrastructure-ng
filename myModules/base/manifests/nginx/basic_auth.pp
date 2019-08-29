class base::nginx::basic_auth(
    $user = undef,
    $pass = undef,
    $htpasswd = undef,
) {
    include base::nginx

    file { '/etc/nginx/.htpasswd':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => $htpasswd,
        require => Package['nginx'],
        notify  => Service['nginx'],
    }

    # Creates a password file for use by other applications (such as Prometheus)
    file { '/etc/nginx/.passwd':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => $pass,
        require => Package['nginx'],
    }
}