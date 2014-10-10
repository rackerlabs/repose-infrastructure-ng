# Description of how to recreate mumble server (murmur)

Set up a fedora cloud machine, because CentOS is too old.

`yum install mumble-server`

Configure the firewall to allow the ports:
https://fedoraproject.org/wiki/FirewallD#Using_static_firewall_rules_with_the_iptables_and_ip6tables_services

I used the old static rules instead of firewalld, because I didn't feel like dorking with firewalld.


## Optionally you can configure it more

You can then set up the superuser password by hand, see `man murmurd`

Then you just follow the instructions on the [mumble ACL documentation](http://mumble.sourceforge.net/ACL_and_Groups#Groups)

Then people can connect and talk!


## Firewall configs

This is a way to get it to listen on 443 so that way mumble works

```
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
# configuration to forward 443 to mumbles 64738
-A PREROUTING -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 64738
-A PREROUTING -i eth0 -p udp --dport 443 -j REDIRECT --to-port 64738
COMMIT
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 64738 -j ACCEPT
-A INPUT -m state --state NEW -m udp -p udp --dport 64738 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
```