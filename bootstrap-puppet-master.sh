#!/bin/bash

# set it up to work with debians now
MAJ_VER="6"
CODENAME=$(lsb_release -cs)
wget https://apt.puppetlabs.com/puppet${MAJ_VER}-release-${CODENAME}.deb &&
dpkg -i puppet${MAJ_VER}-release-${CODENAME}.deb &&
apt update &&

# install needed things
apt install -y git puppetserver ruby-full make &&
source /etc/profile.d/puppet-agent.sh

if [[ "$(facter fqdn)" == "" ]]; then
  echo "UNABLE TO PROCEED, puppet cannot find a hostname, ensure `facter fqdn` returns a hostname"
  echo "CentOS Reference: http://www.rackspace.com/knowledge_center/article/centos-hostname-change"
  echo "Debian Reference: https://wiki.debian.org/HowTo/ChangeHostname"
  exit 1
fi

# set the JVM Initial and Max memory
sed -i -r 's/-Xm([xs])[0-9]+[kmgKMG]/-Xm\1512m/g' /etc/default/puppetserver

cd /srv &&
# once we get the stuff encrypted, we can public this repo!
git clone https://github.com/rackerlabs/repose-infrastructure-ng.git puppet &&

#Using this to manage our puppet modules
echo "Installing librarian-puppet and bundler..." &&
gem install bundler librarian-puppet hiera-eyaml --no-rdoc --no-ri &&

# ensure links are clean
rm -rf /etc/puppetlabs/code/environments/production/modules/ &&
rm -rf /etc/puppetlabs/puppet/hiera.yaml  &&
rm -rf /etc/puppetlabs/puppet/hieradata   &&
rm -rf /etc/puppetlabs/puppet/manifests   &&
rm -rf /etc/puppetlabs/puppet/puppet.conf &&

# create symlinks to the git repo
cd /etc/puppetlabs/code/environments/production &&
ln -s /srv/puppet/modules     &&
cd /etc/puppetlabs/puppet     &&
ln -s /srv/puppet/hiera.yaml  &&
ln -s /srv/puppet/hieradata   &&
ln -s /srv/puppet/manifests   &&
ln -s /srv/puppet/puppet.conf &&

# actually install the modules onto the server
# if you ever want to use different modules, you have to update the modules, and run the install again
cd /srv/puppet &&
echo "Installing modules with librarian-puppet..." &&
librarian-puppet install --no-use-v1-api &&
echo "Generating SSL CA certs..." &&
puppetserver ca setup

mkdir -p /etc/puppetlabs/puppet/eyaml
FILES=(
    /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
    /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
)
for file in ${FILES[*]} ; do
    while [ ! -f ${file} ]; do
        read -rsp "$(echo -e "\nWaiting for required eyaml certs/keys: ${file}\n - Press any key to continue...\n\n ")" -t5 -n1 key
    done
done

echo "Applying the master manifest..." &&
puppet apply --detailed-exitcodes /etc/puppetlabs/puppet/manifests/puppet_master.pp
