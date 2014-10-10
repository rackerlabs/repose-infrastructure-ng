class repose_sonar(
    $postgres_password = undef,
    $sonar_jdbc = undef
) {

    if($sonar_jdbc == undef) {
        fail("Must have sonar's JDBC configured")
    }

    class{ 'java': }
    class{'sonarqube':
        version => '4.5',
        user => 'sonar',
        group => 'sonar',
        service => 'sonar',
        installroot => '/opt',
        home => '/opt/sonar-work',
        jdbc => $sonar_jdbc,
        require => [
            Class['maven::maven'],
            Postgresql::Server::Db['sonar']
        ],
    }

    sonarqube::plugin{'sonar-scm-activity':
        groupid => 'org.codehaus.sonar-plugins.scm-activity',
        artifactid => 'sonar-scm-activity-plugin',
        version => '1.8',
        notify => Service['sonar'],
    }

    sonarqube::plugin{'sonar-jira-plugin':
        groupid => 'org.codehaus.sonar-plugins',
        artifactid => 'sonar-jira-plugin',
        version => '1.2',
        notify => Service['sonar'],
    }

    sonarqube::plugin{'sonar-scm-stats-plugin':
        groupid => 'org.codehaus.sonar-plugins',
        artifactid => 'sonar-scm-stats-plugin',
        version => '0.3.1',
        notify => Service['sonar'],
    }

    sonarqube::plugin{'sonar-tab-metrics-plugin':
        groupid => 'org.codehaus.sonar-plugins',
        artifactid => 'sonar-tab-metrics-plugin',
        version => '1.4.1',
        notify => Service['sonar'],
    }

  sonarqube::plugin{'sonar-findbugs-plugin':
    groupid => 'org.codehaus.sonar.plugins',
    artifactid => 'sonar-findbugs-plugin',
    version => '3.3.2',
    notify => Service['sonar'],
  }

    package{'nginx':
        ensure => present,
    }

    # Don't want the default site running.
    file{"/etc/nginx/sites-enabled/default":
        ensure => absent,
        require => Package['nginx'],
    }

    class{'ssl_cert':}

    file{"/etc/nginx/conf.d/sonar.conf":
        ensure => file,
        mode => 0644,
        owner => root,
        group => root,
        content => template("repose_sonar/nginx.conf.erb"),
        require => [
            Package['nginx'],
            Class['ssl_cert']
        ],
        notify => Service['nginx'],
    }

    service{'nginx':
        ensure => running,
        enable => true,
        require => [
            Package['nginx'],
            Class['ssl_cert'],
            File['/etc/nginx/conf.d/sonar.conf', '/etc/nginx/sites-enabled/default']
        ]
    }

    firewall{'100 nginx http/s access':
        port => [443,80],
        proto => tcp,
        action => accept,
    }

    firewall{'110 postgresql access':
      port => [5432],
      proto => tcp,
      action => accept,
    }

    # add a postgresql database for the sonars
    # don't manage the firewall, because it's only going to connect on localhost
    if($postgres_password == undef) {
        fail("Postgres password must be specified!")
    }

    class {'postgresql::server':
        manage_firewall => false,
        listen_addresses => "*",
        postgres_password => $postgres_password,
    }

    # enable SSL on the server
    postgresql::server::config_entry {'ssl':
      value => "on",
      require => Class['ssl_cert'],
    }
    postgresql::server::config_entry {'cert_file':
      value => "/etc/ssl/certs/openrepose.crt",
      require => Class['ssl_cert'],
    }
    postgresql::server::config_entry {'key_file':
      value => "/etc/ssl/keys/openrepose.key",
      require => Class['ssl_cert'],
    }

    postgresql::server::pg_hba_rule{'access to sonar database from the internet':
      description => "Open up sonar database to the internet (all slaves)",
      type => 'hostssl',
      database => 'sonar',
      user => 'sonar',
      address => '0.0.0.0/0',
      auth_method => 'md5',
    }

    postgresql::server::db{ 'sonar':
        user => $sonar_jdbc['username'],
        password => postgresql_password($sonar_jdbc['username'], $sonar_jdbc['password']),
    }

    #Papertrail the sonar logs
    $papertrail_port = hiera("base::papertrail_port", 1)
    class{'remotesyslog':
        port => $papertrail_port,
        logs => [
        '/opt/sonar-work/logs/sonar.log',
        '/opt/sonar-work/logs/access.log'
        ],
        require => Class['sonarqube'],
    }

}