class repose_nagios {
# all the nagios boxes will need some kind of ssl cert
    class { 'ssl_cert':
    }

# debian uses the package "monitoring-plugins" as a meta package for nagios compatible plugins
    package { 'monitoring-plugins':
        ensure => present,
    }

}