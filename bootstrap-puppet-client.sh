#!/bin/bash

#TODO: OUT OF DATE, modify this to use puppet agent

wget -O /tmp/epel-release-5-4.noarch.rpm http://download.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
sudo rpm -Uvh /tmp/epel-release-5-4.noarch.rpm
rm -f /tmp/epel-release-5-4.noarch.rpm

sudo yum install -y puppet
sudo yum install -y git

cd /etc/puppet
git clone https://github.com/rackerlabs/repose-infrastructure-management.git modules