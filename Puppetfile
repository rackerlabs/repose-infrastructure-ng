#!/usr/bin/env ruby
#^syntax detection

forge "http://forge.puppetlabs.com"

# use dependencies defined in Modulefile
#modulefile

# pulling in standard lib, and I can use it now
mod 'puppetlabs/stdlib', '4.10.0'

mod 'puppetlabs/firewall', '1.7.2'
mod 'puppetlabs/apt', '2.2.0'

mod 'puppetlabs/postgresql', '4.6.1'

# going to try out this one, which supports both packages and urls
#mod 'example42/java', '2.0.3' # the jenkins one depends on a conflicting named one :(
#going to the git version because it supports ubuntu wily, once a released version catches up go back to a hard number
mod 'puppetlabs/java',
    :git => "git://github.com/puppetlabs/puppetlabs-java.git"
mod 'maestrodev/maven', '1.4.0'
mod 'maestrodev/sonarqube', '2.6.6'
mod 'rtyler/groovy', '1.0.3'
mod 'garethr/scala', '0.1.2'
mod 'danzilio/virtualbox', '1.6.0'
mod 'mjanser/vagrant', '1.1.0'
#mod 'gini/idea', '0.3.0'
mod 'jamesnetherton/google_chrome', '0.2.1'

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

mod "repose/adrian_workstation",
    :path => "myModules/adrian_workstation"

mod "repose/repose_phone_home",
    :path => "myModules/repose_phone_home"
