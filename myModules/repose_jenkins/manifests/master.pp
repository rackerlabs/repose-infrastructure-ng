# Installs and configures a Jenkins master host.
class repose_jenkins::master(
    $jenkins_version = '2.190.1'
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

  # Hold the Jenkins package at the desired version so that Prometheus does not
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
        version => '0.6.2',
      },
      'ant'                              => {
        version => '1.10',
      },
      'antisamy-markup-formatter'        => {
        version => '1.5',
      },
      'apache-httpcomponents-client-4-api' => {
        version => '4.5.10-1.0',
      },
      'authentication-tokens'            => {
        version => '1.3',
      },
      'bouncycastle-api'                 => {
        version => '2.17',
      },
      'branch-api'                       => {
        version => '2.5.4',
      },
      'build-name-setter'                => {
        version => '2.0.3',
      },
      'built-on-column'                  => {
        version => '1.1',
      },
      # This is "Folders"
      'cloudbees-folder'                 => {
        version => '6.7',
      },
      'command-launcher'                 => {
        version => '1.3',
      },
      'conditional-buildstep'            => {
        version => '1.3.6',
      },
      'copyartifact'                     => {
        version => '1.42.1',
      },
      'credentials-binding'              => {
        version => '1.20',
      },
      # todo: uncomment this when the jenkins module does not manage this plugin itself
      # 'credentials' => {
      #   version => '2.1.18',
      # },
      'dashboard-view'                   => {
        version => '2.12',
      },
      'display-url-api'                  => {
        version => '2.3.2',
      },
      'docker-commons'                   => {
        version => '1.15',
      },
      # This is the "Docker Pipeline".
      'docker-workflow'                  => {
        version => '1.19',
      },
      'durable-task'                     => {
        version => '1.30',
      },
      'dynamic-axis'                     => {
        version => '1.0.3',
      },
      'envinject'                        => {
        version => '2.1.6',
      },
      'envinject-api'                    => {
        version => '1.6',
      },
      'external-monitor-job'             => {
        version => '1.7',
      },
      'ghprb'                            => {
        version => '1.42.0',
      },
      'git'                              => {
        version => '3.12.1',
      },
      'git-client'                       => {
        version => '2.8.6',
      },
      'git-server'                       => {
        version => '1.8',
      },
      'github'                           => {
        version => '1.29.4',
      },
      'github-api'                       => {
        version => '1.95',
      },
      'gradle'                           => {
        version => '1.34',
      },
      'handlebars'                       => {
        version => '1.1.1',
      },
      'htmlpublisher'                    => {
        version => '1.20',
      },
      'icon-shim'                        => {
        version => '2.0.3',
      },
      'instant-messaging'                => {
        version => '1.38',
      },
      'ircbot'                           => {
        version => '2.31',
      },
      'jackson2-api'                     => {
        version => '2.9.10',
      },
      'jacoco'                           => {
        version => '2.2.1',
      },
      'javadoc'                          => {
        version => '1.5',
      },
      # This is "Multijob".
      'jenkins-multijob-plugin'          => {
        version => '1.32',
      },
      'join'                             => {
        version => '1.21',
      },
      'jquery'                           => {
        version => '1.12.4-1',
      },
      # This is "JavaScript GUI Lib: jQuery bundles (jQuery and jQuery UI)".
      'jquery-detached'                  => {
        version => '1.2.1',
      },
      'jsch'                             => {
        version => '0.1.55.1',
      },
      'junit'                            => {
        version => '1.28',
      },
      'ldap'                             => {
        version => '1.20',
      },
      # This is "Maven Release Plug-in Plug-in".
      'm2release'                        => {
        version => '0.15.0',
      },
      'mailer'                           => {
        version => '1.28',
      },
      'mapdb-api'                        => {
        version => '1.0.9.0',
      },
      'matrix-auth'                      => {
        version => '2.4.2',
      },
      'matrix-project'                   => {
        version => '1.14',
      },
      'maven-plugin'                     => {
        version => '3.4',
      },
      # This is "JavaScript GUI Lib: Moment.js bundle".
      'momentjs'                         => {
        version => '1.1.1',
      },
      'naginator'                        => {
        version => '1.18',
      },
      'pam-auth'                         => {
        version => '1.5.1',
      },
      'parameterized-trigger'            => {
        version => '2.35.2',
      },
      'pipeline-build-step'              => {
        version => '2.9',
      },
      'pipeline-graph-analysis'          => {
        version => '1.10',
      },
      'pipeline-input-step'              => {
        version => '2.11',
      },
      'pipeline-milestone-step'          => {
        version => '1.3.1',
      },
      'pipeline-model-api'               => {
        version => '1.3.9',
      },
      'pipeline-model-declarative-agent' => {
        version => '1.1.1',
      },
      # This is "Pipeline: Declarative".
      'pipeline-model-definition'        => {
        version => '1.3.9',
      },
      # This is "Pipeline: Declarative Extension Points API".
      'pipeline-model-extensions'        => {
        version => '1.3.9',
      },
      'pipeline-rest-api'                => {
        version => '2.10',
      },
      'pipeline-stage-step'              => {
        version => '2.3',
      },
      'pipeline-stage-tags-metadata'     => {
        version => '1.3.9',
      },
      # This is "Pipeline: REST API".
      'pipeline-stage-view'              => {
        version => '2.12',
      },
      'pipeline-utility-steps'           => {
        version => '2.3.1',
      },
      'plain-credentials'                => {
        version => '1.5',
      },
      'publish-over'                     => {
        version => '0.22',
      },
      'publish-over-ssh'                 => {
        version => '1.20.1',
      },
      'run-condition'                    => {
        version => '1.2',
      },
      'scm-api'                          => {
        version => '2.6.3',
      },
      # Requires the ssh key for github.com, which is provided by the base module
      'scm-sync-configuration'           => {
        version         => '0.0.10',
        manage_config   => true,
        config_filename => 'scm-sync-configuration.xml',
        config_content  => template('repose_jenkins/scm-sync-configuration.xml.erb'),
      },
      'scoverage'                        => {
        version => '1.4.0',
      },
      'script-security'                  => {
        version => '1.64',
      },
      'simple-theme-plugin'              => {
        version => '0.5.1',
      },
      'slack'                            => {
        version => '2.34',
      },
      'ssh'                              => {
        version => '2.6.1',
      },
      'ssh-agent'                        => {
        version => '1.17',
      },
      'ssh-credentials'                  => {
        version => '1.17.3',
      },
      'ssh-slaves'                       => {
        version => '1.30.2',
      },
      # todo: uncomment this when the jenkins module does not manage this plugin itself
      #'structs'                          => {
      #  version => '1.17',
      #},
      'subversion'                       => {
        version => '2.12.2',
      },
      # This is "Self-Organizing Swarm Plug-in Modules"
      'swarm'                            => {
        version => '3.17',
      },
      'token-macro'                      => {
        version => '2.8',
      },
      'veracode-scanner'                 => {
        version => '1.6',
      },
      'windows-slaves'                   => {
        version => '1.4',
      },
      # This is "Pipeline: API".
      'workflow-api'                     => {
        version => '2.37',
      },
      # This is "Pipeline".
      'workflow-aggregator'              => {
        version => '2.6',
      },
      'workflow-basic-steps'             => {
        version => '2.18',
      },
      # This is "Pipeline: Groovy".
      'workflow-cps'                     => {
        version => '2.74',
      },
      # This is "Pipeline: Shared Groovy Libraries".
      'workflow-cps-global-lib'          => {
        version => '2.15',
      },
      # This is "Pipeline: Nodes and Processes".
      'workflow-durable-task-step'       => {
        version => '2.34',
      },
      'workflow-job'                     => {
        version => '2.35',
      },
      'workflow-multibranch'             => {
        version => '2.21',
      },
      'workflow-scm-step'                => {
        version => '2.9',
      },
      # This is "Pipeline: Step API".
      'workflow-step-api'                => {
        version => '2.20',
      },
      # This is "Pipeline: Supporting APIs".
      'workflow-support'                 => {
        version => '3.3',
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
  class {'papertrail':
    destination_host => 'logs.papertrailapp.com',
    destination_port => 0 + $papertrail_port,
    files            => [
      '/var/log/jenkins/jenkins.log',
      '/var/log/nginx/error.log'
    ],
  }
}
