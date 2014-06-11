#Description as to how to recreate the IRC server

I could not make this happen in puppet thanks to secrets, and having to build ruby by hand, because CentOS6.4 ships with ruby 1.8.7 still,
  which is now 3 years dead.

## Install git!

## Install redis from the Remi RPM repo
We need this for the latest version of redis, because CentOS is old again. see http://rpms.famillecollet.com/

Install the repository content rpm for remi-release-6.rpm, then you can do 
`yum install redis --enablerepo=remi` and it'll go get the latest version of redis from remi's rpm repo instead of epel.

## Install ruby via RVM

`curl -sSL https://get.rvm.io | sudo bash -s stable`

## Add users to the RVM group

There's an RVM group added, and those users can modify the rvm installation, installing gems, updating rubies, whatever. Any user can
`rvm use` any ruby, but only users in the rvm group can make changes.

## Install ruby 2.1.0

`rvm install ruby-2.1.0` Technically ruby 2.0 would work, but 2.1.0 is the latest, and works fine as well.

## Install znc
`yum install znc` It'll get it from the epel repo, and that's good enough

## configure ZNC

`su - znc -s/bin/bash` then `znc -d /usr/lib/znc --makeconf`

Follow the prompts and things and configure the znc server. Possibly can get a .pem file for ssl verification.


## Set up the bot

into some folder, /opt/ircbot, then as a normal user: `git clone git://github.com/rackerlabs/repose-irc-bot`

* Set the password in the `lita_config.rb`
* Fire up the bot!
* lita -d (probably wise to throw this into some kind of init script)

## Poke holes in the firewall

/etc/sysconfig/iptables

```
# Simple static firewall loaded by iptables.service. Replace
# this with your own custom rules, run lokkit, or switch to 
# shorewall or firewalld as your needs dictate.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m conntrack --ctstate NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m conntrack --ctstate NEW -m tcp -p tcp --dport 3000 -j ACCEPT
-A INPUT -m conntrack --ctstate NEW -m tcp -p tcp --dport 4097 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
```

## Start up znc

`/etc/init.d/znc start` Don't forget to `chkconfig znc on` as well. 

https://irc.repose.rax.io:4097 is the port I configured the existing box to run under for the web UI. 
The admin can add more poeple to ZNC if they wish to use ZNC.


## Point githubs and jenkinses at the lita bot

See: https://github.com/dkowis/lita-jenkins-notifier and https://github.com/webdestroya/lita-github-commits
