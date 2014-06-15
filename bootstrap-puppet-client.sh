#!/bin/bash

# Applies to debian wheezy, not to centos any longer.
# Since the boxes should have a proper hostname of something.openrepose.org
# they will know how to find the puppet master already (puppet.openrepose.org)

REPODEB="puppetlabs-release-wheezy.deb"

wget -O /tmp/$REPODEB https://apt.puppetlabs.com/$REPODEB &&
dpkg -i /tmp/$REPODEB &&
rm -f /tmp/$REPODEB &&

apt-get update &&
apt-get install -y puppet

echo "First run of puppet agent, need to sign the cert on the puppet master!"
echo "It'll wait 2 minutes for the cert to be signed, so go sign it!"
puppet agent --test --waitforcert 120
