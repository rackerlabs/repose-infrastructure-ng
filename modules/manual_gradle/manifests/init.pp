class manual_gradle ($version = '1.8') {

  common_utils::download_and_extract {"http://services.gradle.org/distributions/gradle-$version-bin.zip":
    download_dir         => '/opt',
    archive_name         => "gradle-$version-bin.zip",
    exploded_archive_dir => "gradle-$version",
  }

  file {'/opt/gradle':
    ensure => link,
    target => "/opt/gradle-$version",
  }

  file {'/usr/bin/gradle':
    ensure => link,
    target => '/opt/gradle/bin/gradle',
  }
}
