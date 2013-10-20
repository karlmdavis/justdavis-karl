--- 
title: Piers Zimbra Email Server
kind: topic
summary: "Describes the steps necessary to configure piers as an email server using Zimbra."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/piers/") %> sub-guide describes the steps necessary to configure `piers` as an email server using [Zimbra Collaboration Server - Open Source Edition](http://www.zimbra.com/products/zimbra-open-source.html).

As `piers` is a rebuild of an existing email server with the same name (unfortunately, no documentation is available for the "old" `piers`), this guide will cover the initial setup of a Zimbra install, as well as the migration of accounts from one Zimbra server to another.


## Installing Zimbra 7.0 (64-bit)


### Temporarily Change Domain Name

The Zimbra migration to be performed from the old to new `piers` requires that Zimbra on the new `piers` be configured exactly the same way as the old one was. Accordingly, the default hostname and domain name for `piers` need to be temporarily changed from `piers.justdavis.com` to `piers.davisonlinehome.name`.

The first two entries in `/etc/hosts` should be changed to read as follows:

~~~~
127.0.0.1       localhost
127.0.1.1       piers.davisonlinehome.name   piers
~~~~

The hostname configuration can be tested with the `hostname` command. The first command should return the unqualified name and the second command should return the fully qualified name:

    $ hostname
    $ hostname -f


### Installation

References:

