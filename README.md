Repose Puppet Setup
===================

Using Debian wheezy. CentOS is too old :(

# Only manual steps!
Create the cloud box, set up it's local hostname, run the client bootstrap.sh, set it's hostname in the site.pp, fire up the puppet agent

# Manual steps for master
Set hostname, Set up the eyaml backend key/cert, run bootstrap script!

# TODO: UPDATE THIS

Contains puppet manifests and related material for the repose teams project infrastructure

Run locally with 

    sudo puppet apply --modulepath ./modules manifests/jenkins-slave.pp

## Puppet Forge Modules in use
### puppetlabs/stdlib
Providing a standard library and some handy functions. Mostly ones that we're using in our custom modules.
At some point, we should switch to using a Modulefile in our custom modules, so that they can pull in their dependencies
themselves.

### puppetlabs/firewall
A [fantastic firewall module](https://forge.puppetlabs.com/puppetlabs/firewall). Makes it much easier to handle
moderately complicated firewall rules using puppet.

### puppetlabs/apt
Provides [support for debian repo management](https://forge.puppetlabs.com/puppetlabs/apt). Enough said there.

### example42/java
Documentation on this one isn't as good as I'd like, but looking at [the manifests](https://github.com/example42/puppet-java)
directly gives you the settings. It can install from a file, or from a package.

### maestrodev/maven
[Can install maven](https://forge.puppetlabs.com/maestrodev/maven) or install artifacts using maven. Quite handy.

### rtyler/jenkins
[Lots of jenkins management](https://forge.puppetlabs.com/rtyler/jenkins). Plugins, slaves, and master, can all
be configured using this.


## Useful references
* http://ttboj.wordpress.com/2013/02/20/automatic-hiera-lookups-in-puppet-3-x/
* http://librarian-puppet.com/
* https://forge.puppetlabs.com/puppetlabs/firewall

## Setting up eyaml
https://github.com/TomPoulton/hiera-eyaml#configuration-file-for-eyaml
