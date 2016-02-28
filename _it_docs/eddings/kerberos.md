---
title: Eddings Kerberos Server
parent: /it/eddings
layout: it_doc
description: "Describes the steps necessary to make eddings a Kerberos authentication server."
---

This {% collection_doc_link /it/eddings baseurl:true %} sub-guide describes the steps necessary to make the computer a Kerberos authentication server, using [MIT Kerberos](http://web.mit.edu/kerberos/).

Previously, I'd been using `lewis` as a Kerberos server (see <%= wiki_entry_link("LewisSetupKerberosServer") %>). This functionality has now been moved to `eddings`. The Kerberos realm formerly hosted by `lewis`, `DAVISONLINEHOME.NAME`, was decomissioned and replaced with the new `JUSTDAVIS.COM` realm on `eddings`.


## Installing kerberos

[MIT Kerberos](http://web.mit.edu/kerberos/) is more or less the only Linux Kerberos server available. There's also `samba`, but that's also an attempt to replace all of Microsoft's Active Directory, and wasn't very stable last I checked. I've had good success with MIT's Kerberos, myself. Installing it is as simple as:

    $ sudo apt-get install krb5-kdc krb5-admin-server

When prompted, provide the following answers to the configuration helper:

* Default Kerberos version 5 realm: `JUSTDAVIS.COM`


## Creating the JUSTDAVIS.COM Realm

References:

* <https://help.ubuntu.com/community/Kerberos>

To create a new, empty Kerberos database for the realm, run the following command:

    $ sudo krb5_newrealm

When prompted, enter the following:

* KDC database master key: *(Be sure to enter a very secure password, and ensure it's written down somewhere safe.)*

Run the following commands to create the default policies that various principals will be assigned to:

~~~~
$ sudo kadmin.local -r JUSTDAVIS.COM
kadmin.local: add_policy -minlength 12 -minclasses 3 default
kadmin.local: add_policy -minlength 24 -minclasses 4 admins
kadmin.local: add_policy -minlength 24 -minclasses 4 hosts
kadmin.local: add_policy -minlength 24 -minclasses 4 services
kadmin.local: quit
~~~~

Create the `/etc/krb5kdc/kadm5.acl` file to read as follows:

~~~~
# This file Is the access control list for krb5 administration.
# When this file is edited run /etc/init.d/krb5-admin-server restart to activate
# One common way to set up Kerberos administration is to allow any principal
# ending in /admin  is given full administrative rights.
# To enable this, uncomment the following line:

*/admin@JUSTDAVIS.COM    *
~~~~

Restart `krb5-admin-server`:

    $ sudo /etc/init.d/krb5-admin-server restart


### Configuring DNS

Kerberos servers and clients rely heavily on DNS: clients use DNS to locate Kerberos servers and servers may use DNS to verify that clients are who they say that they are. Accordingly, forward and reverse DNS entries are oftentimes needed. The following entries were added to the `justdavis.com` DNS zone on `eddings` to assist clients in locating the Kerberos server:

~~~~
; CNAME Records
; name             ttl    class   rr                name
kerberos                  IN      CNAME             eddings

; TXT Records
; name             ttl    class   rr                name
_kerberos                 IN      TXT               "JUSTDAVIS.COM"

; SRV Records
; name                   ttl    class   rr                name
_kerberos._udp                  IN      SRV               0 0 88 eddings
_kerberos-master._udp           IN      SRV               0 0 88 eddings
_kerberos-adm._tcp              IN      SRV               0 0 749 eddings
_kpasswd._udp                   IN      SRV               0 0 464 eddings
~~~~


### Populating the JUSTDAVIS.COM Realm

Once the realm is setup, it can be populated with the needed "principals": the users and other account objects that will be authenticating against the realm. At a minimum, you should create two principals: one for a regular user under your name, and an "`admin`" variant of that principal. For example:

~~~~
$ sudo kadmin.local -r JUSTDAVIS.COM
kadmin.local: addprinc -policy default karl
kadmin.local: addprinc -policy admins karl/admin
kadmin.local: quit
~~~~

The simplest way to interact with Kerberos is using the following commands:

* `kinit`: Obtain a Kerberos ticket for a specific principal.
* `klist`: List the currently active Kerberos tickets.
* `kdestroy`: Destroy the currently active Kerberos tickets.

For example, the following commands would obtain a ticket for `karl`, display that ticket, and then destroy it:

~~~~
$ kinit -p karl
$ klist
$ kdestroy
~~~~


## Decomissioning the DAVISONLINEHOME.NAME Realm

References:

* <http://www.mail-archive.com/kerberos@mit.edu/msg02079.html>

The `DAVISONLINEHOME.NAME` realm was previously hosted on `lewis`. The realm was decomissioned in favor of the shorter `JUSTDAVIS.COM` realm. The decomissioning process consisted of the following:

1. Making a backup of the old realm.
1. Migrating clients to use the new realm and server.
1. Disabling the old server.


### Backing up the DAVISONLINEHOME.NAME Realm

The database from the old server and realm was dumped to a file, which was then copied to a different server for achival/backup purposes. To backup the database on the old server to a `fullDump-2012-06-27.krb5dump` file, run the following command:

    karl@lewis:$ sudo kdb5_util dump -verbose fullDump-2012-06-27.krb5dump
    karl@lewis:$ sudo chown karl:karl fullDump-2012-06-27.krb5dump

The resulting file will then need to be copied from the old server, via `scp` or some other encrypted protocol to a permanent archival location.


### Migrating Clients from DAVISONLINEHOME.NAME to the JUSTDAVIS.COM Realm

TODO


### Disabling the DAVISONLINEHOME.NAME Realm and Kerberos Services

TODO
