class manual_groovy ($version = '2.1.1') {

  common_utils::download_and_extract {"http://dist.groovy.codehaus.org/distributions/groovy-binary-$version.zip":
    download_dir         => '/opt',
    archive_name         => "groovy-binary-$version.zip",
    exploded_archive_dir => "groovy-$version",
  }

  file {'/opt/groovy':
    ensure => link,
    target => "/opt/groovy-$version",
  }

  define add-to-path {
    file { "/usr/bin/${title}":
      ensure => link,
      target => "/opt/groovy/bin/${title}",
    }
  }

  add-to-path {['groovy', 'groovyc']:}
}
