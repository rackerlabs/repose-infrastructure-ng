class mumble_server(
  $mumble_password = undef
)
{
  #Get the SSL Certs on the machine
  class{'ssl_cert':}

  package {"mumble-server":
      ensure => present
    }

  #make sure the mumble-server user is in the ssl-keys group
  user{"mumble-server":
    ensure => present,
    groups => ["mumble-server", "ssl-keys"],
    require => [
      Class["ssl_cert"],
      Package["mumble-server"],
    ]
  }

  file{"/etc/mumble-server.ini":
    ensure => file,
    owner => 'mumble-server',
    group => 'mumble-server',
    mode => 0640,
    content => template("mumble_server/mumble-server.ini.erb"),
    require => Package['mumble-server'],
    notify => Service['mumble-server'],
  }

  service{"mumble-server":
    ensure => running,
    enable => true,
    require => [
      Package["mumble-server"],
      File["/etc/mumble-server.ini"],
      User["mumble-server"],
      Class["ssl_cert"]
    ],
  }

  #set up stuff to backup the sqlite database for mumble
  package{"ruby-sqlite3":
      ensure => present,
  }

  file{'/srv/mumble_database':
      ensure => directory,
      owner => root,
      group => root,
      mode => 0755
  }

  # establish a backup target
  backup_cloud_files::target{"mumble_database":
    target => '/srv/mumble_database',
    cf_username => hiera('rs_cloud_username'),
    cf_apikey => hiera('rs_cloud_apikey'),
    cf_region => 'DFW',
    duplicity_options => '--full-if-older-than 15D --volsize 250 --exclude-other-filesystems --no-encryption',
    require => File['/srv/mumble_database'],
  }

  file{'/usr/local/bin/backup.rb':
      ensure => file,
      owner => root,
      group => root,
      mode => 0770,
      source => 'puppet:///modules/mumble_server/backup.rb',
      require => [
        Package['ruby-sqlite3'],
        Backup_cloud_files::Target['mumble_database']
      ],
  }

  #TODO: add this backup.rb to cron nightly

  # TODO: can set the superuser passwords -- maybe

  # figured out how to do this from: https://www.tiredpixel.com/2013/09/02/iptables-port-forwarding-using-puppet/
    firewall{'102 forward TCP 443 to 64738':
      table => 'nat',
      chain => 'PREROUTING',
      proto => 'tcp',
      dport => '443',
      jump => 'REDIRECT',
      toports => '64738',
    }

  firewall{'103 forward UDP 443 to 64738':
    table => 'nat',
    chain => 'PREROUTING',
    proto => 'udp',
    dport => '443',
    jump => 'REDIRECT',
    toports => '64738',
  }

  firewall{'100 accept TCP 64738':
    port => 64738,
    proto => tcp,
    action => accept,
  }

  firewall{'101 accept UDP 64738':
    port => 64738,
    proto => udp,
    action => accept,
  }
}