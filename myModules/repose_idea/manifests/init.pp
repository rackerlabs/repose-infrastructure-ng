class repose_idea(
  $version = '2016.1',
  $build = '145.258.11',
  $base_url = 'https://download.jetbrains.com/idea',
) {

  #downloads and explodes the given version
  archive{ "idea-$version":
    ensure           => present,
    url              => "${base_url}/ideaIU-${version}.tar.gz",
    follow_redirects => true,
    target           => "/opt",
    checksum         => false,
  }

  #links it for conveince
  file {'idea-symlink':
    path    => '/opt/idea',
    ensure  => link,
    target  => "/opt/idea-IU-${build}",
    require => Archive["idea-${version}"]
  }

  #adds it to the path
  file {'/etc/profile.d/append-idea-path.sh':
    mode    => 644,
    content => 'PATH=$PATH:/opt/idea/bin',
    require => File['idea-symlink'],
  }
}
