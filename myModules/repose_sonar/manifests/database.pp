class repose_sonar::database(
    $mysql_password = undef,
    $mysql_root_password = undef
) {
    firewall{'110 mysql access':
        port => [3306],
        proto => tcp,
        action => accept,
    }

    # add a postgresql database for the sonars
    # don't manage the firewall, because it's only going to connect on localhost
    if($mysql_password == undef) {
        fail("Postgres password must be specified!")
    }

    user{'mysql':
        ensure => present,
        groups => "ssl-keys",
        require => [
            Class['ssl_cert'],
            Package['mysql-server'],
        ],
    }

    # have to set up the mysql database now
    class {'::mysql::server':
        root_password => $mysql_root_password,
    }

    mysql_database{'sonar@%':
        ensure => present,
        charset => 'utf8',
        collate => 'utf8_general_ci',
    }

    mysql_user{'sonar@%/sonar.*':
        ensure => 'present',
    }

    mysql_grant{'sonar@%/sonar.*':
        privileges => ['ALL'],
        table => 'sonar.*',
        user => 'sonar@%',
    }

}