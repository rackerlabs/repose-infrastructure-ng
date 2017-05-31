class repose_idea(
  $version = '2017.1.3',
  $build = '171.4424.56',
  $base_url = 'https://download.jetbrains.com/idea',
) {

  #downloads and explodes the given version
  archive{ "idea-$version":
    ensure          => present,
    path            => "/tmp/ideaIU-${version}.tar.gz",
    extract         => true,
    extract_path    => '/opt',
    creates         => "/opt/idea-IU-${build}",
    source          => "${base_url}/ideaIU-${version}.tar.gz",
    checksum_verify => false,
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
