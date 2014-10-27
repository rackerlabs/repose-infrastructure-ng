##
# Create a defined type to create targets to backup, each one should create it's own backup script
define backup_cloud_files::targets(
    $targets = [],
    $container = undef,
    $cf_username = undef,
    $cf_apikey = undef,
    $cf_region = undef,
    $duplicity_options = ""
){
    include backup_cloud_files

    # create a backup file based on targets and container and probably name?
    if ! $container {
        fail("You must specify a container to put this stuff in")
    }

    if ! $cf_username {
        fail("A CloudFiles username must be specified")
    }
    if ! $cf_apikey {
        fail("A CloudFiles API KEY must be specified")
    }

    if ! $cf_region {
        fail("A CloudFiles Region must be specified")
    }

    if $targets == [] {
        fail("You really need to specify some stuff to back up...")
    }

    # now create a backup file, somewhere, probably /usr/local/bin/duplicity_container.sh
    file{"/usr/local/bin/backup_${container}.sh":
        ensure => present,
        owner => root,
        group => root,
        mode => 0770,
        content => template("backup_cloud_files/backup_script.sh.erb"),
        require => Class[Backup_cloud_files],
    }

    # a handy utility script, because it's slightly more complicated than it should be
    file{"/usr/local/bin/utility_${container}.rb":
        ensure => present,
        owner => root,
        group => root,
        mode => 0770,
        content => template("backup_cloud_files/utility_script.rb.erb"),
        require => Class[Backup_cloud_files],
    }

}