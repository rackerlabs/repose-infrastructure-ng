class base(
    # these defaults are for centos 6.5 if we need other magics, we can get it from hiera
    $rxvt_terminfo = "rxvt-unicode-256color"
) {

    file { '/etc/profile.d/ls.sh':
        ensure => present,
        source => 'puppet:///modules/base/profile-ls.sh',
        mode   => "0755",
        owner  => root,
        group  => root,
    }

    package{'tmux':
        ensure => present,
    }

    file{"/etc/tmux.conf":
        ensure  => present,
        source  => "puppet:///modules/base/tmux.conf",
        mode    => "0664",
        owner   => root,
        group   => root,
        require => Package['tmux'],
    }

    package{'wget':
        ensure => present,
    }

    package{'haveged':
        ensure => present,
    }

    service{"haveged":
        ensure  => running,
        enable  => true,
        require => Package["haveged"],
    }

    # I run URXVT and I can never less or anytyhing, because missing terminfo!
    # Therefore put this jank on there, so I can has terminfo. There's no specific terminfo package for centos :(
    # There is for debians and for archlinuxes
    package{'rxvt-unicode-terminfo':
        name => $rxvt_terminfo
    }

    package{'chrony':
        ensure => present,
    }

    file{'chrony_config':
        ensure  => present,
        path    => "/etc/chrony.conf",
        source  => "puppet:///modules/base/chrony-client.conf",
        mode    => "0660",
        owner   => root,
        group   => root,
        require => Package["chrony"],
        notify  => Service["chrony"],
        backup  => false,
    }

    service{"chrony":
        ensure  => running,
        enable  => true,
        require => [
            Package["chrony"],
            File["chrony-config"]
        ],
    }

    file { '/etc/localtime':
        ensure => link,
        target => '/usr/share/zoneinfo/CST6CDT',
        backup => false,
    }

}