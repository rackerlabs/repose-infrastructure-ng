#!/bin/bash

# set it up to work with debians now
MAJ_VER="6"
CODENAME=$(lsb_release -cs)
wget https://apt.puppetlabs.com/puppet${MAJ_VER}-release-${CODENAME}.deb &&
dpkg -i puppet${MAJ_VER}-release-${CODENAME}.deb &&
apt update &&

# install needed things
apt install -y git puppetserver ruby-full make &&

if [[ "$(/opt/puppetlabs/bin/facter fqdn)" == "" ]]; then
  echo "UNABLE TO PROCEED, puppet cannot find a hostname, ensure `/opt/puppetlabs/bin/facter fqdn` returns a hostname"
  echo "CentOS Reference: http://www.rackspace.com/knowledge_center/article/centos-hostname-change"
  echo "Debian Reference: https://wiki.debian.org/HowTo/ChangeHostname"
  exit 1
fi

cd /srv &&
# once we get the stuff encrypted, we can public this repo!
git clone https://github.com/rackerlabs/repose-infrastructure-ng.git puppet &&

#Using this to manage our puppet modules
echo "Installing librarian-puppet and bundler" &&
gem install bundler librarian-puppet hiera-eyaml --no-rdoc --no-ri &&

# ensure links are clean
rm -rf /etc/puppetlabs/puppet/modules     &&
rm -rf /etc/puppetlabs/puppet/hiera.yaml  &&
rm -rf /etc/puppetlabs/puppet/hieradata   &&
rm -rf /etc/puppetlabs/puppet/manifests   &&
rm -rf /etc/puppetlabs/puppet/puppet.conf &&

# create symlinks to the git repo
cd /etc/puppetlabs/puppet     &&
ln -s /srv/puppet/modules     &&
ln -s /srv/puppet/hiera.yaml  &&
ln -s /srv/puppet/hieradata   &&
ln -s /srv/puppet/manifests   &&
ln -s /srv/puppet/puppet.conf &&

# actually install the modules onto the server
# if you ever want to use different modules, you have to update the modules, and run the install again
cd /srv/puppet &&
librarian-puppet install --no-use-v1-api

echo -e "\n\nPREP DONE! Last steps:"
echo "Put the eyaml backend cert and key onto this system"
echo "at  /etc/puppetlabs/puppet/ssl/private_key.pkcs7.pem"
echo "and /etc/puppetlabs/puppet/ssl/public_key.pkcs7.pem"
echo "run puppet master --no-daemonize --verbose one time to generate the SSL certs it needs"
echo "kill it after a few moments, so it's generated the ssl certs"
echo "then run puppet apply /etc/puppetlabs/puppet/manifests/puppet_master.pp"
