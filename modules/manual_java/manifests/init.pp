class manual_java ($version = '1.7.0_51', $stripped_down = false) {

  common_utils::download_and_extract {"'http://maven.research.rackspacecloud.com/content/repositories/third-party/com/oracle/jdk/$version/jdk-$version-x64.tar.gz'":
    download_dir         => '/opt',
    archive_name         => "jdk-$version-linux-x64.tar.gz",
    exploded_archive_dir => "jdk$version",
  }

  file {'/opt/java':
    ensure => link,
    target => "/opt/jdk$version",
  }

  define add-to-path {
    file { "/usr/bin/${title}":
      ensure => link,
      target => "/opt/java/bin/${title}",
    }
  }

  add-to-path {['java', 'javac', 'javap', 'jmap', 'jstack', 'jar', 'jps', 'keytool', 'jstat']:}
}
