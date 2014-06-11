repose-infrastructure-management
================================

# Only manual steps!
Create the cloud box, set it's hostname in the site.pp, fire up the puppet agent

# Manual steps for master
Set up the eyaml backend key/cert.

# TODO: UPDATE THIS

Contains puppet manifests and related material for the repose teams project infrastructure

Run locally with 

    sudo puppet apply --modulepath ./modules manifests/jenkins-slave.pp
    

    

## Useful references
* http://ttboj.wordpress.com/2013/02/20/automatic-hiera-lookups-in-puppet-3-x/

## Setting up eyaml
https://github.com/TomPoulton/hiera-eyaml#configuration-file-for-eyaml