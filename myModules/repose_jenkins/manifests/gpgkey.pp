class repose_jenkins::gpgkey(
    $repose_signing_pubkey = undef,
    $repose_signing_privkey = undef
) {

    include '::gnupg'

    gnupg_key { 'repose_signing_pubkey':
        ensure      => present,
        key_id      => 'E7C89BBB',
        user        => jenkins,
        key_content => $repose_signing_pubkey,
        key_type    => public,
        require     => User['jenkins'],
    }

    gnupg_key { 'repose_signing_privkey':
        ensure      => present,
        key_id      => 'E7C89BBB',
        user        => jenkins,
        key_content => $repose_signing_privkey,
        key_type    => private,
        require     => User['jenkins'],
    }
}