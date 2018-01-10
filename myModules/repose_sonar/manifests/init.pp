class repose_sonar(
    $sonar_jdbc = undef
) {
    include wget

    case $operatingsystem{
        debian: {
            info("Can support debian")
            include apt
            # This is where Open JDK 8 is located.
            class{ 'apt::backports':
                notify => Exec['apt_update'],
            }
        }
        ubuntu: {
            info("Can support ubuntu")
            include apt
        }
        default: { fail("Unrecognized OS for repose_sonar") }
    }

    package {['openjdk-7-jre-headless', 'openjdk-7-jre', 'openjdk-7-jdk']:
        ensure => absent,
        require => Exec['apt_update'],
    }

    package {['ca-certificates-java', 'openjdk-8-jre-headless', 'openjdk-8-jre', 'openjdk-8-jdk']:
        ensure => present,
        require => Exec['apt_update'],
    }

    class{ 'maven::maven':
        version => "3.2.2",
        require => Exec['apt_update'],
    }

    include repose_sonar::database

    if($sonar_jdbc == undef) {
        fail("Must have sonar's JDBC configured")
    }

    class{ 'sonarqube':
        version     => '4.5.7',
        download_url => 'https://sonarsource.bintray.com/Distribution/sonarqube',
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

    # Download the Sonar Scoverage plugin from GitHub since it is not published to a Maven repository
    wget::fetch { 'Sonar Scoverage Plugin':
        source      => 'https://github.com/RadoBuransky/sonar-scoverage-plugin/releases/download/v4.5.0/sonar-scoverage-plugin-4.5.0.jar',
        destination => '/opt/sonar/extensions/plugins/',
        notify      => Service['sonar'],
    }

    # Forcing the Java plugin update was the fix to the "java.io.IOException: Incompatible version 1007." issue.
    # http://stackoverflow.com/questions/30459260/jacoco-sonarqube-incompatible-version-1007/37132563#37132563
    sonarqube::plugin{ 'sonar-java-plugin':
        groupid    => 'org.sonarsource.java',
        artifactid => 'sonar-java-plugin',
        version    => '3.13.1',
        notify     => Service['sonar'],
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
