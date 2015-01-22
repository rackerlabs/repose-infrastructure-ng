class repose_nagios::client {

    include repose_nagios
# this class is for things that aren't going to run nagios directly, but will probably run nrpe
    package { 'nagios-nrpe-server':

    }

    file{ 'nrpe-config':
        path   => '/etc/nagios/nrpe_local.conf',
        owner  => root,
        group  => root,
        mode   => 0644,
        source => 'puppet:///modules/repose_nagios/client_nrpe.conf',
    }

    service{ 'nagios-nrpe-server':
        ensure  => running,
        enable  => true,
        require => [
            Package['nagios-nrpe-server'],
            File['nrpe-config']
        ],
    }
}