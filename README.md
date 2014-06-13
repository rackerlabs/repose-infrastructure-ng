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
    

## Useful references
* http://ttboj.wordpress.com/2013/02/20/automatic-hiera-lookups-in-puppet-3-x/
* http://librarian-puppet.com/
* https://forge.puppetlabs.com/puppetlabs/firewall

## Setting up eyaml
https://github.com/TomPoulton/hiera-eyaml#configuration-file-for-eyaml
