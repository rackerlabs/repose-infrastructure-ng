#!/bin/bash

# Applies to debian flavors only now.
which lsb_release > /dev/null 2>&1
if [[ $? == 1 ]] ; then
    echo "Unrecognized OS for Repose infrastructure ; platform not supported!!!"
    exit 1
fi

# Since the boxes should have a proper hostname of something.openrepose.org
# they will know how to find the puppet master already (puppet.openrepose.org)
REPODEB="puppetlabs-release-pc1-$(lsb_release --short --codename).deb"

wget -O /tmp/$REPODEB https://apt.puppetlabs.com/$REPODEB &&
dpkg -i /tmp/$REPODEB &&
rm -f /tmp/$REPODEB &&

apt-get update &&
apt-get install -y puppet

echo "First run of puppet agent, need to sign the cert on the puppet master!"
echo "It's now executing puppet agent --test as the end of the script!"
puppet agent --enable
puppet agent --test
