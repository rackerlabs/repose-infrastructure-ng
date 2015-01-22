class repose_nagios {
# all the nagios boxes will need some kind of ssl cert
    class { 'ssl_cert':
    }

    package { 'nagios-plugins':
        ensure => present,
    }

}