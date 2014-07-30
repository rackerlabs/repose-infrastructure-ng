#!/bin/bash

# USAGE:
#    wget https://raw.githubusercontent.com/rackerlabs/repose-infrastructure-ng/master/bootstrap-puppet-pairing.sh
#    chmod a+x bootstrap-puppet-pairing.sh
#    sudo bootstrap-puppet-pairing.sh

# Get the Codename of the current OS installation.
CODE_NAME=`lsb_release -c | cut -f2`

# Install Puppet Repository.
echo "Installing Puppet Repository..."
PACKAGE_NAME="puppetlabs-release-$CODE_NAME.deb"
wget -O /tmp/$PACKAGE_NAME https://apt.puppetlabs.com/$PACKAGE_NAME
dpkg -i /tmp/$PACKAGE_NAME &&
rm -f /tmp/$PACKAGE_NAME &&
apt-get update &&

echo "Installing Puppet..." &&
apt-get install -y puppet &&

echo "Creating the Puppet updater..."
cat > /usr/local/sbin/puppet-update.sh << EOF
#!/bin/bash
# Retrieve the list of modules to be applied.
rm -f /etc/puppet/module-install-pairing.sh
wget -O /etc/puppet/module-install-pairing.sh https://raw.githubusercontent.com/rackerlabs/repose-infrastructure-ng/master/module-install-pairing.sh &&
chmod a+x /etc/puppet/module-install-pairing.sh &&
# Install the desired modules.
echo "Installing the desired modules..." &&
/etc/puppet/module-install-pairing.sh &&

# Retrieve the manifest to be applied.
rm -f /etc/puppet/manifests/pairing.pp &&
wget -O /etc/puppet/manifests/pairing.pp https://raw.githubusercontent.com/rackerlabs/repose-infrastructure-ng/master/manifests/pairing.pp &&
# Apply the desired modules.
echo "Applying the manifest..." &&
puppet apply /etc/puppet/manifests/pairing.pp
EOF
chmod a+x /usr/local/sbin/puppet-update.sh &&

# Excute the initial updater.
echo "Initial execution of the Puppet Updater..." &&
/usr/local/sbin/puppet-update.sh

