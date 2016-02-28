---
title: Eddings Nexus Server
parent: /it/eddings
layout: it_doc
description: "Describes the steps necessary to make eddings a Nexus repository manager server."
---

This {% collection_doc_link /it/eddings baseurl:true %} sub-guide describes the steps necessary to make the computer a [Nexus](http://www.sonatype.org/nexus/) [Maven](http://maven.apache.org/) repository manager server. It assumes that the following guides have already been followed:

* {% collection_doc_link_long /it/eddings/kerberos baseurl:true %}
* {% collection_doc_link_long /it/eddings/ldap baseurl:true %}
* {% collection_doc_link_long /it/eddings/web baseurl:true %}
* {% collection_doc_link_long /it/eddings/tomcat baseurl:true %}

Previously, I'd been using `tolkien` as a Nexus server, which has now been decommissioned. The documentation for the old `tolkien` Nexus server is archived in: <%= wiki_entry_link("TolkienSetupNexus") %>.


## Installing Nexus

References:

* <http://www.sonatype.com/books/nexus-book/reference/install-sect-as-a-war.html>
* <https://docs.sonatype.com/display/SPRTNXOSS/Nexus+FAQ#NexusFAQ-Q.HowcanIcontrolNexusconfigurationsinmyenvironment%3F>

Nexus is a Java web application and requires a Java web application server to host it, e.g. [Jetty](http://jetty.codehaus.org/jetty/), [Tomcat](http://tomcat.apache.org/), etc. There are two "flavors" of Nexus available for download:

1. Standalone, where Nexus is shipped as a binary containing an embedded/built-in Java web application server.
1. WAR, where Nexus is shipped as a generic `.war` file that can be hosted in any compatible Java web application server.

Because it's likely that this computer will end up hosting other Java web applications besides just Nexus, it makes sense for us to use the WAR and stick Nexus into a web application container that can later be used for other things.

Download the latest release of the Nexus WAR. The link can be found at: [Download and Install Nexus](http://www.sonatype.org/nexus/go). For example, the following will download the 2.0.4 release:

    $ wget http://www.sonatype.org/downloads/nexus-2.0.4-1.war

"Install" the WAR to the `/usr/local/` folder and "publish" it to Tomcat's `webapps` folder:

    $ sudo mkdir -p /usr/local/manual-installs/sonatype-nexus/
    $ sudo mv nexus-2.0.4-1.war /usr/local/manual-installs/sonatype-nexus/
    $ sudo chown tomcat7:tomcat7 /usr/local/manual-installs/sonatype-nexus/nexus-2.0.4-1.war
    $ sudo ln -s /usr/local/manual-installs/sonatype-nexus/nexus-2.0.4-1.war /var/lib/tomcat7/webapps/nexus.war

Create the location that Nexus will use to store all of its data:

    $ sudo mkdir -p /var/sonatype/nexus
    $ sudo chown tomcat7:tomcat7 /var/sonatype/nexus

Configure Nexus to use that storage location by adding the following lines to `/etc/default/tomcat7`:

    # Configure the default storage directory for Sonatype's Nexus web application.
    export PLEXUS_NEXUS_WORK=/var/sonatype/nexus

On its next restart, Tomcat will automatically deploy that WAR and serve it at the following URL: <http://eddings:8080/nexus/>:

    $ sudo /etc/init.d/tomcat7 restart


## Proxying Nexus into Apache

References:

* <http://wiki.eclipse.org/Jetty/Tutorial/Apache>
* <http://httpd.apache.org/docs/2.2/mod/mod_proxy.html>
* [Nexus FAQ: How can I integrate Nexus with Apache Httpd and Mod_Proxy?](https://docs.sonatype.com/display/SPRTNXOSS/Nexus+FAQ#NexusFAQ-Q.HowcanIintegrateNexuswithApacheHttpdandModProxy)

Because Tomcat is running on the non-standard `8080` port and *can't* run on the same port `80` already being used by Apache on this server, we'll configure Apache to forward/proxy requests for certain URLs to Tomcat. For this particular configuration, we'll be modifying the `justdavis.com-ssl` virtual site in Apache, as configured in: {% collection_doc_link /it/eddings baseurl:true %}.

Enable Apache's `mod_proxy` and `mod_proxy_http` modules, which will be needed for this:

    $ sudo a2enmod proxy
    $ sudo a2enmod proxy_http

Add the following configuration to the end of the `VirtualHost` block in `/etc/apache2/sites-available/justdavis.com-ssl`:

~~~~
	# Configure mod_proxy to be used for proxying URLs on this site to other URLs/ports on this server.
	ProxyRequests Off
	ProxyVia Off
	ProxyPreserveHost On
	<Proxy *>
		AddDefaultCharset off
		Order deny,allow
		Allow from all
	</Proxy>

	# Proxy the Java web application running at http://localhost:8080/nexus
	<Location /nexus/>
		ProxyPass http://localhost:8080/nexus/
		ProxyPassReverse http://localhost:8080/nexus/
		SetEnv proxy-nokeepalive 1
	</Location>
~~~~

Restart Apache to apply the module and configuration changes:

    $ sudo /etc/init.d/apache2 restart

Configure the proxy URL as the base URL in Nexus, as follows:

1. Open [Nexus](https://justdavis.com/nexus/) in a browser.
1. Login as the built-in `admin` user.
1. Open the **Administration > Server** panel.
1. Set the following options:
    * Application Server Settings (optional): true/enabled
    * Base URL: `https://madrivercode.com/nexus/`
    * Force Base URL: true/enabled
1. Click **Save**.


## Migrating Nexus Data from Old Server

References:

* <http://www.sonatype.com/people/2010/01/how-to-backup-nexus-configuration-and-repository-artifacts/>
* <http://superuser.com/questions/117870/ssh-execute-sudo-command>

As the instance previously hosted by `tolkien` (<%= wiki_entry_link("TolkienSetupNexus") %>) is being moved to this server, the data from the old server needs to be moved over to this one. This is actually pretty simple, we'll just `rsync` Nexus' "work" directory from the old server to the new.

First, stop Nexus/Tomcat on both servers so that nothing is modified during this operation:

    $ sudo service tomcat7 stop
    $ ssh -t karl@tolkien.madrivercode.com 'sudo /etc/init.d/nexus stop'

Next, `rsync` the Nexus data from `tolkien` to this server, overwiting the existing (mostly empty) data:

    $ sudo rsync -a --delete -v karl@tolkien.madrivercode.com:/var/lib/sonatype-work/nexus/ /var/sonatype/nexus/
    $ sudo chown -R tomcat7:tomcat7 /var/sonatype/nexus

Then, disable the old Nexus server so it never runs again and start the new one back up:

    $ ssh -t karl@tolkien.madrivercode.com 'sudo rm /etc/init.d/nexus'
    $ ssh -t karl@tolkien.madrivercode.com 'sudo update-rc.d nexus remove'
    $ sudo service tomcat7 start


## Upgrading Nexus from 2.0.4-1 to 2.3.1-01

Stop the Tomcat service hosting Nexus:

    $ sudo service tomcat7 stop

Download the Nexus WAR. The link can be found at: [Download and Install Nexus](http://www.sonatype.org/nexus/go). For example, the following will download the 2.3.1-01 release:

    $ wget http://www.sonatype.org/downloads/nexus-2.3.1-01.war

"Install" the WAR to the `/usr/local/` folder and "publish" it to Tomcat's `webapps` folder:

    $ sudo mv nexus-2.3.1-01.war /usr/local/manual-installs/sonatype-nexus/
    $ sudo chown tomcat7:tomcat7 /usr/local/manual-installs/sonatype-nexus/nexus-2.3.1-01.war
    $ sudo ln -s /usr/local/manual-installs/sonatype-nexus/nexus-2.3.1-01.war /var/lib/tomcat7/webapps/nexus.war

Restart Tomcat to ensure that Nexus gets redeployed:

    $ sudo service tomcat7 restart

Access the [Nexus webapp](https://justdavis.com/nexus/) and make sure everything started correctly (may take a few minutes before it's available).


## Upgrading Nexus from 2.3.1-01 to 2.11.1-01

References:

* [Where is the Nexus OSS war file?](https://support.sonatype.com/entries/84544447-Where-is-the-Nexus-OSS-war-file-)
* [Installing and Running Nexus](http://books.sonatype.com/nexus-book/reference/install.html)
* [How do I change the port or address that Nexus binds to?](https://support.sonatype.com/entries/21159382-How-do-I-change-the-port-or-address-that-Nexus-binds-to-)

This upgrade is a bit tricky, as Nexus has deprecated their WAR-only distribution. Instead, they strongly recommend deploying the embedded Jetty servlet.

First, disable the old Nexus version:

    $ sudo service tomcat7 stop
    $ sudo rm /var/lib/tomcat7/webapps/nexus.war
    $ sudo service tomcat7 start

Create a new `nexus` user (just accept all defaults, when prompted):

    $ sudo adduser --system --home /var/sonatype/nexus --shell /bin/bash --disabled-password --group nexus

Create a link for the Nexus data and reset its permissions:

    $ sudo ln -s /var/sonatype/ /usr/local/manual-installs/sonatype-nexus/sonatype-work
    $ sudo chown -R nexus:nexus /var/sonatype/nexus/

Download the latest Nexus version. The link can be found at: [Download and Install Nexus](http://www.sonatype.org/nexus/go). For example, the following will download the 2.11.1-01 release:

    $ wget http://download.sonatype.com/nexus/oss/nexus-2.11.1-01-bundle.tar.gz

Unpack the bundle to the `/usr/local/` directory:

    $ sudo tar --extract --gunzip --file nexus-2.11.1-01-bundle.tar.gz --directory /usr/local/manual-installs/sonatype-nexus/
    $ sudo ln -s /usr/local/manual-installs/sonatype-nexus/nexus-2.11.1-01/bin/nexus /etc/init.d/nexus

Make sure the `nexus` user owns the install's `logs` and `tmp` directories, which will be modified while the service is running:

    $ sudo chown -R nexus:nexus /usr/local/manual-installs/sonatype-nexus/nexus-2.11.1-01/logs/
    $ sudo chown -R nexus:nexus /usr/local/manual-installs/sonatype-nexus/nexus-2.11.1-01/tmp/

Edit the `/etc/init.d/nexus` file and make the following changes:

* `NEXUS_HOME`: set to `/usr/local/manual-installs/sonatype-nexus/nexus-2.11.1-01`
* `RUN_AS_USER`: set to `nexus`
* `PIDDIR`: set to `/var/sonatype/nexus`

Edit the `/usr/local/manual-installs/sonatype-nexus/nexus-2.11.1-01/conf/nexus.properties` file and make the following changes:

* `application-port`: set to `8082`

Be sure to update the Apache proxy configuration in `/etc/apache2/sites-available/justdavis.com-ssl` to account for the new port number.

Register the `nexus` service:

    $ cd /etc/init.d
    $ sudo update-rc.d nexus defaults
    $ sudo service nexus start

Access the [Nexus webapp](https://justdavis.com/nexus/) and make sure everything started correctly (may take a few minutes before it's available).


## Configuring LDAP Authentication

References:

* [Nexus Book: Chapter 8. Nexus LDAP Integration](http://www.sonatype.com/books/nexus-book/reference/ldap.html)

Nexus can be set to use the LDAP users from the server described in {% collection_doc_link /it/eddings/ldap baseurl:true %}. It could also be configured to use LDAP groups, though that's not particularly useful for the small `justdavis.com` domain.

LDAP authentication can be configured through the Nexus GUI, as follows:

1. Open [Nexus](https://madrivercode.com/nexus/) in a browser.
1. Login as the built-in `admin` user.
1. Open the **Administration > Server** panel.
1. In *Security Settings*, add **OSS LDAP Authentication Realm** as the last entry in the *Selected Realms* list.
1. Click **Save**.
1. Open the **Security > LDAP Configuration** panel.
1. Set the options, as follows:
    * Protocol: **ldaps**
    * Hostname: `ldap.justdavis.com`
    * Search Base: `dc=justdavis,dc=com`
    * Authentication Method: **Anonymous Authentication**
    * Base DN: `ou=people`
    * User Subtree: false
    * Object Class: `inetOrgPerson`
    * User Filter: (leave blank)
    * User ID Attribute: `uid`
    * Real Name Attribute: `cn`
    * E-Mail Attribute: `mail`
    * Password Attribute: (leave blank)
    * Group Element Mapping: false/disabled
1. Click **Save**.

Add the LDAP user `karl` to the *Nexus Administrator Role*, as follows:

1. Open the **Security > Users** panel.
1. Switch the **All Configured Users** dropdown to **LDAP**.
1. Click **Refresh** (to the left of that dropdown).
1. Select the **karl** user.
1. Under *Role Management*, click **Add**.
1. Select the **Nexus Administrator Role** and click **OK**.
1. Click **Save**.

Change the `admin` user's password:

1. Open the **Security > Users** panel.
1. Right-click the **admin** user and select the **Set Password** option.
1. Enter the new password, click **Set Password**, and then click **Save**.


## Configuring Repository Permissions

References:

* [Sonatype Nexus Security Cookbook: Can I make a repository private without disabling anonymous access?](https://support.sonatype.com/entries/24901127-Sonatype-Nexus-Security-Cookbook)

This Nexus repository contains both private repositories (the "Mad River Code" repos) and public/open source repositories (everything else). As such, the permissions for the `anonymous` user had to be adjusted a bit. By default, `anonymous` is given read access to all repos, including those that should be private on this server. Per the article above, new privileges and roles were created to replace this default "read everything" role. The steps in the article were followed, more or less exactly.
