class ssl_cert(
    $ssl_cert = "NOPE",
    $ssl_key = "NOPE"
){
    file{ "/etc/ssl/certs/openrepose.crt":
        ensure  => file,
        mode    => 0444,
        owner   => root,
        group   => root,
        content => $ssl_cert,
    }

# Deprecating this in favor of /etc/ssl/keys and a group
#use instead the /etc/ssl/keys/openrepose.key and make sure your user is in the ssl-keys group
    file{ "/etc/ssl/private/openrepose.key":
        ensure  => file,
        mode    => 0440,
        owner   => root,
        group   => root,
        content => $ssl_key,
    }

# Creating an ssl-keys group that has a reasonably high GID, probably safe
    group{ "ssl-keys":
        ensure => present,
        gid    => 2000,
    }

    file{ "/etc/ssl/keys":
        ensure  => directory,
        owner   => root,
        group   => "ssl-keys",
        mode    => 0750,
        require => Group["ssl-keys"],
    }

    file{ "/etc/ssl/keys/openrepose.key":
        ensure  => file,
        mode    => 0440,
        owner   => root,
        group   => "ssl-keys",
        content => $ssl_key,
        require => [
            Group["ssl-keys"],
            File["/etc/ssl/keys"]
        ],
    }
}