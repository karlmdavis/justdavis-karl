--- 
title: Lewis DNS Service
kind: topic
summary: Describes the steps necessary to make lewis a DNS server.
---

# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/lewis/") %> sub-guide describes the steps necessary to make the computer a DNS server.

The DNS Server will be used to host the `davisonlinehome.name` domain, which was registered with [1&1 Internet](http://1and1.com/).


## Installing BIND

If you selected the "DNS server" task during OS install, this should already be installed.  To verify, run the following command:

    $ tasksel --list-tasks | grep dns

To see the packages installed for the task, run:

    $ tasksel --task-packages dns-server

If you need to install this task, run:

    # tasksel install dns-server


## DNS Zone: `davisonlinehome.name`

If it doesn't already exist, create a `zones` folder:

    # mkdir /etc/bind/zones

Create a `/etc/bind/zones/davisonlinehome.name.db` file with the following contents:

<pre><code>
$ORIGIN davisonlinehome.name.
$TTL 1h ; sets the default time-to-live for this zone

; name ttl class rr    name-server                 email-addr  (sn ref ret ex min)
@          IN    SOA   ns1.davisonlinehome.name.   hostmaster.davisonlinehomename. (
                              2009070300 ; sn = serial number (yyyymmdd##)
                              2d         ; ref = refresh
                              15M        ; ret = update retry
                              4W         ; ex = expiry
                              1h         ; min = minimum
                              )

; Nameserver Records
; name             ttl    class   rr                name
@                         IN      NS                ns1
@                         IN      NS                ns2
@                         IN      NS                ns3

; IPv4 Address Records
; name             ttl    class   rr                name
@                         IN      A                 75.146.134.36
ns1                       IN      A                 75.146.134.36
ns2                       IN      A                 74.208.2.6    ; 1and1 secondary name server (domain: slv1.1and1.com)
ns3                       IN      A                 217.160.224.4 ; 1and1 secondary name server (domain: slv1.1and1.com)
lewis                     IN      A                 75.146.134.36
eddings                   IN      A                 75.146.134.33
piers                     IN      A                 75.146.134.34
karlanderica              IN      A                 75.146.134.38
edenbrook                 IN      A                 75.146.134.38
feist                     IN      A                 192.168.1.101
kerr                      IN      A                 192.168.1.102
sanderson                 IN      A                 192.168.1.104
mail1                     IN      A                 75.146.134.34 ; MX records must have A records

; CNAME Records
; name             ttl    class   rr                name
mail                      IN      CNAME             mail1
smtp                      IN      CNAME             mail1
kerberos                  IN      CNAME             eddings
ldap                      IN      CNAME             eddings

; Mailserver Records
; name             ttl    class   rr     priority   name
@                         IN      MX     10         mail1

; TXT Records
; name             ttl    class   rr                name
@                         IN      TXT               "v=spf1 ip4:75.146.134.34 ~all"
_kerberos                 IN      TXT               "DAVISONLINEHOME.NAME"

; SRV Records
; name                   ttl    class   rr                name
_kerberos._udp                  IN      SRV               0 0 88 eddings
_kerberos-master._udp           IN      SRV               0 0 88 eddings
_kerberos-adm._tcp              IN      SRV               0 0 749 eddings
_kpasswd._udp                   IN      SRV               0 0 464 eddings

; AFSDB Records
; cell                   ttl    class   rr                name
davisonlinehome.name.           IN      AFSDB             1 eddings.davisonlinehome.name.
</code></pre>

Edit the `/etc/bind/named.conf.local` file and and the following lines to the end:

<pre><code>
# List other trusted name servers that are allowed to request zone transfers:
acl trusted-servers  {
        74.208.2.6;  // 1and1 secondary name server (domain: slv1.1and1.com)
        217.160.224.4;  // 1and1 secondary name server (domain: slv1.1and1.com)
};

# Forward definition for davisonlinehome.name:
zone "davisonlinehome.name" {
	type master;
	file "/etc/bind/zones/davisonlinehome.name.db";
	allow-transfer { trusted-servers; };
};
</code></pre>

Edit the `/etc/bind/named.conf.options` file and set the `forwarders` block up as follows:

<pre><code>
	forwarders {
		68.87.85.98;
		68.87.69.146;
	};
</code></pre>

Restart the `bind` service:

<pre><code>
# /etc/init.d/bind9 restart
</code></pre>

Test the DNS server:

<pre><code>
$ dig @75.146.134.36 mail1.davisonlinehome.name
</code></pre>

Use the domain registrar's tools to register this computer as the domain's primary DNS server:
1. Log in to [http://admin.1and1.com] control panel.
1. Go to the "Manage Domains" area.
1. Create a subdomain that points to this computer's IP:
    1. Select the `davisonlinehome.name` domain.
    1. Go to ''New'', ''Create Subdomain''.
    1. Create a new `ns1` subdomain.
    1. Edit that subdomain's DNS settings to point to `75.146.134.36` as it's primary A record.
1. Edit the `davisonlinehome.name`'s DNS settings as follows:
    * ''Name server'': My name server
    * ''Primary name server'': `ns1.davisonlinehome.name`
    * ''Secondary name server'': 1and1 name server


## Reverse DNS

You will need to contact Comcast business support at 1-800-316-1619 and request that they create a reverse DNS entry for `75.146.134.36` that points to:

* `lewis.davisonlinehome.name`
* `ns1.davisonlinehome.name`

