#!/usr/bin/env ruby
#^syntax detection

forge "http://forge.puppetlabs.com"

# use dependencies defined in Modulefile
#modulefile

# pulling in standard lib, and I can use it now
mod 'puppetlabs/stdlib', '4.2.2'

mod 'puppetlabs/firewall', '1.1.2'
mod 'puppetlabs/apt', '1.5.0'

mod 'puppetlabs/postgresql', '3.3.3'

# going to try out this one, which supports both packages and urls
#mod 'example42/java', '2.0.3' # the jenkins one depends on a conflicting named one :(
mod 'puppetlabs/java', '1.1.1'
mod 'maestrodev/maven', '1.2.0'
mod 'maestrodev/sonarqube', '2.1.1'

# dkowis forked this to add debian support. There's a pull request open on the original
# if/when it gets merged, you can use the original directly.
mod 'garethr/remotesyslog',
  :git => "https://github.com/dkowis/garethr-remotesyslog",
  :ref => "debian_wheezy"

mod "repose/base",
    :path => "myModules/base"

mod "repose/cloud_monitoring",
    :path => "myModules/cloud_monitoring"

mod "repose/repose_jenkins",
    :path => "myModules/repose_jenkins"

mod "repose/puppet_master",
    :path => "myModules/puppet_master"

mod "repose/users",
    :path => "myModules/users"

mod "repose/ssl_cert",
    :path => "myModules/ssl_cert"

mod "repose/repose_sonar",
    :path => "myModules/repose_sonar"

mod "repose/mumble_server",
    :path => "myModules/mumble_server"

mod "repose/backup_cloud_files",
    :path => "myModules/backup_cloud_files"

mod "repose/repose_nexus",
    :path => "myModules/repose_nexus"

mod "repose/repose_redirects",
    :path => "myModules/repose_redirects"

mod "repose/repose_nagios",
    :path => "myModules/repose_nagios"

mod "repose/repose_maven",
    :path => "myModules/repose_maven"

mod "repose/repose_gradle",
    :path => "myModules/repose_gradle"

mod "repose/basic_workstation",
    :path => "myModules/basic_workstation"
