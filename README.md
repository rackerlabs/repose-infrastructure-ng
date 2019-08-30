Repose Puppet Setup
===================

# Only manual steps!
For additional details, see [Good things to know - Replace Jenkins Slave](https://one.rackspace.com/display/repose/Good+things+to+know#Goodthingstoknow-ReplaceJenkinsSlave).  
  
1. Create a Debian 9 (Stretch) cloud box.
    1. Set up it's local hostname.
2. Update any DNS records, both IPV4 and IPV6, to point to the new box.
3. Add it's hostname to the `site.pp` if necessary.
4. Download and execute the client `bootstrap-puppet-client.sh` from this repository
    1. `wget https://raw.githubusercontent.com/rackerlabs/repose-infrastructure-ng/master/bootstrap-puppet-client.sh && chmod u+x bootstrap-puppet-client.sh && ./bootstrap-puppet-client.sh`
5. The last step of the `bootstrap-puppet-client.sh` fires up the puppet agent in test mode.
    1. There may be some additional steps indicated when the `bootstrap-puppet-client.sh` completes; read them *all* and do in order.
    2. The client's host certificate will need to be signed on the master:
        `puppetserver ca sign --certname <FQHN>`
    3. Then the puppet agent will need to be executed on the client again:
        `puppet agent --test`
    4. Sometimes the package management system needs updated and the puppet agent ran yet again.
        `apt-get update && puppet agent --test`
6. If the new box is a Jenkins slave, then update the Jenkins' node list.
7. Add it to Prometheus
    1. Add a host config to the prometheus module
    2. Add it to any relevant host groups
    3. Add any specific host checks

# Manual steps for master
1. In step 4 above change it to use `bootstrap-puppet-master.sh`.
2. Copy the eyaml backend key/cert when the script prompts you to.
3. When the script completes, resign all of the client host certificates.

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
In order to edit the eyaml file in our infastructure repo [common.eyaml](https://github.com/rackerlabs/repose-infrastructure-ng/blob/master/hieradata/common.eyaml), you'll need to set up eyaml on your workstation.

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) if needed.
2. Install Hiera-eyaml.
    * `gem install hiera-eyaml`
3. Download the public and private keys from PasswordSafe.
    * The files are under the "Puppet" tab in PasswordSafe.
    * Use the "Edit" page to view the file with line breaks (as they are important).
    * Typical names for these files are:
        * `public_key.pkcs7.pem`
        * `private_key.pkcs7.pem`
    * Make sure they are locked down to only your user:
        * `chmod 600 *.pem`
4. Create/edit your eyaml config file named `~/.eyaml/config.yaml` with the following contents:
```
---
pkcs7_public_key: '/YOUR/FULL/PATH/public_key.pkcs7.pem'
pkcs7_private_key: '/YOUR/FULL/PATH/private_key.pkcs7.pem'
```

5. Edit the eyaml file by running:
    * `eyaml edit common.eyaml`

## Rebuilding Master
If you need to rebuild a new master you can run these commands on the clients to hook them up to the new master.

    puppet resource service puppet ensure=stopped
    # puppet config print ssldir                  this will output the directory for use in the next command, for now all our boxes have it in that directory though
    rm -rf /var/lib/puppet/ssl
    puppet resource service puppet ensure=running
    puppet agent --test
