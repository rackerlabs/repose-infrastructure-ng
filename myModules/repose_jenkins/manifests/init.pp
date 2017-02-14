# Installs base layer, but no jenkins itself. Perfect for a slave configuration.
# also used by the master, basically anything that wants to run our jenkins jobs
# Depends on garethr/remotesyslog to activate remote syslog for things on this host
class repose_jenkins(
    $maven_version = "3.2.1",
    $deploy_key = undef,
    $deploy_key_pub = undef,
    $repo_key = undef,
    $repo_key_pub = undef,
    $inova_username = undef,
    $inova_password = undef,
    $research_nexus_username = undef,
    $research_nexus_password = undef,
    $saxon_ee_license = undef
) {

    # class to ensure jenkins is installed
    # this will default to gradle 2.8, have to use a different syntax to get it with other versions
    # or set the values in hiera
    include repose_jenkins::gpgkey

    # ensure docker is installed to verify releases
    include docker

    # TODO: v Remove this v
    # restart the Docker service when iptables rules are updated
    #
    # Docker requires certain iptables rules to be setup for containers to
    # access the internet. Docker will automatically setup these rules when the
    # service is run. However, the firewall Puppet module will purge the rules
    # that Docker set up whenever it runs. Restarting the Docker service after
    # the iptables rules are purged should solve this issue.
    #
    # Ideally, the firewall module would be configured to set up the necessary
    # Docker iptables rules. However, since Docker, by default, picks its own
    # subnet on the host when it creates a bridge, we don't necessarily know
    # what the iptables rules will look like when Puppet runs. This can probably
    # be fixed by customizing the docker0 bridge, but that's a whole new chunk
    # of work.
    # Class['firewall'] ~> Service['docker']

    firewallchain { 'DOCKER:nat:IPv4':
        ensure => 'present',
        purge  => 'true',
    }->
    firewall { '200 route local through DOCKER':
        table    => 'nat',
        chain    => 'PREROUTING',
        dst_type => 'LOCAL',
        jump     => 'DOCKER',
    }->
    firewall { '201 OURPUT LOCAL through DOCKER':
        table       => 'nat',
        chain       => 'OUTPUT',
        destination => '! 127.0.0.0/8',
        dst_type    => 'LOCAL',
        jump        => 'DOCKER',
    }->
    firewall { '202 MASQUERADE output interface not docker0':
        table    => 'nat',
        chain    => 'POSTROUTING',
        source   => '172.17.0.0/16',
        outiface => '! docker0',
        jump     => 'MASQUERADE',
    }->
    firewall { '203 RETURN input interface docker0':
        table   => 'nat',
        chain   => 'DOCKER',
        iniface => 'docker0',
        jump    => 'RETURN',
    }

    firewallchain { 'DOCKER:filter:IPv4':
        ensure => 'present',
        purge  => 'true',
    }->
    firewallchain { 'DOCKER-ISOLATION:filter:IPv4':
        ensure => 'present',
        purge  => 'true',
    }->
    firewall { '300 FORWARD to DOCKER-ISOLATION':
        table => 'filter',
        chain => 'FORWARD',
        jump  => 'DOCKER-ISOLATION',
    }->
    firewall { '301 route to docker0 through DOCKER':
        table    => 'filter',
        chain    => 'FORWARD',
        outiface => 'docker0',
        jump     => 'DOCKER',
    }->
    firewall { '302 ACCEPT states to docker0 FORWARD':
        table    => 'filter',
        chain    => 'FORWARD',
        outiface => 'docker0',
        ctstate  => ['RELATED', 'ESTABLISHED'],
        action   => 'accept',
    }->
    firewall { '303 ACCEPT docker0 to not docker0 FORWARD':
        table    => 'filter',
        chain    => 'FORWARD',
        iniface  => 'docker0',
        outiface => '! docker0',
        action   => 'accept',
    }->
    firewall { '304 ACCEPT docker0 to docker0 FORWARD':
        table    => 'filter',
        chain    => 'FORWARD',
        iniface  => 'docker0',
        outiface => 'docker0',
        action   => 'accept',
    }->
    firewall { '305 RETURN DOCKER-ISOLATION':
        table => 'filter',
        chain => 'DOCKER-ISOLATION',
        jump  => 'RETURN',
    }

    $jenkins_home = '/var/lib/jenkins'
    $github_key_info = hiera_hash("base::github_host_key", { "key" => "DEFAULT", "type" => "ssh-rsa" })

    class{"repose_gradle":
        user      => 'jenkins',
        user_home => "${jenkins_home}",
        daemon    => false,
        require  => User["jenkins"],
    }

    class{"repose_maven":
        user      => 'jenkins',
        user_home => "${jenkins_home}",
        require  => User["jenkins"],
    }

# this should ensure we've got java on the system at jdk8. Installed via package
# it will give us JDK8 however.
# this is really stupid, for some reason it can't pick up the proper package version
# and is doing stupid things, so I have to tell it everything basically.
# the example42 one is more reliable, but I can't use it because it conflicts.
# this will get us whatever the latest version is at the time
# I don't know why it doesn't work like it's supposed to :|
# I'm really only using it at this point because the rtyler/jenkins module wants it :|
    class{ 'java':
        distribution => 'jdk',
        package      => 'openjdk-8-jdk',
        version      => 'present',
    }

# anything that's going to run jenkins stuff will need rpm
    package { 'rpm':
    # I don't think we care about the version here...
        ensure => present,
    }

    package { 'expect':
    # This is needed by the rpm-maven-plugin
        ensure => present,
    }

    package { 'dpkg-sig':
    # This is needed by the jdeb maven plugin
        ensure => present,
    }

    package { 'git':
        ensure => present,
    }

    package { 'gcc':
        # This is needed by API-Checker's use of Nailgun
        ensure => present,
    }

#jenkins master needs a git config so that it can talk to the scm plugin
# Also needed by any of the release builds for when they do a git push
    file{ "${jenkins_home}/.gitconfig":
        ensure => file,
        mode   => 0664,
        owner  => jenkins,
        group  => jenkins,
        source => "puppet:///modules/repose_jenkins/jenkins-gitconfig",
    }

    group { 'jenkins':
        ensure => present,
    }

    group { 'docker':
        ensure => present,
    }

    user { 'jenkins':
        ensure     => present,
        gid        => 'jenkins',
        groups     => 'docker',
        home       => $jenkins_home,
        shell      => '/bin/bash',
        managehome => true,
        require    => Group['docker'],
    }

    Sshkey<|title == 'github.com'|> {
        ensure => present,
        name   => $github_key_info["name"],
        key    => $github_key_info["key"],
        type   => $github_key_info["type"],
        target => "${jenkins_home}/.ssh/known_hosts"
    }

    ssh_authorized_key { 'jenkins':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDRLK7eHYRbfj/NgIUlc8ECZD9EFwvj4ZvQDrkMX+4HBcpvQr6vVvQlezx7qtCnpZtPYbQvp0udxsfU9+ESlBMGcZBPjnJsKqlomYwaKcxaNKXe4FXGB9fi3si0fEt90pNBqTMjwOzzHj8jqu7PSz5A4tHfdNdJ+IN8IWI4S/YeqVXrdPtsM4Kpi/woSEYUd9Ma4ia/0fHjg4S6/Nb1cFFtx5OQejS6NIpOT3AcSkvOGfDQPHO3GhhZTufbmWeCiT4cOCgCZmlT6eDpl3R8eXWKIn6UGmBSfV1pqs7DFKSGMepV2HVsEtoButIlSfj2BP2mFJ6g1SstDsWCaw+jbtyN',
        user    => 'jenkins'
    }

# this is the old jenkins key from the old server, it can go away eventually.
    ssh_authorized_key { 'old_jenkins':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAuy/VESlo9iZAa9YQbEv9JGvvEsRKC3HxW2XivlDchGOxUNfrdaBGtFjMPe5rf6Qlv1hJ8bvHqZgCQIWYigRF45GXPJXGCaMWFoADG5+Mtr4SfoOWE8i6rVRphaKdIDV+UlhNQWlr4Cw/K4sgJB671qbSQjkn1H2uHiECMB1iUBtE8aOyDQm2bNzHh2sVyrDbUDm7zU354dIo84r3HhHVsK+3d0IhkiIhtWXc7IH4wL0pJ8B2Iv6FVLsQlY+pibGBPQzns25j83bPN01tj2JAxe6EqgsUyIJVu3Hb4UpFWkWquLQnOg0xbRHP/UnK5bQb/NI1ly/HKvt9xxQH8cEERQ==',
        user    => 'jenkins'
    }

    file { "${jenkins_home}/.ssh":
        ensure  => directory,
        owner   => jenkins,
        group   => jenkins,
        mode    => '0700',
    }

    file{ "${jenkins_home}/.ssh/id_rsa":
        ensure  => file,
        mode    => 0600,
        owner   => jenkins,
        group   => jenkins,
        content => "${deploy_key}",
        require => File["${jenkins_home}/.ssh"],
    }

    file{ "${jenkins_home}/.ssh/id_rsa.pub":
        mode    => 0600,
        owner   => jenkins,
        group   => jenkins,
        content => "${deploy_key_pub}",
        require => File["${jenkins_home}/.ssh"],
    }

    file{ "${jenkins_home}/.ssh/repo_key":
        mode    => 0600,
        owner   => jenkins,
        group   => jenkins,
        content => "${repo_key}",
        require => File["${jenkins_home}/.ssh"],
    }

    file{ "${jenkins_home}/.ssh/repo_key.pub":
        mode    => 0600,
        owner   => jenkins,
        group   => jenkins,
        content => "${repo_key_pub}",
        require => File["${jenkins_home}/.ssh"],
    }

    file { "${jenkins_home}/plugins":
        ensure  => directory,
        owner   => jenkins,
        group   => jenkins,
        mode    => '0755',
        require => User['jenkins']
    }

    file{ "${jenkins_home}/saxon_ee":
        ensure  => directory,
        owner   => jenkins,
        group   => jenkins,
        mode    => 0750,
        require => User['jenkins'],
    }

    file { "${jenkins_home}/saxon_ee/saxon-license.lic":
        ensure  => file,
        owner   => jenkins,
        group   => jenkins,
        mode    => 0440,
        content => "${saxon_ee_license}",
        require => File["${jenkins_home}/saxon_ee"],
    }
}
