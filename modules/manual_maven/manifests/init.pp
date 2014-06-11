class manual_maven  ($version = '3.0.4'){

  common_utils::download_and_extract {"http://archive.apache.org/dist/maven/binaries/apache-maven-$version-bin.tar.gz":
    download_dir         => '/opt',
    archive_name         => "apache-maven-$version-bin.tar.gz",
    exploded_archive_dir => "apache-maven-$version",
  }

  file {'/opt/maven':
    ensure => link,
    target => "/opt/apache-maven-$version",
  }

  define add-to-path {
    file { "/usr/bin/${title}":
      ensure => link,
      target => "/opt/maven/bin/${title}",
    }
  }

  add-to-path {['mvn', 'mvnDebug']:}
}
