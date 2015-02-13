class repose_jenkins::gradle(
    $version = '2.1',
    $base_url = 'http://downloads.gradle.org/distributions',
    $sha256 = 'b351ab27da6e06a74ba290213638b6597f2175f5071e6f96a0a205806720cb81'
) {

    archive{ "gradle-$version":
        ensure           => present,
        url              => "${base_url}/gradle-${version}-all.zip",
        follow_redirects => true,
        target           => "/opt",
        extension        => "zip",
        checksum         => false,
        digest_type      => 'sha256',
        digest_string    => $sha256,
    }

    file{'gradle-symlink':
        path => '/opt/gradle',
        ensure => link,
        target => "/opt/gradle-${version}",
        require => Archive["gradle-${version}"]
    }
}