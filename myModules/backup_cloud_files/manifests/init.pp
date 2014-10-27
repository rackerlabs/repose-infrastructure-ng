class backup_cloud_files{
    #TODO: maybe do encryption
    # probably via a GPG key

    class {'python':
        version => 'system',
        pip => true,
        dev => true,
        virtualenv => false,
    }

    python::pip{'pyrax':
        pkgname => 'pyrax'
    }

    package{'duplicity':
        ensure => present,
    }

    file{'pyrax-backend':
        path => '/usr/share/pyshared/duplicity/backends/pyraxbackend.py',
        ensure => present,
        owner => root,
        group => root,
        source => "puppet:///modules/backup_cloud_files/pyraxbackend.py",
        require => Package['duplicity'],
    }

    file{'pyrax-python-link':
        path => '/usr/lib/python2.7/dist-packages/duplicity/backends/pyraxbackend.py',
        ensure => link,
        target => '/usr/share/pyshared/duplicity/backends/pyraxbackend.py',
        require => File['pyrax-backend'],
    }

    exec{'backend-compile':
        command => "python -m compileall /usr/lib/python2.7/dist-packages/duplicity/backends",
        path => ['/usr/bin', '/usr/sbin'],
        refreshonly => true,
        subscribe => File['pyrax-backend'],
        require => File['pyrax-python-link'],
    }
}