# Installs and configures a Jenkins master host.
class repose_jenkins::master(
    $jenkins_version = '2.107.2'
) {

  include apt
  include base::nginx::autohttps
  include repose_jenkins

  # We manage the Jenkins service ourselves to prevent the jenkins modules
  # from ever restarting the service.
  # This prevents jobs from being killed as they run, and allows us to
  # manually restart Jenkins when necessary and appropriate.
  Service<|title == 'jenkins'|> {
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    restart    => '/bin/echo Not restarting the jenkins service',
  }

  # Hold the Jenkins package at the desired version so that Nagios does not
  # alert us of updates that we cannot consume.
  apt::pin { 'jenkins_package':
    before   => Package['jenkins'],
    packages => 'jenkins',
    version  => $jenkins_version,
    priority => 1001,
  }

  class { 'jenkins':
    require            => Class['java'],
    before             => Sshkey['github.com'],
    cli                => false,
    # If used to manage Java, verifies that Java is installed,
    # but does not verify the version of Java.
    # We explicitly set this to false to avoid cyclic dependencies.
    install_java       => false,
    configure_firewall => true,
    config_hash        => {
      'JENKINS_HOME'         => {
        'value' => $repose_jenkins::jenkins_home
      },
      # Both JAVA_ARGS and JENKINS_JAVA_OPTIONS serve the same purpose, but for
      # different configuration files. JAVA_ARGS controls the /etc/default
      # configuration file used on Debian based distributions while
      # JENKINS_JAVA_OPTIONS controls the /etc/sysconfig configuration file
      # used on RedHat Linux based distributions.
      'JAVA_ARGS'            => {
        'value' => '-Djava.awt.headless=true -Xms2048m -Xmx4096m -XX:PermSize=512m -XX:MaxPermSize=1024m -XX:-UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled'
      },
      'JENKINS_JAVA_OPTIONS' => {
        'value' => '-Djava.awt.headless=true -Xms2048m -Xmx4096m -XX:PermSize=512m -XX:MaxPermSize=1024m -XX:-UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled'
      },
    },
    # note: all plugins must be installed ALONG WITH their dependencies since
    # note: the "manual" installation process is used by jenkins::plugin
    plugin_hash        => {
      'ace-editor'                       => {
        version => '1.1',
      },
      'ansible'                          => {
        version => '1.0',
      },
      'ansicolor'                        => {
        version => '0.5.2',
      },
      'ant'                              => {
        version => '1.8',
      },
      'antisamy-markup-formatter'        => {
        version => '1.5',
      },
      'apache-httpcomponents-client-4-api' => {
        version => '4.5.3-2.1',
      },
      'authentication-tokens'            => {
        version => '1.3',
      },
      'bouncycastle-api'                 => {
        version => '2.16.2',
      },
      'branch-api'                       => {
        version => '2.0.19',
      },
      'build-name-setter'                => {
        version => '1.6.9',
      },
      'built-on-column'                  => {
        version => '1.1',
      },
      # This is "Folders"
      'cloudbees-folder'                 => {
        version => '6.4',
      },
      'command-launcher'                 => {
        version => '1.2',
      },
      'conditional-buildstep'            => {
        version => '1.3.6',
      },
      'copyartifact'                     => {
        version => '1.39.1',
      },
      'credentials-binding'              => {
        version => '1.16',
      },
      # todo: uncomment this when the jenkins module does not manage this plugin itself
      # 'credentials' => {
      #   version => '2.1.16',
      # },
      'dashboard-view'                   => {
        version => '2.9.11',
      },
      'display-url-api'                  => {
        version => '2.2.0',
      },
      'docker-commons'                   => {
        version => '1.11',
      },
      # This is the "Docker Pipeline".
      'docker-workflow'                  => {
        version => '1.15.1',
      },
      'durable-task'                     => {
        version => '1.22',
      },
      'dynamic-axis'                     => {
        version => '1.0.3',
      },
      'envinject'                        => {
        version => '2.1.3',
      },
      'envinject-api'                    => {
        version => '1.5',
      },
      'external-monitor-job'             => {
        version => '1.7',
      },
      'ghprb'                            => {
        version => '1.40.0',
      },
      'git'                              => {
        version => '3.8.0',
      },
      'git-client'                       => {
        version => '2.7.1',
      },
      'git-server'                       => {
        version => '1.7',
      },
      'github'                           => {
        version => '1.29.0',
      },
      'github-api'                       => {
        version => '1.90',
      },
      'gradle'                           => {
        version => '1.28',
      },
      'handlebars'                       => {
        version => '1.1.1',
      },
      'htmlpublisher'                    => {
        version => '1.16',
      },
      'icon-shim'                        => {
        version => '2.0.3',
      },
      'instant-messaging'                => {
        version => '1.35',
      },
      'ircbot'                           => {
        version => '2.30',
      },
      'jacoco'                           => {
        version => '3.0.1',
      },
      'jackson2-api'                     => {
        version => '2.8.11.1',
      },
      'javadoc'                          => {
        version => '1.4',
      },
      'jenkins-multijob-plugin'          => {
        version => '1.29',
      },
      'join'                             => {
        version => '1.21',
      },
      'jquery'                           => {
        version => '1.12.4-0',
      },
      'jquery-detached'                  => {
        version => '1.2.1',
      },
      'jsch'                             => {
        version => '0.1.54.2',
      },
      'junit'                            => {
        version => '1.24',
      },
      'ldap'                             => {
        version => '1.20',
      },
      'm2release'                        => {
        version => '0.14.0',
      },
      'mailer'                           => {
        version => '1.21',
      },
      'mapdb-api'                        => {
        version => '1.0.9.0',
      },
      'matrix-auth'                      => {
        version => '2.2',
      },
      'matrix-project'                   => {
        version => '1.13',
      },
      'maven-plugin'                     => {
        version => '3.1.2',
      },
      'momentjs'                         => {
        version => '1.1.1',
      },
      'naginator'                        => {
        version => '1.17.2',
      },
      'pam-auth'                         => {
        version => '1.3',
      },
      'parameterized-trigger'            => {
        version => '2.35.2',
      },
      'pipeline-build-step'              => {
        version => '2.7',
      },
      'pipeline-graph-analysis'          => {
        version => '1.6',
      },
      'pipeline-input-step'              => {
        version => '2.8',
      },
      'pipeline-milestone-step'          => {
        version => '1.3.1',
      },
      'pipeline-model-api'               => {
        version => '1.2.8',
      },
      'pipeline-model-declarative-agent' => {
        version => '1.1.1',
      },
      # This is "Pipeline: Declarative".
      'pipeline-model-definition'        => {
        version => '1.2.8',
      },
      # This is "Pipeline: Declarative Extension Points API".
      'pipeline-model-extensions'        => {
        version => '1.2.8',
      },
      'pipeline-rest-api'                => {
        version => '2.10',
      },
      'pipeline-stage-step'              => {
        version => '2.3',
      },
      'pipeline-stage-tags-metadata'     => {
        version => '1.2.8',
      },
      'pipeline-stage-view'              => {
        version => '2.10',
      },
      'pipeline-utility-steps'           => {
        version => '2.0.2',
      },
      'plain-credentials'                => {
        version => '1.4',
      },
      'publish-over'                 => {
        version => '0.22',
      },
      'publish-over-ssh'                 => {
        version => '1.19.1',
      },
      'run-condition'                    => {
        version => '1.0',
      },
      'scm-api'                          => {
        version => '2.2.6',
      },
      # Requires the ssh key for github.com, which is provided by the base module
      'scm-sync-configuration'           => {
        version         => '0.0.10',
        manage_config   => true,
        config_filename => 'scm-sync-configuration.xml',
        config_content  => template('repose_jenkins/scm-sync-configuration.xml.erb'),
      },
      'scoverage'                        => {
        version => '1.3.3',
      },
      'script-security'                  => {
        version => '1.44',
      },
      'simple-theme-plugin'              => {
        version => '0.4',
      },
      'ssh'                              => {
        version => '2.6.1',
      },
      'ssh-agent'                        => {
        version => '1.15',
      },
      'ssh-credentials'                  => {
        version => '1.13',
      },
      'ssh-slaves'                       => {
        version => '1.26',
      },
      'structs'                          => {
        version => '1.14',
      },
      'subversion'                       => {
        version => '2.10.5',
      },
      'swarm'                            => {
        version => '3.12',
      },
      'token-macro'                      => {
        version => '2.5',
      },
      'veracode-scanner'                 => {
        version => '1.6',
      },
      'windows-slaves'                   => {
        version => '1.3.1',
      },
      # This is "Pipeline: API".
      'workflow-api'                     => {
        version => '2.27',
      },
      'workflow-aggregator'              => {
        version => '2.5',
      },
      'workflow-basic-steps'             => {
        version => '2.6',
      },
      # This is "Pipeline: Groovy".
      'workflow-cps'                     => {
        version => '2.48',
      },
      'workflow-cps-global-lib'          => {
        version => '2.9',
      },
      'workflow-durable-task-step'       => {
        version => '2.19',
      },
      'workflow-job'                     => {
        version => '2.19',
      },
      'workflow-multibranch'             => {
        version => '2.17',
      },
      'workflow-scm-step'                => {
        version => '2.6',
      },
      # This is "Pipeline: Step API".
      'workflow-step-api'                => {
        version => '2.14',
      },
      'workflow-support'                 => {
        version => '2.18',
      },
    },
  }

  file { '/etc/nginx/conf.d/jenkins.conf':
    ensure  => file,
    mode    => '0644',
    owner   => root,
    group   => root,
    content => template('repose_jenkins/nginx.conf.erb'),
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  file { "${repose_jenkins::jenkins_home}/log":
    ensure  => directory,
    mode    => '0755',
    owner   => jenkins,
    group   => jenkins,
    require => Class['jenkins'],
  }

  file { "${repose_jenkins::jenkins_home}/log/scm_sync_configuration.xml":
    ensure  => file,
    mode    => '0644',
    owner   => jenkins,
    group   => jenkins,
    source  => 'puppet:///modules/repose_jenkins/scm_sync_configuration.xml',
    require => File["${repose_jenkins::jenkins_home}/log"],
  }

  # Papertailing the Jenkins logs
  $papertrail_port = hiera('base::papertrail_port', 1)
  class { 'remotesyslog':
    port => $papertrail_port,
    logs => [
      '/var/log/jenkins/jenkins.log',
      '/var/log/nginx/error.log'
    ],
  }
}