* [Quick Start Installation Guide](http://www.zimbra.com/docs/ne/8.0.0/single_server_install/)

The type of migration that needs to be used (a direct data copy) requires that both the old and new `piers` be running the same version of Zimbra (though they can be running on a different OS). This complicates things as the old `piers` is a 32-bit VM, but the latest release of Zimbra (8.0) only supports 64-bit. Accordingly, the new `piers` will have to be initially setup using the latest 64-bit 7.0 release, and then upgraded to 8.0 after the data migration is performed.

Please note that Zimbra *does* have a Migration Wizard that supports moving accounts and data between different releases. However, this isn't a complete migration: it only moves basic account details and the data can be copied via IMAP. It will leave shares, preferences, and other data un-migrated. Because of these limitations a direct data migration was chosen, instead.

Download the latest Ubuntu 64-bit Zimbra 7.0 release from [Zimbra Open Source Downloads](http://www.zimbra.com/downloads/os-downloads.html). On 2012-10-14, that was 7.2.1. Download the release via `wget`, e.g.:

    $ wget http://files2.zimbra.com/downloads/7.2.1_GA/zcs-7.2.1_GA_2790.UBUNTU10_64.20120815212201.tgz

Note: The Zimbra installation guide (and installer) both instruct users to first configure `A` and `MX` records for the mail server. However, in the case of `piers`, those records will not be modified until later. Instead, `piers` will be setup as a new, stand-alone mail server that does not actually receive any mail. Once it's configured, firewall rules will be setup to block the old `piers` from receiving any further mail, and the accounts will be migrated off of it to the new `piers`. Only after that migration is complete will DNS records be updated to point to the new `piers`. This process will prevent mail from being lost or not migrated.

Install the prerequisites needed by Zimbra:

    $ sudo apt-get install libexpat1 libperl5.10 sysstat sqlite3

Extract the installation bundle and start the installer:

    $ tar -xzf zcs-7.2.1_GA_2790.UBUNTU10_64.20120815212201.tgz
    $ cd zcs-7.2.1_GA_2790.UBUNTU10_64.20120815212201
    $ sudo ./install.sh

Proceed through the installation, as follows:

1. *Do you agree with the terms of the software license agreement?* **Y**
1. *Install zimbra-ldap* **Y**
1. *Install zimbra-logger* **Y**
1. *Install zimbra-mta* **Y**
1. *Install zimbra-snmp* **Y**
1. *Install zimbra-store* **Y**
1. *Install zimbra-apache* **Y**
1. *Install zimbra-spell* **Y**
1. *Install zimbra-memcached* **Y**
1. *Install zimbra-proxy* **N**
1. *The system will be modified.  Continue?* **Y**
1. *DNS ERROR resolving MX for piers.davisonlinehome.name. Change domain name?* **Yes**
1. *Create domain:* **`davisonlinehome.name`**
    * Should be the same as on the old server. The value there can be found by running `zmprov getConfig zimbraDefaultDomainName` as the `zimbra` user.
1. *DNS ERROR - none of the MX records for davisonlinehome.name resolve to this host. Re-Enter domain name?* **No**
1. Go through the menu and configure the following settings to match those on the old server. The command to run on the old server to find the old value is provided for each of these (all of these need to be run as the `zimbra` user).
    * *1 > 1, Hostname*: `zmlocalconfig | grep ldap_host`
    * *1 > 4, LDAP Admin password*: `zmlocalconfig --show | grep zimbra_ldap_password`
    * *2 > 4, Ldap root password*: `zmlocalconfig --show | grep ldap_root_password`
    * *2 > 5, Ldap replication password*: `zmlocalconfig --show | grep ldap_replication_password`
    * *2 > 6, Ldap postfix password*: `zmlocalconfig --show | grep ldap_postfix_password`
    * *2 > 7, Ldap amavis password*: `zmlocalconfig --show | grep ldap_amavis_password`
    * *2 > 8, Ldap nginx password*: `zmlocalconfig --show | grep ldap_nginx_password`
    * *2 > 9, Ldap Bes Searcher password*: `zmlocalconfig --show | grep ldap_bes_searcher_password`
    * *3 > 3, Admin user to create*: `zmlocalconfig | grep smtp_source`
    * *3 > 4, Admin Password*: Account passwords are 1-way hashed, and cannot be retrieved. You either have to know this value already, or reset the account's password before copying data off of the old server.
    * *3 > 5, Anti-virus quarantine user*: `zmprov getConfig zimbraAmavisQuarantineAccount`
    * *3 > 7, Spam training user*: `zmprov getConfig zimbraSpamIsSpamAccount`
    * *3 > 8, Non-spam(Ham) training user*: `zmprov getConfig zimbraSpamIsNotSpamAccount`
    * *3 > 12, Web server mode*: Old value doesn't matter, just set this to **`redirect`**
1. Accept the configuration by selecting **a** at the Main Menu. Feel free to look around the rest of the settings first, but the defaults for other settings should be fine.
1. *Save configuration data to a file?* **Yes**
1. *Save config in file:* (accept the default by pressing **ENTER**)
1. *The system will be modified - continue?* **Yes**
1. *Notify Zimbra of your installation?* Choose **Yes** or **No**
1. *Configuration complete - press return to exit* Press **ENTER**

Check the service status and ensure everything is running:

    user@piers:$ sudo su - zimbra
    zimbra@piers:$ zmcontrol status

Access the Zimbra web application in a browser, e.g. at <http://174.79.40.35/> to ensure everything is working correctly. Do not try to send or receive email, as it will be lost during the data migration.

**Troubleshooting Note:** If `zmcontrol status` displays a message saying "`mysql.server is not running`", the problem may be that the MySQL `root` password is incorrect. This was the case with the installation I performed on 2012-10-18. To checkto see if the MySQL password is correct, first determine what Zimbra thinks the password should be, and then try logging in to MySQL directly, e.g.:

    zimbra@piers:$ zmlocalconfig -s | grep mysql_root_password
    zimbra@piers:$ mysql -u root -p

If this fails with the password returned by `zmlocalconfig`, the MySQL password needs to be reset, following the instructions on this page: <http://wiki.zimbra.com/wiki/Issues_with_mysql_and_logmysql_passwords>.

In my case, this still wasn't working. I ended up solving it by setting the MySQL root password to `''` and running `zmmyinit`, as follows:

    zimbra@piers:$ mysql.server start
    zimbra@piers:$ mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD('') WHERE User='root';"
    zimbra@piers:$ mysql -u root -e "FLUSH PRIVILEGES;"
    zimbra@piers:$ /opt/zimbra/libexec/zmmyinit --sql_root_pw `zmlocalconfig -s -m nokey mysql_root_password`
    zimbra@piers:$ zmcontrol stop
    zimbra@piers:$ zmcontrol start
    zimbra@piers:$ zmcontrol status


## Migrating from Old Server

References:

* [Zimbra Documentation: Moving from 32-bit to 64-bit Server](http://wiki.zimbra.com/wiki/Network_Edition:_Moving_from_32-bit_to_64-bit_Server)

Before starting the migration process, it's imperative to first block the both the old and new `piers` from receiving any new email. If this is not done, messages received during the migration will be lost. The simplest way to do this is to block all of the SMTP ports on the machines. This can be done by running the following commands on both the old and the new `piers`:

    user@piers:$ sudo ufw default allow
    user@piers:$ sudo ufw deny smtp
    user@piers:$ sudo ufw enable

Next, switch to the `zimbra` user and stop the Zimbra services on both the old and new `piers`:

    user@piers:$ sudo su - zimbra
    zimbra@piers:$ zmcontrol stop

Backup the LDAP configuration database and the LDAP data on the old `piers`:

    zimbra@piers:$ exit
    user@piers:$ sudo mkdir /zimbra-migration
    user@piers:$ sudo chown zimbra:zimbra /zimbra-migration
    user@piers:$ sudo chmod o+rw /zimbra-migration
    user@piers:$ sudo su - zimbra
    zimbra@piers:$ /opt/zimbra/libexec/zmslapcat -c /zimbra-migration
    zimbra@piers:$ /opt/zimbra/libexec/zmslapcat /zimbra-migration
    zimbra@piers:$ cp /opt/zimbra/data/ldap/hdb/db/DB_CONFIG /zimbra-migration

On the new `piers`, copy that data over and replace the LDAP data directories there with it (note that `174.79.40.36` is the IP of the old `piers`):

    zimbra@piers:$ exit
    user@piers:$ sudo mkdir /zimbra-migration
    user@piers:$ sudo scp -r user@174.79.40.36:/zimbra-migration /
    user@piers:$ sudo mkdir -p /zimbra-migration/clean/ldap/config /zimbra-migration/clean/ldap/hdb /zimbra-migration/clean/ldap/accesslog
    user@piers:$ sudo chmod -R o+r /zimbra-migration
    user@piers:$ sudo chown -R zimbra:zimbra /zimbra-migration
    user@piers:$ sudo su - zimbra
    zimbra@piers:$ mv /opt/zimbra/data/ldap/config/* /zimbra-migration/clean/ldap/config/
    zimbra@piers:$ mv /opt/zimbra/data/ldap/hdb/* /zimbra-migration/clean/ldap/hdb/
    zimbra@piers:$ mv /opt/zimbra/data/ldap/accesslog/* /zimbra-migration/clean/ldap/accesslog/
    zimbra@piers:$ mkdir -p /opt/zimbra/data/ldap/hdb/db /opt/zimbra/data/ldap/hdb/logs /opt/zimbra/data/ldap/accesslog/db /opt/zimbra/data/ldap/accesslog/logs
    zimbra@piers:$ cp /zimbra-migration/DB_CONFIG /opt/zimbra/data/ldap/hdb/db
    zimbra@piers:$ /opt/zimbra/openldap/sbin/slapadd -q -n 0 -F /opt/zimbra/data/ldap/config -cv -l /zimbra-migration/ldap-config.bak
    zimbra@piers:$ /opt/zimbra/openldap/sbin/slapadd -q -b "" -F /opt/zimbra/data/ldap/config -cv -l /zimbra-migration/ldap.bak

On the new `piers`, edit the `/opt/zimbra/conf/localconfig.xml` file to ensure that the following settings match their values in the same file on the old `piers`:

* `zimbra_mysql_password`
* `mysql_root_password`
* `zimbra_logger_mysql_password` (don't copy if empty/missing on the old `piers`)
* `mailboxd_keystore_password` (don't copy if empty/missing on the old `piers`)
* `mailboxd_truststore_password`
* `mailboxd_keystore_base_password`
* `zimbra_ldap_password`
* `ldap_root_password`
* `ldap_postfix_password`
* `ldap_amavis_password`
* `ldap_nginx_password`
* `ldap_replication_password`

On the old `piers`, copy the MySQL data and other data files to the new `piers` (note that `174.79.40.35` is the IP of the new `piers`):

    user@piers:$ sudo scp -r /opt/zimbra/db/data user@174.79.40.35:/zimbra-migration/db-data
    user@piers:$ sudo scp -r /opt/zimbra/store user@174.79.40.35:/zimbra-migration/store
    user@piers:$ sudo scp -r /opt/zimbra/index user@174.79.40.35:/zimbra-migration/index
    user@piers:$ sudo scp -r /opt/zimbra/mailboxd/etc/keystore user@174.79.40.35:/zimbra-migration/

On the new `piers`, copy that data to its new home:

    user@piers:$ sudo mv /opt/zimbra/db/data/ /opt/zimbra/store/ /opt/zimbra/index/ /opt/zimbra/mailboxd/etc/keystore /zimbra-migration/clean/
    user@piers:$ sudo cp -r /zimbra-migration/db-data /opt/zimbra/db/data
    user@piers:$ sudo cp -r /zimbra-migration/store /zimbra-migration/index /opt/zimbra/
    user@piers:$ sudo cp -r /zimbra-migration/keystore /opt/zimbra/mailboxd/etc/

Repair any potential permissions problems with files under `/opt/zimbra` on the new `piers`:

    user@piers:$ sudo chown -R zimbra:zimbra /opt/zimbra/store /opt/zimbra/index
    user@piers:$ sudo /opt/zimbra/libexec/zmfixperms

Start Zimbra back up on the new `piers`:

    user@piers:$ sudo su - zimbra
    zimbra@piers:$ zmcontrol start


## Verifying Migration

At this point, the DNS records for `piers` need to be updated to point to its new IP address. Please note: the `ufw` firewall rules are still in place, so neither `piers` will be receiving external mail yet, nor should they be. After updating the DNS records, access the Zimbra web interface for the new `piers`, e.g. at <https://piers.davisonlinehome.name>. Make sure sending mail internally (e.g. to the account you logged in with) and externally works.

If this works, the old `piers` should be powered down, and left that way.

Before disabling the firewall block on incoming mail, it's recommended you proceed with the upgrade to Ubuntu 12.04, as described in the "Upgrading to Ubuntu 12.04" section of <%= topic_link("/it/davis/servers/piers/") %>. Once that's complete, it's further recommended that you proceed with the upgrade to Zimbra 8 described below.


## Upgrading to Zimbra 8.0

References:

* [Zimbra wiki: OS Specific Platform Upgrades](http://wiki.zimbra.com/wiki/OS_Specific_Platform_Upgrades)
* [Zimbra forums: Upgrade Zimbra 7.2 on Ubuntu 8.04 to Zimbra 8 on Ubuntu 12.04](http://www.zimbra.com/forums/administrators/58265-upgrade-zimbra-7-2-ubuntu-8-04-zimbra-8-ubuntu-12-04-a.html)

Download the latest Ubuntu 64-bit Zimbra 8.0 release from [Zimbra Open Source Downloads](http://www.zimbra.com/downloads/os-downloads.html). On 2012-10-18, that was 8.0.0. Download the release via `wget`, e.g.:

    $ wget http://files2.zimbra.com/downloads/8.0.0_GA/zcs-8.0.0_GA_5434.UBUNTU10_64.20120907144627.tgz

Install the prerequisites needed by Zimbra:

    $ sudo apt-get install libgmp3c2 libperl5.14

Extract the installation bundle and start the installer:

    $ tar -xzf zcs-8.0.0_GA_5434.UBUNTU10_64.20120907144627.tgz
    $ cd zcs-8.0.0_GA_5434.UBUNTU10_64.20120907144627
    $ sudo ./install.sh

Proceed through the installation, as follows:

1. *Do you agree with the terms of the software license agreement?* **Y**
1. *Do you agree with the terms of the software license agreement?* **Y**
1. *Do you want to verify message store database integrity?* **N**
    * Because the 7.x release of Zimbra that's installed doesn't support Ubuntu 12.04, MySQL won't be running; the DB can't be accessed to check until after the Zimbra upgrade.
1. *Do you wish to upgrade?* **Y**
1. *Install zimbra-proxy* **N**
1. *The system will be modified.  Continue?* **Y**
1. *Notify Zimbra of your installation?* Choose **Yes** or **No**
1. *Configuration complete - press return to exit* Press **ENTER**

Check the service status and ensure everything is running:

    $ sudo -i -u zimbra zmcontrol status

Access the Zimbra web application in a browser, e.g. at <http://mail.davisonlinehome.name/>, to ensure everything is working correctly. If internal sends/receives work, and mail can be sent externaly successfully, it should be safe to disable the firewall block on incoming external mail:

    $ sudo ufw delete deny smtp
    $ sudo ufw disable


## Switching to Commercial SSL Certificate

References:

* [ZCS Certificate CLI](http://wiki.zimbra.com/wiki/Administration_Console_and_CLI_Certificate_Tools#Installing_Certificates)
* [Zimbra Forums: Renaming server domain, but keeping it](http://www.zimbra.com/forums/administrators/56502-renaming-server-domain-but-keeping.html)

### Switching Server Name & Domain

Before switching the certificate to use the same wildcard cert discussed in <%= topic_link("/it/davis/servers/eddings/web/") %>, the Zimbra server's hostname and default domain name need to be changed. This is made somewhat easier here since the new domain that the server's hostname will be "part of", `justdavis.com` already exists in DNS and in Zimbra.

First, put the server's domains into maintenance mode, which will prevent new mail delivery/receipt and also users from logging in:

    $ sudo su - zimbra
    $ zmprov modifydomain davisonlinehome.name zimbraDomainStatus maintenance
    $ zmprov modifydomain justdavis.com zimbraDomainStatus maintenance
    $ zmprov modifydomain madrivercode.com zimbraDomainStatus maintenance
    $ zmprov modifydomain madriverdevelopment.com zimbraDomainStatus maintenance
    $ zmprov modifydomain simplepersistence.com zimbraDomainStatus maintenance
    $ exit

Then make a backup:

    $ sudo su - zimbra
    $ zmcontrol stop
    $ exit
    $ sudo rsync -ah /opt/zimbra/ /opt/zimbra-backupBeforeRename-2013-10-18/
    $ sudo mkdir /opt/zimbra-backupBeforeRename-2013-10-18/ldap-dump
    $ sudo chown zimbra:zimbra /opt/zimbra-backupBeforeRename-2013-10-18/ldap-dump
    $ sudo su - zimbra
    $ /opt/zimbra/libexec/zmslapcat -c /opt/zimbra-backupBeforeRename-2013-10-18/ldap-dump
    $ /opt/zimbra/libexec/zmslapcat /opt/zimbra-backupBeforeRename-2013-10-18/ldap-dump
    $ zmcontrol start
    $ exit

Now, rename the server within Zimbra:

    $ sudo su - zimbra
    $ /opt/zimbra/libexec/zmsetservername --verbose --newServerName piers.justdavis.com
    $ exit

Then rename the server at the OS level by editing the following line in `/etc/hosts`, as follows:

    127.0.1.1 piers.justdavis.com piers

Verify the OS hostname by running the following command:

    $ hostname -f

Reboot the server:

    $ sudo reboot


#### Troubleshooting: Errors from `zmsetservername`

References:

* [Zimbra Forums: Change Zimbra Hostname](http://www.zimbra.com/forums/administrators/53575-change-hostname-zimbra-7-0-a.html)

When running the above `zmsetservername` command, I received the following errors towards the end:

    Unable to contact ldap://piers.davisonlinehome.name:389: Connection refused
    Unable to contact ldap://piers.davisonlinehome.name:389: Connection refused

To resolve those, the following commands were ran after the reboot:

    $ sudo su - zimbra
    $ zmcontrol stop
    $ /opt/zimbra/libexec/zmsetservername --verbose --force --newServerName piers.justdavis.com
    $ /opt/zimbra/libexec/zmsetservername --verbose --newServerName piers.davisonlinehome.name --newServerName piers.justdavis.com
    $ exit

The first `zmsetservername` command there generated a "`Failed to get server config for piers.justdavis.com.`" error. This was ignored. The second command didn't really do much of anything, but didn't produce any errors, either.

Unfortunately, running a `zmcontrol start` here still generated a bunch of failures.


### Deploying SSL Certificate to Zimbra

References:

* [Zimbra Wiki: Administration Console and CLI Certificate Tools](http://wiki.zimbra.com/wiki/Administration_Console_and_CLI_Certificate_Tools#Single-Node_Commercial_Certificate)

The following commands were run from `eddings` to copy the certificates over to `piers`:

    $ kinit karl
    $ aklog
    $ scp -r /afs/justdavis.com/user/karl/id/startcom/justdavis.com-wildcardCert-2013-03-30/ piers.justdavis.com:/home/karl/

The following was then run on `piers` to concatenate the CA and intermediate certs:

    $ cat justdavis.com-wildcardCert-2013-03-30/justdavis.com-wildcardCert-2013-03-30-ca-root.pem justdavis.com-wildcardCert-2013-03-30/justdavis.com-wildcardCert-2013-03-30-ca-intermediate.pem > justdavis.com-wildcardCert-2013-03-30/justdavis.com-wildcardCert-2013-03-30-ca-chain.pem

The certificate was verified with the following command:

    $ sudo /opt/zimbra/bin/zmcertmgr verifycrt comm justdavis.com-wildcardCert-2013-03-30/justdavis.com-wildcardCert-2013-03-30-keyWithoutPassword.key justdavis.com-wildcardCert-2013-03-30/justdavis.com-wildcardCert-2013-03-30.crt justdavis.com-wildcardCert-2013-03-30/justdavis.com-wildcardCert-2013-03-30-ca-chain.pem

Finally, the certificate was deployed, as follows:

    $ sudo cp justdavis.com-wildcardCert-2013-03-30/justdavis.com-wildcardCert-2013-03-30-keyWithoutPassword.key /opt/zimbra/ssl/zimbra/commercial/commercial.key
    $ sudo /opt/zimbra/bin/zmcertmgr deploycrt comm justdavis.com-wildcardCert-2013-03-30/justdavis.com-wi
ldcardCert-2013-03-30.crt justdavis.com-wildcardCert-2013-03-30/justdavis.com-wildcardCert-2013-03-30-ca-chain.pem


