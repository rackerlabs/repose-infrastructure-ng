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
    4. Sometimes the package management system needs updated and the puppet agent ran yet again.
        `apt-get update && puppet agent --test`
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
Please refer to the [Puppetfile](https://github.com/rackerlabs/repose-infrastructure-ng/blob/master/Puppetfile) for a full list of the modules currently in use.

## Useful references
* http://ttboj.wordpress.com/2013/02/20/automatic-hiera-lookups-in-puppet-3-x/
* http://librarian-puppet.com/
* https://forge.puppetlabs.com/puppetlabs/firewall

## Setting up eyaml
https://github.com/TomPoulton/hiera-eyaml#configuration-file-for-eyaml

## Rebuilding Master
If you need to rebuild a new master you can run these commands on the clients to hook them up to the new master.

    puppet resource service puppet ensure=stopped
    # puppet config print ssldir                  this will output the directory for use in the next command, for now all our boxes have it in that directory though
    rm -rf /var/lib/puppet/ssl
    puppet resource service puppet ensure=running
    puppet agent --test
