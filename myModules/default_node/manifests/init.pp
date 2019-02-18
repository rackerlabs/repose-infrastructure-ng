class default_node {
  class { 'users': }
  # we want all firewall resources purged, so only the puppet ones apply
  resources { "firewall":
      purge => true
  }
  # resources { 'firewallchain':
  #     purge => true,
  # }

  Firewall {
      before  => Class['base::fw_post'],
      require => Class['base::fw_pre'],
  }

  class { ['base::fw_pre', 'base::fw_post']: }
  class { 'base': }
  class { 'cloud_monitoring': }

  class { 'firewall': }

  # just setting swap size to a 4GB swapfile no matter what
  # if this becomes a problem in the future, change it, or make it more dynamic
  # the base::swap class will base it on the size of the ram, if not specified
  base::swap { 'swapfile':
          swapfile => '/swapfile',
          swapsize => 4096,
      }

  # have to actually include it!
  class { 'repose_nagios::client': }
}