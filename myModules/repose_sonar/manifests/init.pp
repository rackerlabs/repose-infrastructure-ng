class repose_sonar(
    $sonar_jdbc = undef
) {
    package {['openjdk-7-jre-headless', 'openjdk-7-jre', 'openjdk-7-jdk']:
        ensure => absent,
    }

    class{ 'apt::backports': }
    Class['apt::update'] -> Package <| provider == 'apt' |>

    package {['openjdk-8-jre-headless', 'openjdk-8-jre', 'openjdk-8-jdk']:
        ensure => present,
    }

    class{ 'maven::maven':
        version => "3.2.2",
    }

    include repose_sonar::database

    if($sonar_jdbc == undef) {
        fail("Must have sonar's JDBC configured")
    }

    class{ 'sonarqube':
        version     => '4.5',
        user        => 'sonar',
        group       => 'sonar',
        service     => 'sonar',
        installroot => '/opt',
        home        => '/opt/sonar-work',
        jdbc        => $sonar_jdbc,
        require     => [
            Class['repose_sonar::database']
        ],
    }

    sonarqube::plugin{ 'sonar-scm-activity':
        groupid    => 'org.codehaus.sonar-plugins.scm-activity',
        artifactid => 'sonar-scm-activity-plugin',
        version    => '1.8',
        notify     => Service['sonar'],
    }

    sonarqube::plugin{ 'sonar-jira-plugin':
        groupid    => 'org.codehaus.sonar-plugins',
        artifactid => 'sonar-jira-plugin',
        version    => '1.2',
        notify     => Service['sonar'],
    }

    sonarqube::plugin{ 'sonar-scm-stats-plugin':
        groupid    => 'org.codehaus.sonar-plugins',
        artifactid => 'sonar-scm-stats-plugin',
        version    => '0.3.1',
        notify     => Service['sonar'],
    }

    sonarqube::plugin{ 'sonar-tab-metrics-plugin':
        groupid    => 'org.codehaus.sonar-plugins',
        artifactid => 'sonar-tab-metrics-plugin',
        version    => '1.4.1',
        notify     => Service['sonar'],
    }

    sonarqube::plugin{ 'sonar-findbugs-plugin':
        groupid    => 'org.codehaus.sonar.plugins',
        artifactid => 'sonar-findbugs-plugin',
        version    => '3.3.2',
        notify     => Service['sonar'],
    }

    include base::nginx::autohttps

    file{ "/etc/nginx/conf.d/sonar.conf":
        ensure  => file,
        mode    => 0644,
        owner   => root,
        group   => root,
        content => template("repose_sonar/nginx.conf.erb"),
        require => Package['nginx'],
        notify  => Service['nginx'],
    }

    #Papertrail the sonar logs
    $papertrail_port = hiera("base::papertrail_port", 1)
    class{ 'remotesyslog':
        port    => $papertrail_port,
        logs    => [
            '/opt/sonar-work/logs/sonar.log',
            '/opt/sonar-work/logs/access.log'
        ],
        require => Class['sonarqube'],
    }
}
