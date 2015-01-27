class base::mail_sender {
    include ssl_cert

# this is just a class to handle a sending-only postfix server
# it cannot receive, and it will only handle sending outgoing mail

    package{ 'postfix':
        ensure => present,
    }

    service{ 'postfix':
        ensure  => running,
        enable  => true,
        require => Package['postfix'],
    }

    file{ '/etc/postfix/main.cf':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 0640,
        content => template('base/postfix/null-main.cf.erb'),
        require => [
            Package['postfix'],
            Class['ssl_cert']
        ],
        notify  => Service['postfix'],
    }

}