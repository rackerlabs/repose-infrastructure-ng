#!/bin/bash

# install the puppet primary repos
sudo rpm -ivh --force http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm &&

# install the EPEL repo, because it's handy
sudo rpm -ivh --force http://epel.mirror.freedomvoice.com/6/i386/epel-release-6-8.noarch.rpm &&

sudo yum install -y puppet &&
sudo yum install -y git &&

cd /srv &&
# once we get the stuff encrypted, we can public this repo!
git clone https://github.com/rackerlabs/repose-infrastructure-ng.git puppet &&

cd /etc/puppet &&
mkdir -p ssl &&
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

echo "PREP DONE! Last steps:"
echo "Put the eyaml backend cert and key onto this system"
echo "at  /etc/puppet/ssl/private_key.pkcs7.pem"
echo "and /etc/puppet/ssl/public_key.pkcs7.pem"
echo "then run puppet apply /etc/puppet/manifests/puppet_master.pp"
