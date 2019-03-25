# To test this module

## Local development machine

### Install the module's dependencies
```
puppet module install puppetlabs-mongodb
```

### Validate using the test manifest
```
puppet apply --noop --test \
   --modulepath=~/.puppet/modules:<REPOSE_INFRASTRUCTURE_NG_DIR>/myModules/ \
   <REPOSE_INFRASTRUCTURE_NG_DIR>/myModules/repose_phone_home/tests/init.pp
```

### Copy from development machine to test server
```
ssh root@phone-home.openrepose.org.bast 'gem install hiera-eyaml'
cd <REPOSE_INFRASTRUCTURE_NG_DIR>
ssh root@phone-home.openrepose.org.bast 'mkdir -p /etc/puppet/ssl/'
scp -p  ~/keys/eyaml/public_key.pkcs7.pem  root@phone-home.openrepose.org.bast:/etc/puppet/ssl/
scp -p  ~/keys/eyaml/private_key.pkcs7.pem root@phone-home.openrepose.org.bast:/etc/puppet/ssl/
scp -p  hiera.yaml                         root@phone-home.openrepose.org.bast:/etc/puppet/
scp -rp hieradata/                         root@phone-home.openrepose.org.bast:/etc/puppet/
scp -rp myModules/repose_phone_home/       root@phone-home.openrepose.org.bast:/etc/puppet/modules/
```

## Remote test server

### Install the module's dependencies
```
puppet module install puppetlabs-mongodb
puppet module install puppetlabs-firewall
```

### Dry run using the test manifest
```
puppet apply --noop --test \
   /etc/puppet/modules/repose_phone_home/tests/init.pp
```

### Validate using the test manifest
```
puppet apply \
   /etc/puppet/modules/repose_phone_home/tests/init.pp
```

### Send some test data
```
curl -d '{"serviceId":null,"createdAt":"1970-01-01T00:00:00.000Z","createdAtMillis":0,"jreVersion":"0.0.0_00","jvmName":"Java Test VM","contactEmail":null,"reposeVersion":"0.0.0.0-SNAPSHOT","clusters":[{"filters":["fake-filter-one","fake-filter-two"],"services":["dist-datastore"]}]}' -H 'Content-Type: application/json' http://phone-home.openrepose.org
```

## Things to look at:
* https://tickets.puppetlabs.com/browse/MODULES-534
* https://tickets.puppetlabs.com/browse/MODULES-878
