--- 
title: Eddings DNS Server
kind: topic
summary: "Describes the steps necessary to make eddings a DNS server."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make the computer a DNS server, using [bind](http://www.isc.org/software/bind).

Previously, I'd been using two other DNS servers, which have now been consolidated onto `eddings`:

* <%= wiki_entry_link("LewisSetupDnsServer") %>
* <%= wiki_entry_link("TolkienSetupDnsServer") %>

The domains now hosted on `eddings` are:

* `madrivercode.com`, registered with <https://www.gandi.net/>


## Installing bind

[bind](http://www.isc.org/software/bind) seems to be, by far, the most popular DNS server package for Linux. I've had good success with it, myself. Installing `bind` is as simple as:

    $ sudo apt-get install bind9


## Basic Configuration

We want this DNS server to forward on requests for zones it isn't authoritative for to other DNS servers. Edit the `/etc/bind/named.conf.options` file and set the forwarders block up as follows:

~~~~
	forwarders {
		8.8.8.8;  // Google's public DNS server (https://developers.google.com/speed/public-dns/)
		8.8.4.4;  // Google's public DNS server (https://developers.google.com/speed/public-dns/)
	};
~~~~

We need to setup the list of Gandi secondary DNS servers that will be allowed to perform zone transfers. Edit the `/etc/bind/named.conf.local` file and and the following lines to the end:

~~~~
# List other trusted name servers that are allowed to request zone transfers:
acl trusted-servers  {
        217.70.177.40;  // Gandi's ns6.gandi.net secondary name server
};
~~~~

Restart the `bind` service to apply these changes:

    $ sudo /etc/init.d/bind9 restart


## DNS Zones

The sections below cover the creation of the individual zone databases that will be hosted by `bind`.


### DNS Zone: justdavis.com

A new `/etc/bind/db.justdavis.com` file will store the records and some other configuration for the zone. The configuration below was used on 2012-05-12 to create the zone, though this was likely modified directly on the server later:

~~~~
$TTL 1h ; sets the default time-to-live for this zone

; name ttl class rr    name-server                 email-addr  (sn ref ret ex min)
@          IN    SOA   ns1.justdavis.com.          hostmaster.justdavis.com. (
                              2012051200 ; sn = serial number (yyyymmdd##)
                              2d         ; ref = refresh
                              15M        ; ret = update retry
                              4W         ; ex = expiry
                              1h         ; min = minimum
                              )

; Nameserver Records
; name             ttl    class   rr                name
@                         IN      NS                ns1

; IPv4 Address Records
; name             ttl    class   rr                name
@                         IN      A                 174.79.40.37
ns1                       IN      A                 174.79.40.37
mail                      IN      A                 174.79.40.36
eddings                   IN      A                 174.79.40.37
lewis                     IN      A                 174.79.40.34
asimov                    IN      A                 174.79.40.35
piers                     IN      A                 174.79.40.36
feist                     IN      A                 192.168.1.101
kerr                      IN      A                 192.168.1.102
sanderson                 IN      A                 192.168.1.104
kelso                     IN      A                 70.184.78.221

; CNAME Records
; name             ttl    class   rr                name
www                       IN      CNAME             @
smtp                      IN      CNAME             mail
karlanderica              IN      CNAME             kelso

; Mailserver Records
; name             ttl    class   rr     priority   name
@                         IN      MX     10         mail

; TXT Records
; name             ttl    class   rr                name
@                         IN      TXT               "v=spf1 ip4:174.79.40.36 ~all"
~~~~

*Note:* This zone database does not include an $ORIGIN directive, as this would prevent the database from being used as a symlink alias for other domains. Due to this exclusion, `bind` will compute the domain's origin dynamically from the zone names specified in `/etc/bind/named.conf.local`.

Edit the `/etc/bind/named.conf.local` file and and the following lines to the end:

~~~~
# Forward zone definition for justdavis.com:
zone "justdavis.com" {
	type master;
	file "/etc/bind/db.justdavis.com";
	allow-transfer { trusted-servers; };
};
~~~~

Have the `bind` service reload its configuration:

    $ sudo /etc/init.d/bind9 reload

Test the domain by running the following, which should return "`174.79.40.37`":

    $ dig @127.0.0.1 justdavis.com A


### DNS Zone: madrivercode.com

A new `/etc/bind/db.madrivercode.com` file will store the records and some other configuration for the zone. The configuration below was used on 2012-05-12 to create the zone, though this was likely modified directly on the server later:

~~~~
$TTL 1h ; sets the default time-to-live for this zone

; name ttl class rr    name-server                 email-addr  (sn ref ret ex min)
@          IN    SOA   ns1.madrivercode.com.       hostmaster.madrivercode.com. (
                              2012051200 ; sn = serial number (yyyymmdd##)
                              2d         ; ref = refresh
                              15M        ; ret = update retry
                              4W         ; ex = expiry
                              1h         ; min = minimum
                              )

; Nameserver Records
; name             ttl    class   rr                name
@                         IN      NS                ns1

; IPv4 Address Records
; name             ttl    class   rr                name
@                         IN      A                 174.79.40.37
ns1                       IN      A                 174.79.40.37
mail                      IN      A                 174.79.40.36

; CNAME Records
; name             ttl    class   rr                name
www                       IN      CNAME             @
nexus                     IN      CNAME             @
email                     IN      CNAME             mail
webmail                   IN      CNAME             mail
pop                       IN      CNAME             mail
imap                      IN      CNAME             mail
smtp                      IN      CNAME             mail

; Mailserver Records
; name             ttl    class   rr     priority   name
@                         IN      MX     10         mail

; TXT Records
; name             ttl    class   rr                name
@                         IN      TXT               "v=spf1 ip4:174.79.40.36 ~all"
~~~~

*Note:* This zone database does not include an $ORIGIN directive, as this would prevent the database from being used as a symlink alias for other domains. Due to this exclusion, `bind` will compute the domain's origin dynamically from the zone names specified in `/etc/bind/named.conf.local`.

Edit the `/etc/bind/named.conf.local` file and and the following lines to the end:

~~~~
# Forward zone definition for madrivercode.com:
zone "madrivercode.com" {
	type master;
	file "/etc/bind/db.madrivercode.com";
	allow-transfer { trusted-servers; };
};
~~~~

Have the `bind` service reload its configuration:

    $ sudo /etc/init.d/bind9 reload

Test the domain by running the following, which should return "`174.79.40.37`":

    $ dig @127.0.0.1 madrivercode.com A


### DNS Zone: madriverdevelopment.com

This domain is intended to simply be an alias for the `madrivercode.com` domain. To that end, we'll simply create a symbolic link to the zone database for that domain and use it as the database for this one:

    $ sudo ln -s /etc/bind/db.madrivercode.com /etc/bind/db.madriverdevelopment.com

Edit the `/etc/bind/named.conf.local` file and and the following lines to the end:

~~~~
# Forward zone definition for madriverdevelopment.com:
zone "madriverdevelopment.com" {
	type master;
	file "/etc/bind/db.madriverdevelopment.com"; // symlinked copy of db.madrivercode.com
	allow-transfer { trusted-servers; };
};
~~~~

Have the `bind` service reload its configuration:

    $ sudo /etc/init.d/bind9 reload

Test the domain by running the following, which should return "`174.79.40.37`":

    $ dig @127.0.0.1 madriverdevelopment.com A


### DNS Zone: simplepersistence.com

This domain is intended to simply be an alias for the `madrivercode.com` domain. To that end, we'll simply create a symbolic link to the zone database for that domain and use it as the database for this one:

    $ sudo ln -s /etc/bind/db.madrivercode.com /etc/bind/db.simplepersistence.com

Edit the `/etc/bind/named.conf.local` file and and the following lines to the end:

~~~~
# Forward zone definition for simplepersistence.com:
zone "simplepersistence.com" {
	type master;
	file "/etc/bind/db.simplepersistence.com"; // symlinked copy of db.madrivercode.com
	allow-transfer { trusted-servers; };
};
~~~~

Have the `bind` service reload its configuration:

    $ sudo /etc/init.d/bind9 reload

Test the domain by running the following, which should return "`174.79.40.37`":

    $ dig @127.0.0.1 simplepersistence.com A


## Configuring Registrar to Use New Nameserver(s)

Use [Gandi’s](https://www.gandi.net/) tools to register the new nameservers for each of the domains you've configured:

1. Log in to [Gandi's Domain control panel](https://www.gandi.net/admin/domain/).
1. Follow the link for the domain to configure, e.g. `madrivercode.com` to get to the domain management page.
1. Create a glue record for the nameserver:
    1. Follow the **Glue record management** link.
    1. Under **Register a server with the registry**, enter the nameserver's name, e.g. "`ns1`", and IP address, e.g. "`174.79.40.37`", and then click **Validate**.
    1. Go back to the domain management page.
1. Configure the nameservers for the domain:
    1. Follow the **Modify servers** link.
    1. Set DNS1 to "`ns1.`" followed by the domain name, e.g. "`ns1.madrivercode.com`".
    1. Set DNS2 to Gandi's secondary nameserver, using the **Add Gandi's secondary nameserver** link, e.g. "`ns6.gandi.net`".
    1. Go back to the domain management page.

Once the registrar has completed the update, test its configuration by running `dig` against the secondary name server. For example, the following should return "`174.79.40.37`":

    $ dig @ns6.gandi.net madrivercode.com A

These changes should propagate to the wider internet within a day or so. You'll want to test this by running dig against a public DNS server. For example, the following query against Google's public DNS server should return "`174.79.40.37`":

    $ dig @8.8.8.8 madrivercode.com A


## Reverse DNS

You will need to contact Cox business support and request that they create reverse DNS entries for all '`A`' name records you've created, especially those used for email and DNS servers.

