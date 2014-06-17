#!/usr/bin/env ruby
#^syntax detection

forge "http://forge.puppetlabs.com"

# use dependencies defined in Modulefile
#modulefile

# pulling in standard lib, and I can use it now
mod 'puppetlabs/stdlib', '4.2.2'

mod 'puppetlabs/firewall', '1.1.2'
mod 'puppetlabs/apt', '1.5.0'

# going to try out this one, which supports both packages and urls
#mod 'example42/java', '2.0.3' # the jenkins one depends on a conflicting named one :(
mod 'puppetlabs/java', '1.1.1'
mod 'maestrodev/maven', '1.2.0'

mod 'rtyler/jenkins', '1.1.0'

mod 'garethr/remotesyslog',
  :git => "https://github.com/dkowis/garethr-remotesyslog",
  :ref => "debian_wheezy"

mod "repose/base",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "base"

mod "repose/cloud_monitoring",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "cloud_monitoring"

mod "repose/common_utils",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "common_utils"

mod "repose/git",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "git"

mod "repose/repose_jenkins",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "repose_jenkins"

mod "repose/manual_gradle",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "manual_gradle"

mod "repose/manual_groovy",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "manual_groovy"

mod "repose/manual_java",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "manual_java"

mod "repose/manual_maven",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "manual_maven"

mod "repose/puppet_master",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "puppet_master"

mod "repose/users",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "users"

mod "repose/ssl_cert",
    :git => "https://github.com/rackerlabs/repose-puppet-modules",
    :path => "ssl_cert"
