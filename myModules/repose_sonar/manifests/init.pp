class repose_sonar(
    $sonar_jdbc = undef
) {

    include repose_sonar::database

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
            Class['repose_sonar::database']
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

    include ssl_cert

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