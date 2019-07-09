#!/usr/bin/env ruby
#^syntax detection

forge "https://forgeapi.puppetlabs.com"

mod 'puppetlabs-stdlib', '5.2.0'

mod 'puppetlabs-apache', '4.1.0'
################################################################################
# There is a bug that was supposedly fixed, but still causes issues with >6.0.0
# on Puppet v6.x
# https://tickets.puppetlabs.com/browse/MODULES-8019
mod 'puppetlabs-apt', '6.0.0'
################################################################################
mod 'puppetlabs-docker', '3.5.0'
mod 'puppetlabs-firewall', '1.15.3'
mod 'puppetlabs-java', '3.3.0'
mod 'puppetlabs-postgresql', '5.12.1'
mod 'puppetlabs-yumrepo_core', '1.0.3'
mod 'puppet-archive', '3.2.1'
mod 'puppet-grafana', '6.0.0'
################################################################################
# Until a release is made, we can use a known good commit on the master branch.
# https://github.com/voxpupuli/puppet-jenkins/issues/891
#mod 'puppet-jenkins', '1.7.0'
mod 'puppet-jenkins',
  :git => "https://github.com/voxpupuli/puppet-jenkins.git",
  :ref => '697876955a3a57fcff6fe3ef95e4a2b978a43bf0'
################################################################################
mod 'puppet-mongodb', '2.4.1'
mod 'puppet-nginx', '0.16.0'
################################################################################
# This module has been deprecated by its author since February 27, 2019.
# The author has suggested puppet-archive as its replacement.
mod 'puppet-wget', '2.0.1'
################################################################################

################################################################################
# REMOVED until a release is made supporting Puppet 6.
# https://github.com/jamesnetherton/puppet-google-chrome
#mod 'jamesnetherton-google_chrome', '0.5.0'
################################################################################
mod 'garethr-scala', '0.1.2'
mod 'golja-gnupg', '1.2.3'
################################################################################
# Until a release is made following my PR, we can use merged SHA.
# https://github.com/dgolja/golja-influxdb/pull/76
#mod 'golja-influxdb', '4.0.0'
mod 'golja-influxdb',
  :git => "https://github.com/dgolja/golja-influxdb.git",
  :ref => '5c5f74dfbda434562d31369b7f8c447895b06a1c'
################################################################################
mod 'icinga-icinga2', '2.1.1'
mod 'icinga-icingaweb2', '2.3.1'
mod 'maestrodev-maven', '1.4.0'
mod 'papertrail-papertrail', '1.1.2'
mod 'paulosuzart-sdkman', '1.0.2'
mod 'Slashbunny-phpfpm', '0.0.18'
################################################################################
# This module has been deprecated by its author since June 27, 2018.
# The author has suggested puppet-python as its replacement.
mod 'stankevich-python', '1.19.0'
################################################################################

mod "repose/base",
    :path => "myModules/base"

mod "repose/cloud_monitoring",
    :path => "myModules/cloud_monitoring"

mod "repose/default_node",
    :path => "myModules/default_node"

mod "repose/repose_jenkins",
    :path => "myModules/repose_jenkins"

mod "repose/puppet_master",
    :path => "myModules/puppet_master"

mod "repose/users",
    :path => "myModules/users"

mod "repose/ssl_cert",
    :path => "myModules/ssl_cert"

mod "repose/backup_cloud_files",
    :path => "myModules/backup_cloud_files"

mod "repose/repose_nexus",
    :path => "myModules/repose_nexus"

mod "repose/repose_redirects",
    :path => "myModules/repose_redirects"

mod "repose/repose_nagios",
    :path => "myModules/repose_nagios"

mod "repose/repose_icinga",
    :path => "myModules/repose_icinga"

mod "repose/repose_maven",
    :path => "myModules/repose_maven"

mod "repose/repose_gradle",
    :path => "myModules/repose_gradle"

mod "repose/basic_workstation",
    :path => "myModules/basic_workstation"

mod "repose/adrian_workstation",
    :path => "myModules/adrian_workstation"

mod "repose/repose_phone_home",
    :path => "myModules/repose_phone_home"

mod "repose/repose_groovy",
    :path => "myModules/repose_groovy"

mod "repose/repose_idea",
    :path => "myModules/repose_idea"

mod "repose/repose_influxdb",
    :path => "myModules/repose_influxdb"

mod "repose/repose_grafana",
    :path => "myModules/repose_grafana"
