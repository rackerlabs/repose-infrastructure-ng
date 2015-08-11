Repose Puppet Setup
===================

Using Debian wheezy. CentOS is too old :(

# Only manual steps!
1. Create a Debian Wheezy cloud box
2. Set up it's local hostname if necessary
3. Run the client bootstrap.sh from this repository
4. Set it's hostname in the site.pp if necessary
5. Fire up the puppet agent
6. Update any DNS records to point to your new box
7. If Jenkins slave, update Jenkins node list

# Manual steps for master
1. Set hostname
2. Set up the eyaml backend key/cert
3. Run the master bootstrap script

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

### puppetlabs/java
Provides support for installing multiple javas, and setting them up. The rtyler/jenkins module depends on this guy.

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
