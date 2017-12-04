# Installs and configures a Jenkins master host.
class repose_jenkins::master(
    $jenkins_version = '2.73.3'
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
        version => '0.6.2',
      },
      'ansicolor'                        => {
        version => '0.5.2',
      },
      'ant'                              => {
        version => '1.7',
      },
      'antisamy-markup-formatter'        => {
        version => '1.5',
      },
      'authentication-tokens'            => {
        version => '1.3',
      },
      'bouncycastle-api'                 => {
        version => '2.16.2',
      },
      'branch-api'                       => {
        version => '2.0.15',
      },
      'build-name-setter'                => {
        version => '1.6.7',
      },
      'built-on-column'                  => {
        version => '1.1',
      },
      'cloudbees-folder'                 => {
        version => '6.2.1',
      },
      'conditional-buildstep'            => {
        version => '1.3.6',
      },
      'copyartifact'                     => {
        version => '1.39',
      },
      'credentials-binding'              => {
        version => '1.13',
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
        version => '1.9',
      },
      # This is the "Docker Pipeline".
      'docker-workflow'                  => {
        version => '1.14',
      },
      'durable-task'                     => {
        version => '1.17',
      },
      'dynamic-axis'                     => {
        version => '1.0.3',
      },
      'envinject'                        => {
        version => '2.1.3',
      },
      'envinject-api'                    => {
        version => '1.4',
      },
      'external-monitor-job'             => {
        version => '1.7',
      },
      'ghprb'                            => {
        version => '1.39.0',
      },
      'git'                              => {
        version => '3.6.4',
      },
      'git-client'                       => {
        version => '2.6.0',
      },
      'git-server'                       => {
        version => '1.7',
      },
      'github'                           => {
        version => '1.28.1',
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
        version => '1.14',
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
        version => '2.2.1',
      },
      'jackson2-api'                     => {
        version => '2.8.7.0',
      },
      'javadoc'                          => {
        version => '1.4',
      },
      'jenkins-multijob-plugin'          => {
        version => '1.28',
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
        version => '0.1.54.1',
      },
      'junit'                            => {
        version => '1.23',
      },
      'ldap'                             => {
        version => '1.18',
      },
      'm2release'                        => {
        version => '0.14.0',
      },
      'mailer'                           => {
        version => '1.20',
      },
      'mapdb-api'                        => {
        version => '1.0.9.0',
      },
      'matrix-auth'                      => {
        version => '2.2',
      },
      'matrix-project'                   => {
        version => '1.12',
      },
      'maven-plugin'                     => {
        version => '3.0',
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
        version => '2.5.1',
      },
      'pipeline-graph-analysis'          => {
        version => '1.5',
      },
      'pipeline-input-step'              => {
        version => '2.8',
      },
      'pipeline-milestone-step'          => {
        version => '1.3.1',
      },
      'pipeline-model-api'               => {
        version => '1.2.5',
      },
      'pipeline-model-declarative-agent' => {
        version => '1.1.1',
      },
      'pipeline-model-definition'        => {
        version => '1.2.2',
      },
      'pipeline-model-extensions'        => {
        version => '1.2.2',
      },
      'pipeline-rest-api'                => {
        version => '2.9',
      },
      'pipeline-stage-step'              => {
        version => '2.3',
      },
      'pipeline-stage-tags-metadata'     => {
        version => '1.2.5',
      },
      'pipeline-stage-view'              => {
        version => '2.9',
      },
      'pipeline-utility-steps'           => {
        version => '1.5.1',
      },
      'plain-credentials'                => {
        version => '1.4',
      },
      'publish-over-ssh'                 => {
        version => '1.17',
      },
      'run-condition'                    => {
        version => '1.0',
      },
      'scm-api'                          => {
        version => '2.2.5',
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
        version => '1.36',
      },
      'simple-theme-plugin'              => {
        version => '0.3',
      },
      'ssh'                              => {
        version => '2.5',
      },
      'ssh-agent'                        => {
        version => '1.15',
      },
      'ssh-credentials'                  => {
        version => '1.13',
      },
      'ssh-slaves'                       => {
        version => '1.22',
      },
      'structs'                          => {
        version => '1.10',
      },
      'subversion'                       => {
        version => '2.9',
      },
      'swarm'                            => {
        version => '3.6',
      },
      'token-macro'                      => {
        version => '2.3',
      },
      'veracode-scanner'                 => {
        version => '1.6',
      },
      'windows-slaves'                   => {
        version => '1.3.1',
      },
      'workflow-api'                     => {
        version => '2.23.1',
      },
      'workflow-aggregator'              => {
        version => '2.5',
      },
      'workflow-basic-steps'             => {
        version => '2.6',
      },
      # This is "Pipeline: Groovy".
      'workflow-cps'                     => {
        version => '2.42',
      },
      'workflow-cps-global-lib'          => {
        version => '2.9',
      },
      'workflow-durable-task-step'       => {
        version => '2.17',
      },
      'workflow-job'                     => {
        version => '2.15',
      },
      'workflow-multibranch'             => {
        version => '2.16',
      },
      'workflow-scm-step'                => {
        version => '2.6',
      },
      # This is "Pipeline: Step API".
      'workflow-step-api'                => {
        version => '2.14',
      },
      'workflow-support'                 => {
        version => '2.16',
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
