class repose_icinga::server(
    $icinga2_user = undef,
    $icinga2_pass = undef,
    $icingaweb2_user = undef,
    $icingaweb2_pass = undef,
    $icinga2admin_user = undef,
    $icinga2admin_pass = undef,
) {
    include repose_icinga
    include ::icinga2
    include ::postgresql::server

    class { '::icinga2':
        manage_repo => true,
        confd     => false,
        features  => ['checker','mainlog','notification','statusdata','compatlog','command'],
        constants => {
            'ZoneName' => 'master',
        },
    }
}
