class repose_phone_home(
  $daemon_user    = undef,
  $daemon_group   = undef,
  $mongo_host     = "localhost",
  $mongo_port     = 27017,
  $mongo_username = undef,
  $mongo_password = undef,
  $mongo_dbname   = undef,
) {

  class {'::mongodb::globals':
    version => 2.6,
  }

  class {'::mongodb::server':
    port    => $mongo_port,
    verbose => true,
    auth => true,
  }

  mongodb::db { $mongo_dbname:
    user     => $mongo_username,
    password => $mongo_password,
  }

  package{ "openjdk-6-jre-headless":
    ensure => absent,
  }

  package{ "openjdk-7-jre-headless":
    ensure => present,
  }

  apt::source { 'repose':
    location => 'http://repo.openrepose.org/debian',
    release  => 'stable',
    repos    => 'main',
    key      => {
      'id'     => '52F39F131FE73BBC5AFCB3D0389195C8E7C89BBB',
      'content' => '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2

mQENBFT2J8oBCADCxveqtm4+/1VOU2e+eJeUZBJ12dnwCH2P7PNveDaG7mA6FLpL
iZ9BwPqrED34IQMfZHoTAxUSeSe3zn0Y08gRUb/ZtjuOaSJrsI36GS+HsEweMnzX
wUARKTG/j46Z3vwJBN621GbXIKhjx5PxtMtnjAXRHKrUtrO6wPCTW4m+FVDFDGZe
Sx05IKMt9WWlHi+zjA0AXwi61h8XewOad+HQuVhevdtOpunMcv0QsU6MDUsPG+4N
EYETZDcK1t6y67ySEZludz48vqhaYgeS+v2AmMhnzxOtTRyLvONP533By5i9YGW5
NiW6utvl3wUwlA5M1CQSBdJJy9NtN/TrHiefABEBAAG0K1JlcG9zZVNpZ25pbmdL
ZXkgPFJlcG9zZUNvcmVAcmFja3NwYWNlLmNvbT6JATcEEwEIACEFAlT2J8oCGwMF
CwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQOJGVyOfIm7uTMwf/Qy8M/xNdaIni
wKt7qo1NX6Mdo4MyjJ6WCgKSSFvOpc1QfIlAdhnxk31iyMlchtKBpGZQb9kmKtJj
nDKGbSCmprDnKcSzJf/OXvJs1N1xWrjhlkrgnhJ6bJXEct2+g5hZ9CE8yAaCt/E7
O500mkzZ8Ctj4jCSFsUchlSW6tUBGGNRM2B1PaqWI1EZWpOfLCHStI5YVR8n6fJ+
SKhE6s5sStWiKJpMEeDv7juPXWHCyyKjFQBv/L6NAuinP2sdvGL+N+B/tQsYmbKb
RAvlb4lIXClHyKHPfPDX/Xcg0Ig+W6nbAxaM8Kka7abW/LFrL4c9NkvhuTbw5CRD
K+GdF6JdlQ==
=mfDI
-----END PGP PUBLIC KEY BLOCK-----
',
    },
  }

  package{ "repose-phone-home":
    ensure => present,
    require => Apt::Source['repose'],
  }

  file{ '/opt/repose-phone-home/application.properties':
    ensure  => file,
    owner   => $daemon_user,
    group   => $daemon_group,
    mode    => 0600,
    content => template('repose_phone_home/application.properties.erb'),
    require => [
      Package['repose-phone-home']
    ],
    notify  => Service['repose-phone-home'],
  }

  service{ "repose-phone-home":
    ensure  => running,
    enable  => true,
  }

  firewall {'102 forward port 80 to 8080':
    table       => 'nat',
    chain       => 'PREROUTING',
    proto       => 'tcp',
    dport       => '80',
    jump        => 'REDIRECT',
    toports     => '8080'
  }
}
