class repose_sonar::database(
    $mysql_root_password = undef
) {

    include ssl_cert

    firewall{'110 mysql access':
        port => [3306],
        proto => tcp,
        action => accept,
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
        override_options => {
            "mysqld" => {
                "bind-address" => "0.0.0.0",
                "ssl" => "true",
                "ssl-capath" => "/etc/ssl/certs",
                "ssl-cert" => "/etc/ssl/certs/openrepose.crt",
                "ssl-key" => "/etc/ssl/keys/openrepose.key"
            }
        },
        require => Class['ssl_cert'],
    }

    mysql_database{'sonar':
        ensure => present,
        charset => 'utf8',
        collate => 'utf8_general_ci',
    }

    $sonar_jdbc = hiera('repose_sonar::sonar_jdbc')
    $sonar_pass = $sonar_jdbc['password']

    mysql_user{'sonar@%':
        ensure => 'present',
        password_hash => mysql_password($sonar_pass),
    }

    mysql_grant{'sonar@%/sonar.*':
        privileges => ['ALL'],
        table => 'sonar.*',
        user => 'sonar@%',
    }
}