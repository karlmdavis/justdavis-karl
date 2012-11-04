--- 
title: Eddings LDAP Server
kind: topic
summary: "Describes the steps necessary to make eddings an LDAP directory server."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make the computer an LDAP directory server, using [Open LDAP](http://www.openldap.org/).

Previously, I'd been using `lewis` as an LDAP server (see <%= wiki_entry_link("LewisSetupLdapServer") %>). This functionality has now been moved to `eddings`. The LDAP domain formerly hosted by `lewis`, `dc=davisonlinehome,dc=name`, was decomissioned and replaced with the new `dc=justdavis,dc=com` domain on `eddings`.


## Installing LDAP

References:

* <https://help.ubuntu.com/community/OpenLDAPServer>
* <https://help.ubuntu.com/10.04/serverguide/openldap-server.html>

[Open LDAP](http://www.openldap.org/) is the most popular Linux LDAP server available. I've found it to be rough around the edges: much of the documentation for it is often out-of-date. Nonetheless, it still seems to currently be the best option. In the future, it might be worth taking a look at [389 directory server](http://directory.fedoraproject.org/wiki/Main_Page) as an alternative, but Ubuntu packages for it were not available in 10.04 at the time this guide was written.

OpenLDAP should be installed as follows:

    $ sudo apt-get install slapd ldap-utils

The latest releases of the `slapd` Ubuntu package will not prompt users to answer any questions during install. Accordingly, no `admin` LDAP entry is created; users will have to do this themselves (see below). Until this entry has been created, the `EXTERNAL` authentication mechanism must be used. Effectively, this means that only `root` on the LDAP server's host machine can access it.

To test the new `slapd` installation and see a list of the entries created, run the following command:

    $ sudo ldapsearch -Y EXTERNAL -H ldapi:/// -b cn=config

Perusing the output, you should notice that the entries all appear to be related to the configuration of OpenLDAP itself. This is because, in its latest releases, OpenLDAP no longer stores its configuration in `slapd.conf`: the configuration is instead represented by LDAP entries and stored across the files in `/etc/ldap/slapd.d/`.


## Creating the dc=justdavis,dc=com Directory

References:

* <http://www.openldap.org/doc/admin24/>
* <http://www.openldap.org/faq/data/cache/944.html>

By default, OpenLDAP will not have a typical users/addresses directory at all. In fact, in releases prior to Ubuntu 11.04, it won't even have the schemas for such a directory installed. First thing to do is add those schemas, as follows:

~~~~
$ sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/cosine.ldif
$ sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/nis.ldif
$ sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/inetorgperson.ldif
~~~~

Next thing that needs to be done is to create a "backend" to host the new directory that will be created. This is basically just the configuration that tells OpenLDAP where to store the new directory and how to control access to it. Create a new `~/ldap-entries/backend.justdavis.com.ldif` file with the following contents (be sure that the password in `olcRootPW` is complex, unique, and also recorded in a safe place):

~~~~
# Load dynamic backend modules
dn: cn=module,cn=config
objectClass: olcModuleList
cn: module
olcModulepath: /usr/lib/ldap
olcModuleload: back_hdb

# Database settings
dn: olcDatabase=hdb,cn=config
objectClass: olcDatabaseConfig
objectClass: olcHdbConfig
olcDatabase: {1}hdb
olcSuffix: dc=justdavis,dc=com
olcDbDirectory: /var/lib/ldap
olcRootDN: cn=admin,dc=justdavis,dc=com
olcRootPW: secret
olcDbConfig: set_cachesize 0 2097152 0
olcDbConfig: set_lk_max_objects 1500
olcDbConfig: set_lk_max_locks 1500
olcDbConfig: set_lk_max_lockers 1500
olcDbIndex: objectClass eq
olcLastMod: TRUE
olcDbCheckpoint: 512 30
olcAccess: to attrs=userPassword by dn="cn=admin,dc=justdavis,dc=com" write by anonymous auth by self write by * none
olcAccess: to attrs=shadowLastChange by self write by * read
olcAccess: to dn.base="" by * read
olcAccess: to * by dn="cn=admin,dc=justdavis,dc=com" write by * read
~~~~

Add/load the entries in this file, as follows:

    $ sudo ldapadd -Y EXTERNAL -H ldapi:/// -f ~/ldap-entries/backend.justdavis.com.ldif

At this point, an empty `dc=justdavis,dc=com` directory exists and can be populated. We have also specified that only the `cn=admin,dc=justdavis,dc=com` user has permissions to modify this directory. We can test this user's read access, as follows:

    $ ldapsearch -x -D cn=admin,dc=justdavis,dc=com -W -H ldapi:/// -b dc=justdavis,dc=com

We now need to populate the new directory/domain. The end goal is to have a directory strutured as follows:

* `dc=justdavis,dc=com`
    * `ou=systemAccounts,dc=justdavis,dc=com`: This OU will store the "_admin" variants of any user accounts that need them, e.g. `karl_admin`.
    * `ou=serviceAccounts,dc=justdavis,dc=com`: This OU will store user entries for service-only users, e.g. `eddings_nexus`, which will be used by the Nexus service on `eddings` to perform LDAP queries.
    * `ou=groups,dc=justdavis,dc=com`: This OU will store all of the various `posixGroup` entries.
    * `ou=people,dc=justdavis,dc=com`: This OU will store all of the various `posixAccount` entries.

Much of this structure was copied from the `dc=davisonlinehome,dc=name` directory before it was decommissioned. The old directory's entries were discovered by running the following command on `lewis`:

    $ sudo ldapsearch -Y EXTERNAL -H ldapi:/// -b dc=davisonlinehome,dc=name

To add these new OUs, first create a new `~/ldap-entries/ous.justdavis.com.ldif` file with the following contents:

~~~~
# Create top-level object in domain.
dn: dc=justdavis,dc=com
objectClass: top
objectClass: dcObject
objectclass: organization
dc: justdavis
o: Davis Family
description: The top-level LDAP domain for justdavis.com.

# Create an OU.
dn: ou=people,dc=justdavis,dc=com
objectClass: organizationalUnit
ou: people
description: This OU will store the "_admin" variants of any user accounts that need them, e.g. `karl_admin`.

# Create an OU.
dn: ou=groups,dc=justdavis,dc=com
objectClass: organizationalUnit
ou: groups
description: This OU will store user entries for service-only users, e.g. `eddings_nexus`, which will be used by the Nexus service on `eddings` to perform LDAP queries.

# Create an OU.
dn: ou=systemAccounts,dc=justdavis,dc=com
objectClass: organizationalUnit
ou: systemAccounts
description: This OU will store all of the various `posixGroup` entries.

# Create an OU.
dn: ou=serviceAccounts,dc=justdavis,dc=com
objectClass: organizationalUnit
ou: groups
description: This OU will store all of the various `posixAccount` entries.
~~~~

Add/load the entries in this file, as follows:

    $ ldapadd -x -D cn=admin,dc=justdavis,dc=com -W -H ldapi:/// -f ~/ldap-entries/ous.justdavis.com.ldif


## Enabling SSL Encryption

References:

* <http://serverfault.com/questions/18964/add-a-custom-certificate-authority-to-ubuntu>
* <https://help.ubuntu.com/community/GnuTLS#Being_a_Certificate_Authority>

By default, LDAP clients and servers do not encrypt their communications. This is perfectly fine if all that's being sent back and forth are queries and address book data. However, we'd like to use LDAP simple binds as an authentication service for other applications that support it (and don't natively support Kerberos). Without SSL encryption, the user names and passwords for those bind requests will be sent in plaintext, which is a giant security risk. Accordingly, we'll need to create/obtain an SSL certificate and configure the OpenLDAP server to use it.

When obtaining an SSL certificate, there are two options: self-signed certificates or commercial certificates. The primary advantages of using a self-signed certificate for the LDAP server are the following:

* It's less hassle, provided the root authority for the certificate is trusted by the client machines.
* It makes using the LDAP server with other applications simpler: many applications don't trust self-signed certificates by default.

Nonetheless, I opted to use a self-signed certificate as those advantages don't outweigh the disadvantages:

* Commercial certificates cost anywhere from $20 per year, on up. Most of the better certs (those with widely supported trust chains) are in the $50 per year range.
* Commercial certificates have a very fixed expiration time: generally, never more than three years.

The second consideration was a major one for me, as I've learned such expirations occur at the most inconvenient times possible. I'd prefer to deal with the extra hassle of self-signed certs in exchange for a flexible expiration time.


### Creating the Certificate Authority

References:

* <https://help.ubuntu.com/community/GnuTLS#Being_a_Certificate_Authority>
* <http://ubuntuforums.org/showthread.php?t=1241136>
* <http://www.gnu.org/software/gnutls/manual/html_node/certtool-Invocation.html#certtool-Invocation>

First, install the `gnutls-bin` package, which provides the SSL utilities that will be needed:

    $ sudo apt-get install gnutls-bin

Then, generate a private key for the certificate authority (CA), secure it, and store it in the server's central `/etc/ssl/private/` directory. This command relies on obtaining enough entropy (randomness) to generate a suitably random key, and can thus take up to 30 minutes. It can be done as follows:

    $ sudo certtool --generate-privkey --outfile /etc/ssl/private/ca.justdavis.com.key
    $ sudo chmod u=rw,g=,o= /etc/ssl/private/ca.justdavis.com.key
    $ sudo chown root:root /etc/ssl/private/ca.justdavis.com.key

Please note: unlike the other files in the same directory, `/etc/ssl/private/ca.justdavis.com.key` will be owned by `root:root`, not `root:ssl-cert`. This is to protect the key, as it should never be used for anything other than signing new certificates.

Create the following configuration template file, and save it as `/etc/ssl/private/ca.justdavis.com.cfg`:

~~~~
# X.509 Certificate options
#
# DN options

# The organization of the subject.
organization = "Davis Family"

# The organizational unit of the subject.
#unit = "sleeping dept."

# The locality of the subject.
# locality =

# The state of the certificate owner.
state = "Arizona"

# The country of the subject. Two letter code.
country = US

# The common name of the certificate owner.
cn = "Karl M. Davis"

# The serial number of the certificate. Should be incremented each time a new certificate is generated.
serial = 001

# In how many days, counting from today, this certificate will expire.
expiration_days = 3650

# X.509 v3 extensions

# An URL that has CRLs (certificate revocation lists)
# available. Needed in CA certificates.
crl_dist_points = "http://www.justdavis.com/crl/"

# Whether this is a CA certificate or not
ca

### Other predefined key purpose OIDs

# Whether this key will be used to sign other certificates.
cert_signing_key

# Whether this key will be used to sign CRLs.
crl_signing_key

### end of key purpose OIDs

# When generating a certificate from a certificate
# request, then honor the extensions stored in the request
# and store them in the real certificate.
honor_crq_extensions
~~~~

Next, use the private key and the configuration to generate the certificate for the CA. This can be done as follows:

    $ sudo certtool --generate-self-signed --load-privkey /etc/ssl/private/ca.justdavis.com.key --template /etc/ssl/private/ca.justdavis.com.cfg --outfile ca.justdavis.com.crt
    $ sudo chmod u=rw,g=r,o=r ca.justdavis.com.crt
    $ sudo chown root:root ca.justdavis.com.crt

The `ca.justdavis.com.crt` file that was generated by the previous command represents the new certificate authority's public key. This is the key that should be distributed to client computers and applications. Because it is a CA certificate, it can be distributed in lieu of all the certificates generated from it: the clients will use the root CA to build a "chain of trust" for the individual certificates for each application or server.


### Distributing the CA Certificate

Many applications, such as LDAP clients, will make use of the operating system's certificate store. Adding the CA's public certificate to that operating system store will allow those applications to trust other certificates generated by that CA.


#### Ubuntu

References:

* <http://blog.sandipb.net/2009/08/08/adding-new-ca-certificates-in-ubuntu-jaunty/>

To add the CA certificate to the operating system store on Ubuntu, first copy the certificate to that computer via `scp` or some other mechanism. Then, add it to the local certificate store and update the master store database, by running the following commands:

    $ sudo cp ca.justdavis.com.crt /usr/local/share/ca-certificates/
    $ sudo update-ca-certificates


### Creating the LDAP Service Certificate

The CA certificate created earlier should not (and cannot, due to the options selected in the configuration for it) be used to encrypt or sign communications for individual services, e.g. LDAP. Instead, we'll use the CA to create a "child" certificate for each specific service and/or server.

First, create a private key for the LDAP server, secure it, and store it in the server's central `/etc/ssl/private/` directory:

    $ sudo mkdir /etc/ldap/ssl/
    $ sudo chmod u=rwx,g=rx,o= /etc/ldap/ssl/
    $ sudo chown root:openldap /etc/ldap/ssl/
    $ sudo certtool --generate-privkey --outfile /etc/ldap/ssl/ldap.justdavis.com.key
    $ sudo chmod u=r,g=r,o= /etc/ldap/ssl/ldap.justdavis.com.key
    $ sudo chown root:openldap /etc/ldap/ssl/ldap.justdavis.com.key

When using a commercial CA, a "certificate signing request" is needed. However, when using a local CA, this step can be skipped. Instead, we'll directly use our CA's private key, public certificate, and the private key for the service to generate the public certificate for the service. A configuration template file for the service's public certificate should be created as `/etc/ldap/ssl/ldap.justdavis.com.cfg` with the following contents:

~~~~
# X.509 Certificate options
#
# DN options

# The organization of the subject.
organization = "Davis Family"

# The organizational unit of the subject.
#unit = "sleeping dept."

# The state of the certificate owner.
state = "Arizona"

# The country of the subject. Two letter code.
country = US

# The common name of the certificate owner.
cn = "Karl M. Davis"

# The serial number of the certificate. Should be incremented each time a new certificate is generated.
serial = 001

# In how many days, counting from today, this certificate will expire.
expiration_days = 3650

# X.509 v3 extensions

# DNS name(s) of the server
dns_name = "eddings.justdavis.com"
dns_name = "ldap.justdavis.com"
#dns_name = "server_alias.example.com"

# (Optional) Server IP address
#ip_address = "192.168.1.1"

# Whether this certificate will be used for a TLS client
#tls_www_client

# Whether this certificate will be used for a TLS server
tls_www_server

# Whether this certificate will be used to encrypt data (needed
# in TLS RSA ciphersuites). Note that it is preferred to use different
# keys for encryption and signing.
encryption_key
~~~~

Generate the public certificate for the service, placing it into the `/etc/ldap/ssl/` directory:

    $ sudo certtool --generate-certificate --load-privkey /etc/ldap/ssl/ldap.justdavis.com.key --load-ca-certificate /usr/local/share/ca-certificates/ca.justdavis.com.crt --load-ca-privkey /etc/ssl/private/ca.justdavis.com.key --template /etc/ldap/ssl/ldap.justdavis.com.cfg --outfile /etc/ldap/ssl/ldap.justdavis.com.crt
    $ sudo chmod u=r,g=r,o= /etc/ldap/ssl/ldap.justdavis.com.crt
    $ sudo chown root:openldap /etc/ldap/ssl/ldap.justdavis.com.crt


#### Troubleshooting: Location of End-Chain Certificates

References:

* <https://help.ubuntu.com/community/SecuringOpenLDAPConnections#Test_SSL_Connection-1>

Initially, I put this certificate into the system-wide `/usr/local/share/ca-certificates/` directory. Apparently, this is a bad idea. It seems that if the end-chain certificate (e.g. `ldap.justdavis.com.crt`) and the CA certificate (e.g. `ca.justdavis.com.crt`) are both included in the master/compiled certificates file (`/etc/ssl/certs/ca-certificates.crt`), that GnuTLS will be unable to validate the end-chain certificate.

After initially trying this and setting `/etc/ldap/ldap.conf`'s `TLS_CACERT` option to `/etc/ssl/certs/ca-certificates.crt`, I was unable to get `ldapsearch` or `` to connect to the OpenLDAP server without errors.

Specifically, `ldapsearch` was returning the following output:

~~~~
$ ldapsearch -x -D cn=admin,dc=justdavis,dc=com -W -H ldaps://ldap.justdavis.com -b dc=davisonlinehome,dc=name -d5
ldap_url_parse_ext(ldaps://ldap.justdavis.com)
ldap_create
ldap_url_parse_ext(ldaps://ldap.justdavis.com:636/??base)
Enter LDAP Password: 
ldap_sasl_bind
ldap_send_initial_request
ldap_new_connection 1 1 0
ldap_int_open_connection
ldap_connect_to_host: TCP ldap.justdavis.com:636
ldap_new_socket: 3
ldap_prepare_socket: 3
ldap_connect_to_host: Trying 174.79.40.37:636
ldap_pvt_connect: fd: 3 tm: -1 async: 0
TLS: peer cert untrusted or revoked (0x2)
TLS: can't connect: (unknown error code).
ldap_err2string
ldap_sasl_bind(SIMPLE): Can't contact LDAP server (-1)
~~~~

In addition, `gnutls-cli` was returning the following output (trimmed):

~~~~
$ gnutls-cli --print-cert -p 636 --x509cafile /etc/ssl/certs/ca-certificates.crt ldap.justdavis.com
Processed 143 CA certificate(s).
Resolving 'ldap.justdavis.com'...
Connecting to '174.79.40.37:636'...
- Certificate type: X.509
 - Got a certificate list of 1 certificates.
 - Certificate[0] info:
  - subject `C=US,O=Davis Family,ST=Arizona,CN=Karl M. Davis', issuer `C=US,O=Davis Family,ST=Arizona,CN=Karl M. Davis', RSA key 2048 bits, signed using RSA-SHA, activated `2012-07-06 18:21:44 UTC', expires `2022-07-04 18:21:44 UTC', SHA-1 fingerprint `283c056efa1b1ca2504e7c405494e429ff749e0f'

-----BEGIN CERTIFICATE-----
MIID1zCCAsGgAwIBAgIBATALBgkqhkiG9w0BAQUwTjELMAkGA1UEBhMCVVMxFTAT
...
gB466NbMEeXCV6foO3AApTF4L+/FZF8myA3w
-----END CERTIFICATE-----

- The hostname in the certificate matches 'ldap.justdavis.com'.
- Peer's certificate is NOT trusted
- Version: TLS1.1
- Key Exchange: RSA
- Cipher: AES-128-CBC
- MAC: SHA1
- Compression: NULL
*** Verifying server certificate failed...
~~~~

Oddly, `openssl s_client` was perfectly happy to accept the certificate. It was returning the following output (trimmed):

~~~~
$ openssl s_client -CAfile /etc/ssl/certs/ca-certificates.crt -connect ldap.justdavis.com:636 -showcerts
CONNECTED(00000003)
depth=1 /C=US/O=Davis Family/ST=Arizona/CN=Karl M. Davis
verify return:1
depth=0 /C=US/O=Davis Family/ST=Arizona/CN=Karl M. Davis
verify return:1
---
Certificate chain
 0 s:/C=US/O=Davis Family/ST=Arizona/CN=Karl M. Davis
   i:/C=US/O=Davis Family/ST=Arizona/CN=Karl M. Davis
-----BEGIN CERTIFICATE-----
MIID1zCCAsGgAwIBAgIBATALBgkqhkiG9w0BAQUwTjELMAkGA1UEBhMCVVMxFTAT
...
gB466NbMEeXCV6foO3AApTF4L+/FZF8myA3w
-----END CERTIFICATE-----
---
Server certificate
subject=/C=US/O=Davis Family/ST=Arizona/CN=Karl M. Davis
issuer=/C=US/O=Davis Family/ST=Arizona/CN=Karl M. Davis
---
No client certificate CA names sent
---
SSL handshake has read 1229 bytes and written 447 bytes
---
New, TLSv1/SSLv3, Cipher is AES256-SHA
Server public key is 2048 bit
Secure Renegotiation IS NOT supported
Compression: NONE
Expansion: NONE
SSL-Session:
    Protocol  : TLSv1
    Cipher    : AES256-SHA
    Session-ID: B9293B090DDC0FCF6EC417636DF5AC36E430C683E4DE7CB498B42E756198C061
    Session-ID-ctx: 
    Master-Key: DAB2E51424B2C5ACA76C13EB7218E9835F4ABC82D80F62FAD7F13E2A6703C9A9E233981F8C7D057A0266183FD087F995
    Key-Arg   : None
    Start Time: 1341612250
    Timeout   : 300 (sec)
    Verify return code: 0 (ok)
---
DONE
~~~~


### Configuring OpenLDAP to Use the SSL Certificate

Now that a CA certifcate, service certificate, service key are all available and installed, OpenLDAP can be configured to use them.

Create a new `~/ldap-entries/ssl.justdavis.com.ldif` file that will be used to configure SSL:

~~~~
dn: cn=config
add: olcTLSCACertificateFile
olcTLSCACertificateFile: /usr/local/share/ca-certificates/ca.justdavis.com.crt
-
add: olcTLSCertificateFile
olcTLSCertificateFile: /etc/ldap/ssl/ldap.justdavis.com.crt
-
add: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/ldap/ssl/ldap.justdavis.com.key
~~~~

Apply the changes in this file, as follows (the `-Y EXTERNAL` mechanism must be used here as `cn=admin,dc=justdavis,dc=com` does not have permission to modify the `cn=config` entry):

    $ sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f ~/ldap-entries/ssl.justdavis.com.ldif

Give the OpenLDAP service permission to read the service certificate's private key:

    $ sudo adduser openldap ssl-cert

Modify the AppArmor profile for OpenLDAP to give it access to the files in `/usr/local/share/ca-certificates/` by editing the `/etc/apparmor.d/usr.sbin.slapd` file to add the following entry:

~~~~
  # Add read access to the local certs directory:
  /usr/local/share/ca-certificates/* r,
~~~~

**Post-12.04 Upgrade Note:** If this server is running Ubuntu 12.04 or later, it is instead recommended that the above entry be added to the `/etc/apparmor.d/local/usr.sbin.slapd` file. This will prevent conflicts during package manager upgrades.

Apply the change by reloading the AppArmor profiles with the following command:

    $ sudo /etc/init.d/apparmor reload

Enable the SSL transport mechanism (along with the unencrypted TCP transport and the local IPC transport) by editing the `SLAPD_SERVICES` setting in `/etc/default/slapd`, as follows:

~~~~
SLAPD_SERVICES="ldap:/// ldapi:/// ldaps:///"
~~~~

By default, the OpenLDAP client tools do not trust any certificates. Accordingly, in order to connect, we'll have to configure them to trust all of the CA certificate's installed on the Ubuntu system. Running Ubuntu's `update-ca-certificates` command will actually concatenate all of these certificates into one large `/etc/ssl/certs/ca-certificates.crt` file. To make this configuration change, set the following option in the `/etc/ldap/ldap.conf` file:

~~~~
TLS_CACERT	/etc/ssl/certs/ca-certificates.crt
~~~~

Finally, restart the OpenLDAP service and run a test query over SSL:

    $ sudo /etc/init.d/slapd restart
    $ ldapsearch -x -D cn=admin,dc=justdavis,dc=com -W -H ldaps://ldap.justdavis.com -b dc=davisonlinehome,dc=name


#### Troubleshooting: TLS_CACERTDIR Option

Per [Bug #242313](https://bugs.launchpad.net/ubuntu/+source/openldap/+bug/242313), it seems that GnuTLS does not support this configuration option.


## Configuring Kerberos Authentication

This section assumes that a Kerberos server has been setup for the `JUSTDAVIS.COM` realm as described in <%= topic_link("/it/davis/servers/eddings/kerberos/") %>.

Authentication to OpenLDAP with Kerberos is a complicated subject. There are two types of authentication to consider:

1. Authentication when a Kerberos ticket has already been obtained. This can cover most usage of `ldapsearch`, `ldapadd`, etc., as well as usage with `libnss-ldapd`.
1. Authentication via a "simple bind" when a Kerberos ticket is unavailable. This use case is most commly found when using an LDAP operation to authenticate users of other services. Many services support using an external LDAP server as a substitute for built-in users.

For the purposes of this guide, we want to support both use cases.


### When a Ticket is Available (Using SASL via GSSAPI)

References:

* <http://www.openldap.org/doc/admin24/sasl.html#GSSAPI>
* <https://help.ubuntu.com/community/OpenLDAPServer#Kerberos_Authentication>

When accessing the LDAP server on a Linux command line, e.g. via `ldapsearch`, we can specify what form of authentication should be used. This allows the use of Kerberos authentication with the LDAP server, provided the LDAP server is configured correctly. OpenLDAP supports this by allowing the following two technologies to be combined:

* [GSSAPI](http://en.wikipedia.org/wiki/Generic_Security_Services_Application_Program_Interface): a standardized wrapper around Kerberos authentication. This makes use of already-acquired Kerberos tokens.
* [SASL Library](http://asg.web.cmu.edu/sasl/), a security abstraction library that can support GSSAPI and other protocols. 

The `libsasl2-modules-gssapi-mit` package is required for this support. Install it by running the following command:

    $ sudo apt-get install libsasl2-modules-gssapi-mit

The LDAP server will also need a Kerberos host key and a service key with a principal for the LDAP service within the realm for the host on which the service runs. Create a `host` principal for the LDAP server and export it to the default local keytab:

~~~~
$ sudo kadmin.local
kadmin.local:  addprinc -policy hosts -randkey host/eddings.justdavis.com
kadmin.local:  ktadd host/eddings.justdavis.com
kadmin.local:  quit
~~~~

Create an `ldap` principal for the LDAP server and export it to a separate keytab, which will keep the `host` keytab from becoming compromised if the OpenLDAP server is:

~~~~
$ sudo kadmin.local
kadmin:  addprinc -policy services -randkey ldap/eddings.justdavis.com
kadmin:  ktadd -k /etc/ldap/ldap.keytab ldap/eddings.justdavis.com
kadmin:  quit
$ sudo chown openldap /etc/ldap/ldap.keytab
~~~~

Set the `KRB5_KTNAME` variable in the `/etc/default/slapd` configuration file as follows:

    export KRB5_KTNAME=/etc/ldap/ldap.keytab

Restart OpenLDAP to apply the previous change:

    $ sudo /etc/init.d/slapd restart

Create a new `~/ldap-entries/sasl.justdavis.com.ldif` file that will be used to configure SASL:

~~~~
dn: cn=config
changetype: modify
# The FQDN of the Kerberos KDC.
modify: olcSaslHost
olcSaslHost: kerberos.justdavis.com
-
# The Kerberos realm name.
add: olcSaslRealm
olcSaslRealm: JUSTDAVIS.COM
-
# Disallow insecure authentication mechanisms such as plain passwords.
add: olcSaslSecProps
olcSaslSecProps: noplain,noanonymous,minssf=56
-
# By default, the DN of an authorized Kerberos client takes the form uid=<Kerberos principal name>,cn=<Kerberos Realm>,cn=GSSAPI,cn=auth
# Adjust the following mappings to match the local configuration as necessary.
add: olcAuthzRegexp
olcAuthzRegexp: {0}"uid=([^/]*),cn=justdavis.com,cn=GSSAPI,cn=auth" "uid=$1,ou=people,dc=justdavis,dc=com"
# Administrative user map, assumes existence of cn=admin,cn=config
olcAuthzRegexp: {1}"uid=karl/admin,cn=justdavis.com,cn=gssapi,cn=auth" "cn=admin,cn=config"
~~~~

**Troubleshooting Note:** [OpenLDAPServer: Kerberos Authentication](https://help.ubuntu.com/community/OpenLDAPServer#Kerberos_Authentication) recommends also using the `noactive` flag in `olcSaslSecProps`. However, doing so seems to prevent the use of the `-Y EXTERNAL` mechanism, which seems to be the only way to view or modify the root `cn=config` entry. Accordingly, I've left this flag out.

Apply the changes in this file, as follows (the `-Y EXTERNAL` mechanism must be used here as `cn=admin,dc=justdavis,dc=com` does not have permission to modify the `cn=config` entry):

    $ sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f ~/ldap-entries/sasl.justdavis.com.ldif

**Troubleshooting Note:** If something is wrong and you find yourself unable to connect to the LDAP server after applying these changes, you will have to: stop the LDAP server, edit the `/etc/ldap/slapd.d/cn=config.ldif` file manually to revert these changes, start the server, fix the problem, and then reapply these changes.

To test this configuration, we'll first obtain a Kerberos ticket for the `karl/admin@JUSTDAVIS.COM` principal, which should be mapped by the second `olcAuthzRegexp` mapping we created above to the `cn=admin,cn=config` user. This test can be performed by running the following commands:

    $ kinit karl/admin
    $ ldapsearch -Y GSSAPI -H ldapi:/// -b dc=justdavis,dc=com

Another test should also be run, combining `-Y GSSAPI` and SSL. This test should expose any DNS issues:

    $ ldapsearch -Y GSSAPI -H ldaps://ldap.justdavis.com -b dc=justdavis,dc=com


### When Authenticating via a Simple Bind (Using SASL via saslauthd)

References:

* <http://www.openldap.org/faq/data/cache/944.html>
* <http://www.openldap.org/lists/openldap-software/200602/msg00278.html>
* <http://www.opinsys.fi/en/openldap-authentication-with-kerberos-backend-using-sasl>
* <http://lists.andrew.cmu.edu/pipermail/cyrus-sasl/2009-July/001768.html>
* <http://www.openldap.org/lists/openldap-technical/201008/msg00038.html>

While the previous section's configuration will allow OpenLDAP to make use of already-obtained Kerberos tickets, there are a number of services that do not support Kerberos authentication, but do support LDAP authentication. In those cases, we can use our OpenLDAP server as a kind of Kerberos proxy, or wrapper. To do this, we'll have to configure OpenLDAP to "call out" to Kerberos via [saslauthd](http://manpages.ubuntu.com/manpages/oneiric/man8/saslauthd.8.html).

First, install the SASL application/daemon (rather than just the libraries) by running the following command:

    $ sudo apt-get install sasl2-bin

Then, edit the following entries in the `/etc/default/saslauthd` file:

* `START=yes`
* `MECHANISMS="kerberos5"`

Then, start the `saslauthd` daemon:

    $ sudo /etc/init.d/saslauthd start

Then, create the SASL configuration for OpenLDAP's `slapd` by creating the `/etc/ldap/sasl2/slapd.conf` file and ensuring it contains the following:

~~~~
pwcheck_method: saslauthd
~~~~

Finally, restart the OpenLDAP server to apply the previous change and test everything out using `ldapsearch`:

    $ sudo /etc/init.d/slapd restart
    $ ldapsearch -x -D uid=karl,ou=people,dc=justdavis,dc=com -W -H ldapi:/// -b dc=justdavis,dc=com

(Please note: the above `ldapsearch` command makes use of the `uid=karl,ou=people,dc=justdavis,dc=com` user account and will not succeed unless that account has been created in the LDAP directory. The creation of this account is described below.)


## Creating the dc=justdavis,dc=com User Entries

As we'll be using our LDAP directory in combination with a Kerberos server to provide a login server for Linux clients, we'll need to do the following for each user:

* Ensure that they have a user entry of `objectClass: posixAccount`.
* Set the `userPassword` attribute to point to the Kerberos principal associated with the user. This is required for the Kerberos-via-LDAP-simple-bind authentication described above).
* Ensure that they have a corresponding group entry of `objectClass: posixGroup` (it's a Debian convention to ensure that every user account has a corresponding group account).

For maintenance purposes, it's recommended to create a separate `.ldif` file for each user-group pair and keep it around. As an example, the following was created as `~/ldap-entries/karl.justdavis.com.ldif` to create a user and group for the `karl` user:

~~~~
dn: uid=karl,ou=people,dc=justdavis,dc=com
objectClass: inetOrgPerson
objectClass: posixAccount
uid: karl
sn: Davis
givenName: Karl
cn: Karl M. Davis
displayName: Karl M. Davis
initials: KMD
uidNumber: 10000
gidNumber: 10000
userPassword: {SASL}karl@JUSTDAVIS.COM
loginShell: /bin/bash
homeDirectory: /home/karl
mail: karl@justdavis.com
postalAddress: 5521 East Kelso Street
l: Tucson
st: Arizona
postalCode: 85712
mobile: 1-520-344-0554

dn: cn=karl,ou=groups,dc=justdavis,dc=com
objectClass: posixGroup
cn: karl
gidNumber: 10000
~~~~

