#!/bin/bash

# install the puppet primary repos
sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm &&

# install the EPEL repo, because it's handy
sudo rpm -ivh http://epel.mirror.freedomvoice.com/6/i386/epel-release-6-8.noarch.rpm &&

sudo yum install -y puppet &&
sudo yum install -y git &&

cd /srv &&
# once we get the stuff encrypted, we can public this repo!
git clone https://github.com/rackerlabs/repose-infrastructure-management.git puppet &&

cd /etc/puppet &&
#ensure links are clean
rm -rf /etc/puppet/modules     &&
rm -rf /etc/puppet/hiera.yaml  &&
rm -rf /etc/puppet/hieradata   &&
rm -rf /etc/puppet/manifests   &&
rm -rf /etc/puppet/puppet.conf &&

# create symlinks to the git repo

ln -s /srv/puppet/modules     &&
ln -s /srv/puppet/hiera.yaml  &&
ln -s /srv/puppet/hieradata   &&
ln -s /srv/puppet/manifests   &&
ln -s /srv/puppet/puppet.conf &&

# I think also it uses /etc/hiera.yaml
ln -sf /srv/puppet/hiera.yaml /etc/hiera.yaml &&

# Finally apply the puppetmaster manifest
puppet apply /etc/puppet/manifests/puppet_master.pp