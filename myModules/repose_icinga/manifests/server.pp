class repose_icinga::server(
    $icinga2_user = undef,
    $icinga2_pass = undef,
    $icingaweb2_user = undef,
    $icingaweb2_pass = undef,
    $icinga2admin_user = undef,
    $icinga2admin_pass = undef,
    $icinga_version = '2.6.0',
    $icingaweb_version = '2.4.1',
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
