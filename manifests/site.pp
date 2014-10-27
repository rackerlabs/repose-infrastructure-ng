
# we want all firewall resources purged, so only the puppet ones apply
resources { "firewall":
    purge => true
}

Firewall {
    before  => Class['base::fw_post'],
    require => Class['base::fw_pre'],
}


node default {
    include users
    include base
    include cloud_monitoring

    # include the pre and post firewall stuff for all hosts
    class { ['base::fw_pre', 'base::fw_post']: }
    class { 'firewall': }

    # just setting swap size to a 4GB swapfile no matter what
    # if this becomes a problem in the future, change it, or make it more dynamic
    # the base::swap class will base it on the size of the ram, if not specified
    base::swap { 'swapfile':
        swapfile => '/swapfile',
        swapsize => 4096,
    }
}

node 'puppet.openrepose.org' inherits default {
    include puppet_master
}

node jenkinsSlaves inherits default {
    include repose_jenkins
}

node /^slave[1-9]\.openrepose\.org$/ inherits jenkinsSlaves {

}

node "jenkins-proto.openrepose.org" inherits default {
    include repose_jenkins
    include repose_jenkins::master
}

node "sonar-ng.openrepose.org" inherits default {
    include repose_sonar
}

node "mumble.openrepose.org" inherits default {
  include mumble_server
}

node "repo-work.openrepose.org" inherits default {
    # I think this will make this system have a shell script to do backups on!
    backup_cloud_files::targets{"some_stuff":
        targets => ['/srv/test'],
        container => "repoworkbackup",
        cf_username => hiera('rs_cloud_username'),
        cf_apikey => hiera('rs_cloud_apikey'),
        cf_region => 'ORD',
        duplicity_options => "--full-if-older-than 15D --volsize 250 --exclude-other-filesystems"
    }
}