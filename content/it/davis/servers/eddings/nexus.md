--- 
title: Eddings Nexus Server
kind: topic
summary: "Describes the steps necessary to make eddings a Nexus repository manager server."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make the computer a [Nexus](http://www.sonatype.org/nexus/) [Maven](http://maven.apache.org/) repository manager server. It assumes that the following guides have already been followed:

* <%= topic_summary_link("/it/davis/servers/eddings/kerberos/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/ldap/") %>

Previously, I'd been using `tolkien` as a Nexus server, which has now been decommissioned. The documentation for the old `tolkien` Nexus server is archived in: <%= wiki_entry_link("TolkienSetupNexus") %>.


## Installing Java

Nexus is a Java web application, that can be run via an embedded Jetty server. This requires a JRE.

To check to see if Java is already installed, run the following command:

    $ java -version

If that comes back with an error, install Java as follows:

    $ sudo apt-get install openjdk-6-jre-headless


## Installing Jetty

Nexus is a Java web application and requires a Java web application server to host it, e.g. [Jetty](http://jetty.codehaus.org/jetty/), [Tomcat](http://tomcat.apache.org/), etc. There are two "flavors" of Nexus available for download:

1. Standalone, where Nexus is shipped as a binary containing an embedded/built-in Java web application server.
1. WAR, where Nexus is shipped as a generic `.war` file that can be hosted in any compatible Java web application server.

Because it's likely that this computer will end up hosting other Java web applications besides just Nexus, it makes sense for us to use the WAR and stick Nexus into a web application container that can later be used for other things. In general, I prefer to use Jetty when given a choice of web application containers, as it's simpler. Jetty can be installed as follows:

    $ sudo apt-get install jetty

Jetty requires some additional configuration before it can be started up. Edit the `/etc/default/jetty` file as follows:

* Set `NO_START` to `0`.
* Set `JETTY_PORT` to `8080`.

Please note that, with this configuration, Jetty will only be accessible at <http://localhost:8080/> on the server; it will not be accessible from any external IPs. This is just fine for our purposes, as we'll be using an Apache proxy to make Jetty's applications available on port `80`, anyways. However, if you'd like to change that, you'll need to also do the following in `/etc/default/jetty`:

* Set `JETTY_HOST` to `0.0.0.0`.

**Post-12.04 Upgrade Note:** If this server is running Ubuntu 12.04 or later, the following entry must also be added to the `/etc/default/jetty` file:

* Set `JAVA_HOME` to `/usr/lib/jvm/java-7-openjdk-amd64` (or whatever the path to the JDK is).

Start Jetty by running:

    $ sudo /etc/init.d/jetty start


## Installing Nexus

References:

* <http://www.sonatype.com/books/nexus-book/reference/install-sect-as-a-war.html>
* <https://docs.sonatype.com/display/SPRTNXOSS/Nexus+FAQ#NexusFAQ-Q.HowcanIcontrolNexusconfigurationsinmyenvironment%3F>

Download the latest release of the Nexus WAR. The link can be found at: [Download and Install Nexus](http://www.sonatype.org/nexus/go). For example, the following will download the 2.0.4 release:

    $ wget http://www.sonatype.org/downloads/nexus-2.0.4-1.war

"Install" the WAR to the `/usr/local/` folder and "publish" it to Jetty's `webapps` folder:

    $ sudo mkdir -p /usr/local/manual-installs/sonatype-nexus/
    $ sudo mv nexus-2.0.4-1.war /usr/local/manual-installs/sonatype-nexus/
    $ sudo chown jetty:adm /usr/local/manual-installs/sonatype-nexus/nexus-2.0.4-1.war
    $ sudo ln -s /usr/local/manual-installs/sonatype-nexus/nexus-2.0.4-1.war /var/lib/jetty/webapps/nexus.war

Create the location that Nexus will use to store all of its data:

    $ sudo mkdir -p /var/sonatype/nexus
    $ sudo chown jetty:adm /var/sonatype/nexus

Configure Nexus to use that storage lcoation by adding the following lines to `/etc/default/jetty`:

    # Configure the default storage directory for Sonatype's Nexus web application.
    export PLEXUS_NEXUS_WORK=/var/sonatype/nexus

On its next restart, Jetty will automatically deploy that WAR and serve it at the following URL: <http://eddings:8080/nexus/>:

    $ sudo /etc/init.d/jetty stop
    $ sudo /etc/init.d/jetty start


## Proxying Nexus into Apache

References:

* <http://wiki.eclipse.org/Jetty/Tutorial/Apache>
* <http://httpd.apache.org/docs/2.2/mod/mod_proxy.html>
* [Nexus FAQ: How can I integrate Nexus with Apache Httpd and Mod_Proxy?](https://docs.sonatype.com/display/SPRTNXOSS/Nexus+FAQ#NexusFAQ-Q.HowcanIintegrateNexuswithApacheHttpdandModProxy)

Because Jetty is running on the non-standard `8080` port and *can't* run on the same port `80` already being used by Apache on this server, we'll configure Apache to forward/proxy requests for certain URLs to Jetty. For this particular configuration, we'll be modifying the `justdavis.com` virtual site in Apache, as configured in: <%= topic_link("/it/davis/servers/eddings/") %>.

Enable Apache's `mod_proxy` and `mod_proxy_http` modules, which will be needed for this:

    $ sudo a2enmod proxy
    $ sudo a2enmod proxy_http

Add the following configuration to the end of the `VirtualHost` block in `/etc/apache2/sites-available/justdavis.com`:

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

1. Open [Nexus](https://madrivercode.com/nexus/) in a browser.
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

First, stop `jetty`/Nexus on both servers so that nothing is modified during this operation:

    $ sudo /etc/init.d/jetty stop
    $ ssh -t karl@tolkien.madrivercode.com 'sudo /etc/init.d/nexus stop'

Next, `rsync` the Nexus data from `tolkien` to this server, overwiting the existing (mostly empty) data:

    $ sudo rsync -a --delete -v karl@tolkien.madrivercode.com:/var/lib/sonatype-work/nexus/ /var/sonatype/nexus/
    $ sudo chown -R jetty:adm /var/sonatype/nexus

Then, disable the old Nexus server so it never runs again and start the new one back up:

    $ ssh -t karl@tolkien.madrivercode.com 'sudo rm /etc/init.d/nexus'
    $ ssh -t karl@tolkien.madrivercode.com 'sudo update-rc.d nexus remove'
    $ sudo /etc/init.d/jetty start


## Upgrading Nexus from 2.0.4-1 to 2.3.1-01

Stop the Jetty service hosting Nexus:

    $ sudo service jetty stop

Download the Nexus WAR. The link can be found at: [Download and Install Nexus](http://www.sonatype.org/nexus/go). For example, the following will download the 2.3.1-01 release:

    $ wget http://www.sonatype.org/downloads/nexus-2.3.1-01.war

"Install" the WAR to the `/usr/local/` folder and "publish" it to Jetty's `webapps` folder:

    $ sudo mv nexus-2.3.1-01.war /usr/local/manual-installs/sonatype-nexus/
    $ sudo chown jetty:adm /usr/local/manual-installs/sonatype-nexus/nexus-2.3.1-01.war
    $ sudo ln -sf /usr/local/manual-installs/sonatype-nexus/nexus-2.3.1-01.war /var/lib/jetty/webapps/nexus.war

Start the Jetty service hosting Nexus:

    $ sudo service jetty start

Access the [Nexus webapp](https://madrivercode.com/nexus/) and make sure everything started correctly (may take a few minutes before it's available).


## Configuring LDAP Authentication

References:

* [Nexus Book: Chapter 8. Nexus LDAP Integration](http://www.sonatype.com/books/nexus-book/reference/ldap.html)

Nexus can be set to use the LDAP users from the server described in <%= topic_link("/it/davis/servers/eddings/ldap/") %>. It could also be configured to use LDAP groups, though that's not particularly useful for the small `justdavis.com` domain.

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

