class repose_sonar::database(
    $mysql_root_password = undef,
    $mysql_backup_password = undef
) {

    include ssl_cert

    firewall{ '110 mysql access':
        dport  => [3306],
        proto  => tcp,
        action => accept,
    }

    user{ 'mysql':
        ensure  => present,
        groups  => "ssl-keys",
        require => [
            Class['ssl_cert'],
            Package['mysql-server'],
        ],
    }

# have to set up the mysql database now
    class { '::mysql::server':
        root_password    => $mysql_root_password,
        override_options => {
            "mysqld" => {
                "bind-address" => "0.0.0.0",
                "ssl" => "true",
                "ssl-capath" => "/etc/ssl/certs",
                "ssl-cert" => "/etc/ssl/certs/openrepose.crt",
                "ssl-key" => "/etc/ssl/keys/openrepose.key"
            }
        },
        require          => Class['ssl_cert'],
    }

    mysql_database{ 'sonar':
        ensure  => present,
        charset => 'utf8',
        collate => 'utf8_general_ci',
    }

    $sonar_jdbc = hiera('repose_sonar::sonar_jdbc')
    $sonar_pass = $sonar_jdbc['password']

    mysql_user{ 'sonar@%':
        ensure        => 'present',
        password_hash => mysql_password($sonar_pass),
    }

    mysql_grant{ 'sonar@%/sonar.*':
        privileges => ['ALL'],
        table      => 'sonar.*',
        user       => 'sonar@%',
    }

#establish a backup script for stuff to dump it into /srv/mysql-backups
# set the cron time to 5 am, as nightly runs will hopefully be finished by then
# this only dumps the databases, I need to set up the backup cloud files to further archive this dir
    class { '::mysql::server::backup':
        backupuser      => 'mysql_backup',
        backuppassword  => $mysql_backup_password,
        backupdir       => '/srv/mysql-backups',
        backupdatabases => ['sonar'],
        time            => ['5', '0'],
    }

    backup_cloud_files::target{ 'sonar_mysql':
        target            => '/srv/mysql-backups',
        cf_username       => hiera('rs_cloud_username'),
        cf_apikey         => hiera('rs_cloud_apikey'),
        cf_region         => 'DFW',
        duplicity_options => '--full-if-older-than 15D --volsize 250 --exclude-other-filesystems --no-encryption',
        require           => Class['::mysql::server::backup'],
    }

    cron{ 'duplicity_backup':
        ensure  => present,
        command => '/usr/local/bin/duplicity_sonar_mysql.rb',
        user    => root,
        hour    => 6,
        minute  => 0,
        require => Backup_cloud_files::Target['sonar_mysql'],
    }

# schedule a clean up of the backups once a month
    cron{ 'duplicity_cleanup':
        ensure   => present,
        command  => '/usr/local/bin/duplicity_sonar_mysql.rb remove-older-than 1M --force \$url',
        user     => root,
        monthday => 1,
        hour     => 3,
        minute   => 0,
        require  => Backup_cloud_files::Target['sonar_mysql'],
    }
}