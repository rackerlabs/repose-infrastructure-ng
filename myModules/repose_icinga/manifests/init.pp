class repose_icinga {
    package { 'monitoring-plugins':
        ensure => present,
    }
}
