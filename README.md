Repose Puppet Setup
===================

# Only manual steps!
For additional details, see [Good things to know - Replace Jenkins Slave](https://one.rackspace.com/display/repose/Good+things+to+know#Goodthingstoknow-ReplaceJenkinsSlave).  
  
1. Create a Debian 8 (Jessie) cloud box.
    1. Set up it's local hostname.
2. Update any DNS records, both IPV4 and IPV6, to point to the new box.
3. Add it's hostname to the `site.pp` if necessary.
4. Download and execute the client `bootstrap.sh` from this repository
    1. `wget https://raw.githubusercontent.com/rackerlabs/repose-infrastructure-ng/master/bootstrap-puppet-client.sh && chmod u+x bootstrap-puppet-client.sh && ./bootstrap-puppet-client.sh`
5. The last step of the `bootstrap.sh` fires up the puppet agent in test mode.
    1. There may be some additional steps indicated when the `bootstrap.sh` completes; read them *all* and do in order.
    2. The client's host certificate will need to be signed on the master:
        `puppet cert sign <FQHN>`
    3. Then the puppet agent will need to be executed on the client again:
        `puppet agent --test`
6. If the new box is a Jenkins slave, then update the Jenkins' node list.

# Manual steps for master
1. Set hostname.
2. Set up the eyaml backend key/cert.
3. Run the master bootstrap script.

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
