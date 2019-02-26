class repose_nagios {
# all the nagios boxes will need some kind of ssl cert
    include ssl_cert

    package { 'nagios-plugins':
        ensure => present,
    }

    file{ '/usr/lib/nagios/plugins/check_debian_packages':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0755',
        source  => "puppet:///modules/repose_nagios/check_debian_packages",
        require => Package['nagios-plugins'],
    }

    file { '/usr/lib/nagios/plugins/check_ssl_cert':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0755',
        source  => "puppet:///modules/repose_nagios/check_ssl_cert",
        require => Package['nagios-plugins'],
    }
}
