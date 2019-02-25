#!/bin/bash

# Applies to debian flavors only now.
command -v lsb_release > /dev/null 2>&1
if [[ $? == 1 ]] ; then
    echo "Unrecognized OS for Repose infrastructure ; platform not supported!!!"
    exit 1
fi

MAJ_VER="6"
CODENAME=$(lsb_release --short --codename)
REPODEB="puppet${MAJ_VER}-release-${CODENAME}.deb"
wget -O /tmp/$REPODEB https://apt.puppetlabs.com/$REPODEB &&
dpkg -i /tmp/$REPODEB &&
rm -f /tmp/$REPODEB &&
apt update &&
apt upgrade -y &&
apt autoclean -y &&
apt autoremove -y &&

# install needed things
PUPPET_VERSION=6.2.0-1${CODENAME}
apt install -y git puppetserver=${PUPPET_VERSION} ruby-full make &&
source /etc/profile.d/puppet-agent.sh

if [[ "$(facter fqdn)" == "" ]]; then
  echo "UNABLE TO PROCEED, puppet cannot find a hostname, ensure `facter fqdn` returns a hostname"
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

# clean and create symlinks to the git repo
cd /etc/puppetlabs/code/environments/production &&
rm -rf modules                                  &&
rm -rf manifests                                &&
rm -rf hiera.yaml                               &&
rm -rf hieradata                                &&
ln -s /srv/puppet/modules                       &&
ln -s /srv/puppet/manifests                     &&
ln -s /srv/puppet/hiera.yaml                    &&
ln -s /srv/puppet/hieradata                     &&

echo -e "\n\n\nCreating the eyaml key directory..." &&
mkdir -p /etc/puppetlabs/puppet/eyaml &&
echo -e "You can copy the keys over now.\n\n\n" &&

# actually install the modules onto the server
# if you ever want to use different modules, you have to update the modules, and run the install again
cd /srv/puppet &&
echo "Installing modules with librarian-puppet..." &&
librarian-puppet install --no-use-v1-api &&
echo "Generating SSL CA certs..." &&
puppetserver ca setup

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
puppet apply /srv/puppet/puppet_apply/puppet_master.pp && \
echo -e '\n\nSuccess!!! Woot!!!\n\n' || \
echo -e "\n\nSomething went wrong ($?). :(\nHopefully it is just a Warning.\n\n"

test -f /var/run/reboot-required && \
echo -e "Reboot Required...\n\n" || \
echo -e "System is ready.\n\n"
