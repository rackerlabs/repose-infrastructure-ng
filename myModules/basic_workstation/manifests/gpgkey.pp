class basic_workstation::gpgkey(
    $repose_signing_pubkey = undef,
    $repose_signing_privkey = undef,
    $user = undef
) {

    class{'::gnupg':
        package_name => 'gnupg2'
    }

    gnupg_key { 'repose_signing_pubkey':
        ensure      => present,
        key_id      => 'E7C89BBB',
        user        => $user,
        key_content => $repose_signing_pubkey,
        key_type    => public,
    }

    gnupg_key { 'repose_signing_privkey':
        ensure      => present,
        key_id      => 'E7C89BBB',
        user        => $user,
        key_content => $repose_signing_privkey,
        key_type    => private,
    }
}