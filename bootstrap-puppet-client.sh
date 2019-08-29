#!/bin/bash

# Applies to debian flavors only now.
command -v lsb_release > /dev/null 2>&1
if [[ $? == 1 ]] ; then
    echo "Unrecognized OS for Repose infrastructure ; platform not supported!!!"
    exit 1
fi

# Since the boxes should have a proper hostname of something.openrepose.org
# they will know how to find the puppet master already (puppet.openrepose.org)
CODENAME=$(lsb_release --short --codename)
PUPPET_VERSION=6.2.0
MAJ_VER=$(echo $PUPPET_VERSION | cut -d. -f1)
REPODEB="puppet${MAJ_VER}-release-${CODENAME}.deb"
if [ ! -f "/tmp/$REPODEB" ] ; then
    wget "https://apt.puppetlabs.com/$REPODEB" -O "/tmp/$REPODEB"
fi
AGENT_TEST_STATUS=99
dpkg -i /tmp/$REPODEB &&
rm -f /tmp/$REPODEB &&
apt-get update &&
apt-get upgrade -y &&
apt-get autoclean -y &&
apt-get autoremove -y &&
# since Debian doesn't support HTTPS with Apt by default:
apt install -y apt-transport-https ca-certificates &&
# install needed things
apt install -y puppet-agent=${PUPPET_VERSION}-1${CODENAME} &&

echo -e "\n\nExecuting puppet agent for the first time.\n" &&
source /etc/profile.d/puppet-agent.sh &&
puppet agent --enable &&
puppet agent --test ; AGENT_TEST_STATUS=$?

if [[ $AGENT_TEST_STATUS == 1 ]] ; then
    echo -e "\n\nThe cert needs to be signed on the puppet master before setup can continue."
    echo -e "\n\tpuppetserver ca sign --certname $(facter fqdn)"
    echo -en "\n\nExecute the following when the cert is signed"
    test -f /var/run/reboot-required && echo -en " and the server rebooted"
    echo -e " to complete setup:\n"
    echo -e "\tsource /etc/profile.d/puppet-agent.sh &&"
    echo -e "\tpuppet agent --test\n\n"
    exit 0
else
    echo -e "\n\nInitial puppet agent execution exited with: $AGENT_TEST_STATUS\n"
    echo -e "\n\nAn error has occurred. See output above for more details.\n"
    exit 1
fi
