class repose_groovy(
  $version = '2.4.5',
  $base_url = 'http://dl.bintray.com/groovy/maven',
) {

  #downloads and explodes the given version
  archive{ "groovy-$version":
    ensure          => present,
    path            => "/tmp/apache-groovy-sdk-${version}.zip",
    extract         => true,
    extract_path    => '/opt',
    creates         => "/opt/groovy-${version}",
    source          => "${base_url}/apache-groovy-sdk-${version}.zip",
    checksum_verify => false,
  }

  #links it for conveince
  file {'groovy-symlink':
    path    => '/opt/groovy',
    ensure  => link,
    target  => "/opt/groovy-${version}",
    require => Archive["groovy-${version}"]
  }

  #adds it to the path
  file {'/etc/profile.d/append-groovy-path.sh':
    mode    => '0644',
    content => 'PATH=$PATH:/opt/groovy/bin',
    require => File['groovy-symlink'],
  }
}
