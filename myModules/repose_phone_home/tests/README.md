# To test this module

## Local development machine

### Install the module's dependencies
`puppet module install puppetlabs-mongodb`

### Validate using the test manifest
`puppet apply --noop --test \`
`   --modulepath=~/.puppet/modules:<REPOSE_INFRASTRUCTURE_NG_DIR>/myModules/ \`
`   <REPOSE_INFRASTRUCTURE_NG_DIR>/myModules/repose_phone_home/tests/init.pp`

### Copy from development machine to test server
`cd <REPOSE_INFRASTRUCTURE_NG_DIR>`
`ssh root@et.openrepose.org.bast 'gem install hiera-eyaml'`
`ssh root@et.openrepose.org.bast 'mkdir -p /etc/puppet/ssl/'`
`scp -p  ~/keys/eyaml/public_key.pkcs7.pem                           root@et.openrepose.org.bast:/etc/puppet/ssl/`
`scp -p  ~/keys/eyaml/private_key.pkcs7.pem                          root@et.openrepose.org.bast:/etc/puppet/ssl/`
`scp -p  <REPOSE_INFRASTRUCTURE_NG_DIR>/hiera.yaml                   root@et.openrepose.org.bast:/etc/puppet/`
`scp -rp <REPOSE_INFRASTRUCTURE_NG_DIR>/hieradata/                   root@et.openrepose.org.bast:/etc/puppet/`
`scp -rp <REPOSE_INFRASTRUCTURE_NG_DIR>/myModules/repose_phone_home/ root@et.openrepose.org.bast:/etc/puppet/modules/`

## Remote test server

### Install the module's dependencies
`puppet module install puppetlabs-mongodb`

### Validate using the test manifest
`puppet apply --noop --test \`
`   /etc/puppet/modules/repose_phone_home/tests/init.pp`

## Things to look at:
* https://tickets.puppetlabs.com/browse/MODULES-534
* https://tickets.puppetlabs.com/browse/MODULES-878
