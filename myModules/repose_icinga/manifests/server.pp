class repose_icinga::server (
    $icinga2_db        = undef,
    $icinga2_user      = undef,
    $icinga2_pass      = undef,
    $icingaweb2_db     = undef,
    $icingaweb2_user   = undef,
    $icingaweb2_pass   = undef,
    $icinga2admin_user = undef,
    $icinga2admin_pass = undef,
    $icinga2admin_hash = undef,
) {
    include repose_icinga
    include ::postgresql::server

    class { '::icinga2':
        manage_repo => true,
        confd       => false,
        features    => [
            'checker',
            'mainlog',
            'notification',
            'statusdata',
            'compatlog',
            'command',
        ],
        constants   => {
            'ZoneName' => 'master',
        },
    }

    postgresql::server::db { "$icinga2_db":
        user     => "$icinga2_user",
        password => postgresql_password("$icinga2_user", "$icinga2_pass"),
    }

    class { '::icinga2::feature::idopgsql':
        database      => "$icinga2_db",
        user          => "$icinga2_user",
        password      => "$icinga2_pass",
        import_schema => true,
        require       => Postgresql::Server::Db["$icinga2_db"],
    }

    firewall { '100 nginx http/s access':
        dport  => [443, 80],
        proto  => tcp,
        action => accept,
    }

    include ssl_cert
    include ::nginx

    nginx::resource::server { 'icingaweb2':
        server_name          => ['icinga.openrepose.org'],
        ssl                  => true,
        ssl_cert             => '/etc/ssl/certs/openrepose.crt',
        ssl_key              => '/etc/ssl/keys/openrepose.key',
        ssl_redirect         => true,
        index_files          => [],
        use_default_location => false,
    }

    nginx::resource::location { 'root':
        location            => '/',
        server              => 'icingaweb2',
        ssl                 => true,
        ssl_only            => true,
        index_files         => [],
        location_cfg_append => {
            rewrite => '^/(.*) https://$host/icingaweb2/$1 permanent'
        }
    }

    nginx::resource::location { 'icingaweb2_index':
        location       => '~ ^/icingaweb2/index\.php(.*)$',
        server         => 'icingaweb2',
        ssl            => true,
        ssl_only       => true,
        index_files    => [],
        fastcgi        => '127.0.0.1:9000',
        fastcgi_index  => 'index.php',
        fastcgi_script => '/usr/share/icingaweb2/public/index.php',
        fastcgi_param  => {
            'ICINGAWEB_CONFIGDIR' => '/etc/icingaweb2',
            'REMOTE_USER'         => '$remote_user',
        },
    }

    nginx::resource::location { 'icingaweb':
        location       => '~ ^/icingaweb2(.+)?',
        location_alias => '/usr/share/icingaweb2/public',
        try_files      => ['$1', '$uri', '$uri/', '/icingaweb2/index.php$is_args$args'],
        index_files    => ['index.php'],
        server         => 'icingaweb2',
        ssl            => true,
        ssl_only       => true,
    }

    include ::phpfpm

    phpfpm::pool { 'main': }

    postgresql::server::db { "$icingaweb2_db":
        user     => "$icingaweb2_user",
        password => postgresql_password("$icingaweb2_user", "$icingaweb2_pass"),
    }

    package { 'php7.0-pgsql':
        ensure  => present,
        require => Class['::phpfpm'],
    }

    class { '::icingaweb2':
        manage_repo   => false,
        db_type       => 'pgsql',
        db_port       => 5432,
        db_name       => "$icingaweb2_db",
        db_username   => "$icingaweb2_user",
        db_password   => "$icingaweb2_pass",
        import_schema => true,
        require       => Postgresql::Server::Db["$icingaweb2_db"],
    }

    class { 'icingaweb2::module::monitoring':
        ido_host          => 'localhost',
        ido_db_name       => "$icinga2_db",
        ido_db_username   => "$icinga2_user",
        ido_db_password   => "$icinga2_pass",
        commandtransports => {
            icinga2 => {
                transport => 'local',
            }
        }
    }

    # WIP: Something like this is needed to automagically update the default password.
    #$icinga2admin_hash = generate("/usr/bin/php", "-r", "'echo password_hash(\"$icinga2admin_pass\", PASSWORD_DEFAULT);'")
    #exec { 'Update default admin password':
    #    environment => ["PGPASSWORD=$icingaweb2_pass"],
    #    command     => "/usr/bin/psql -h 'localhost' -p '5432' -U '$icingaweb2_user' -d '$icingaweb2_db' -w -c \"UPDATE icingaweb_user set password_hash = \'$icinga2admin_hash\' WHERE name = \'$icinga2admin_user\'\"",
    #    require     => Class['::icingaweb2'],
    #}
}
