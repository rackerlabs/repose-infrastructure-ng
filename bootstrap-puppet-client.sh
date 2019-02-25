#!/bin/bash

# Applies to debian flavors only now.
command -v lsb_release > /dev/null 2>&1
if [[ $? == 1 ]] ; then
    echo "Unrecognized OS for Repose infrastructure ; platform not supported!!!"
    exit 1
fi

# Since the boxes should have a proper hostname of something.openrepose.org
# they will know how to find the puppet master already (puppet.openrepose.org)
MAJ_VER="6"
CODENAME=$(lsb_release --short --codename)
REPODEB="puppet${MAJ_VER}-release-${CODENAME}.deb"
wget -O /tmp/$REPODEB https://apt.puppetlabs.com/$REPODEB &&
dpkg -i /tmp/$REPODEB &&
rm -f /tmp/$REPODEB &&
apt-get update &&
apt-get upgrade -y &&
apt-get autoclean -y &&
apt-get autoremove -y &&
PUPPET_VERSION=6.2.0-1${CODENAME}
apt install -y puppet-agent=${PUPPET_VERSION} &&

echo "Executing puppet agent for the first time." &&
source /etc/profile.d/puppet-agent.sh &&
puppet agent --enable &&
puppet agent --test

echo -e "\n\nThe cert needs to be signed on the puppet master before setup can continue." &&
echo -e "\n\tpuppetserver ca sign --certname $(facter fqdn)"
echo -en "\n\nExecute the following when the cert is signed"
test -f /var/run/reboot-required && echo -en " and the server rebooted"
echo -e " to complete setup:\n"
echo -e "\tsource /etc/profile.d/puppet-agent.sh &&"
echo -e "\tpuppet agent --test\n\n"
