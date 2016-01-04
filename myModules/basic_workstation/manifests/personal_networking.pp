class basic_workstation::personal_networking(
  $sso = undef
  ) {

  package {['vpnc', 'network-manager-vpnc', 'network-manager-vpnc-gnome']:
    ensure => present,
  }

  $destination = '/etc/NetworkManager/system-connections'

  file {"$destination":
    ensure => directory,
  }

  file {"$destination/DFW VPN":
    content => template("basic_workstation/DFW_VPN"),
    owner   => root,
    group   => root,
    mode    => 0600,
  }

  file {"$destination/IAD VPN":
    content => template("basic_workstation/IAD_VPN"),
    owner   => root,
    group   => root,
    mode    => 0600,
  }

  file {"$destination/ORD VPN":
    content => template("basic_workstation/ORD_VPN"),
    owner   => root,
    group   => root,
    mode    => 0600,
  }

  file {"$destination/Auto Ethernet":
    content => template("basic_workstation/Auto_Ethernet"),
    replace => false,
    owner   => root,
    group   => root,
    mode    => 0600,
  }

  file {"$destination/R-Fast":
    content => template("basic_workstation/R-Fast"),
    replace => false,
    owner   => root,
    group   => root,
    mode    => 0600,
  }
}
