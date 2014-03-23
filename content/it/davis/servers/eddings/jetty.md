--- 
title: Eddings Jetty Server
kind: topic
summary: "Describes the steps necessary to make eddings a Jetty web application server."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make the computer a [Jetty 6](http://www.eclipse.org/jetty/) web application server. It assumes that the following guides have already been followed:

* <%= topic_summary_link("/it/davis/servers/eddings/kerberos/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/ldap/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/web/") %>


## Installing Java

Jetty is a Java web application server and requires a JRE.

To check to see if Java is already installed, run the following command:

    $ java -version

If that comes back with an error, install Java as follows:

    $ sudo apt-get install openjdk-7-jre-headless


## Installing Jetty

Jetty can be installed as follows:

    $ sudo apt-get install jetty

Jetty requires some additional configuration before it can be started up. Edit the `/etc/default/jetty` file as follows:

* Set `NO_START` to `0`.
* Set `JETTY_PORT` to `8080`.

Please note that, with this configuration, Jetty will only be accessible at <http://localhost:8080/> on the server; it will not be accessible from any external IPs. This is just fine for our purposes, as we'll be using an Apache proxy to make Jetty's applications available on port `80`, anyways. However, if you'd like to change that, you'll need to also do the following in `/etc/default/jetty`:

* Set `JETTY_HOST` to `0.0.0.0`.

**Post-12.04 Upgrade Note:** If this server is running Ubuntu 12.04 or later, the following entry must also be added to the `/etc/default/jetty` file:

* Set `JAVA_HOME` to `/usr/lib/jvm/java-7-openjdk-amd64` (or whatever the path to the JDK is).

Start Jetty by running:

    $ sudo service jetty start


## Enabling Remote Deployment

This Jetty server will also be used to host projects that are in development. Accordingly, a way to remotely and automatically deploy these projects is needed.


### Jetty Remote Deployer

References:

* [Jetty Remote Deployer](http://cargo.codehaus.org/Jetty+Remote+Deployer)

Out of the box, Jetty doesn't support remote deployment. However, the [Jetty Remote Deployer](http://cargo.codehaus.org/Jetty+Remote+Deployer) from the [Cargo](http://cargo.codehaus.org/) project can be used to enable this.

Download and install it as follows:

    $ wget http://repo1.maven.org/maven2/org/codehaus/cargo/cargo-jetty-6-and-earlier-deployer/1.4.7/cargo-jetty-6-and-earlier-deployer-1.4.7.war
    $ sudo mkdir -p /usr/local/cargo-jetty-deployer/
    $ sudo mv cargo-jetty-6-and-earlier-deployer-1.4.7.war /usr/local/cargo-jetty-deployer/
    $ sudo chown jetty:adm /usr/local/cargo-jetty-deployer/cargo-jetty-6-and-earlier-deployer-1.4.7.war
    $ sudo ln -s /usr/local/cargo-jetty-deployer/cargo-jetty-6-and-earlier-deployer-1.4.7.war /var/lib/jetty/webapps/cargo-jetty-deployer.war

Restart Jetty to deploy the new webapp:

    $ sudo service jetty restart


### Apache Proxy for Deployer

This WAR/webapp will be exposed and secured via Apache. Add the following configuration to `/etc/apache2/sites-enabled/justdavis.com-ssl`:

~~~~
# Proxy the Java web application running at http://localhost:8080/cargo-jetty-deployer
<Location /cargo-jetty-deployer>
	ProxyPass http://localhost:8080/cargo-jetty-deployer
	ProxyPassReverse http://localhost:8080/cargo-jetty-deployer
	ProxyPassReverse http://justdavis.com/cargo-jetty-deployer
	SetEnv proxy-nokeepalive 1

	# This webapp can deploy/undeploy webapps to the Jetty server running on eddings
	# and needs to be secured.
	AuthType Kerberos
	AuthName "Kerberos Login"
	KrbAuthRealm JUSTDAVIS.COM
	Krb5Keytab /etc/apache2/apache2.keytab
	#KrbMethodK5Passwd off #optional--makes GSSAPI SPNEGO a requirement
	Require valid-user
</Location>
~~~~

Reload the Apache config:

    $ sudo service apache2 reload

This makes the deployer available at the following URL: <https://justdavis.com/cargo-jetty-deployer/>. If things are working correctly, browsing to that URL should require valid authentication and then display a "`Command / is unknown`" error.

