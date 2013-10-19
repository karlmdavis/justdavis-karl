--- 
title: Eddings Jenkins Server
kind: topic
summary: "Describes the steps necessary to make eddings a Jenkins CI server."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make the computer a [Jenkins](http://jenkins-ci.org/) CI build server. It assumes that the following guides have already been followed:

* <%= topic_summary_link("/it/davis/servers/eddings/web/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/ldap/") %>


## Installing a Java JDK

Jenkins is a Java web application, that can be run via an embedded application server. This requires a JRE. As Jenkins will be used to build Java projects, it also requires a Java JDK.

To check to see if a JDK is already installed, run the following command:

    $ javac -version

If that comes back with an error or a version less than 1.7, install OpenJDK as follows:

    $ sudo apt-get install openjdk-7-jdk


## Installing Jenkins

References:

* [Jenkins Wiki: Installing Jenkins on Ubuntu](https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Ubuntu)

Add the Jenkins APT repository, as follows:

    $ wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    $ sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
    $ sudo apt-get update

Once that's in place, installing Jenkins is simple:

    $ sudo apt-get install jenkins

During the installation, the following error message will likely be displayed:

~~~~
The selected http port (8080) seems to be in use by another program 
Please select another port to use for jenkins
~~~~

This error is caused by Nexus running on the same port that Jenkins is trying to. Edit the `/etc/default/jenkins` file and modify the `HTTP_PORT` option, as follows:

~~~~
HTTP_PORT=8081
~~~~

After starting the `jenkins` service, it should be available at the following URL: <http://eddings.justdavis.com:8081/>:

    $ sudo service jenkins start


# Configuring Jenkins Authentication

By default, Jenkins is configured to be entirely open: anyone can modify the configuration, create/manage jobs, etc. Obviously, this isn't a great idea for a publicly-accessible web application. To solve this, Jenkins will be modified to use the LDAP server detailed in <%= topic_link("/it/davis/servers/eddings/ldap/") %>.

First, Jenkins' security mechanisms need to be enabled. Browse to <http://eddings.justdavis.com:8081/configureSecurity/?>, and configure the options as follows:

1. Enable security: true/enabled.
1. Security realm: **LDAP**.
1. Server: `ldaps://ldap.justdavis.com`
1. (Click **Advanced...** to show the additional LDAP options.)
1. root DN: `dc=justdavis,dc=com`
1. User search base: `ou=people`
1. Group search base: `ou=groups`
1. Authorization: **Logged-in users can do anything**
1. Prevent Cross Site Request Forgery exploits: true/enabled
1. Crumb Algorithm: **Default Crumb Issuer**
1. Click **Save**

After saving the options, you will be presented with a login prompt. Log in using an LDAP user and their password, e.g. `karl`.


## Proxying Jenkins into Apache

References:

* [Jenkins Wiki: Running Jenkins behind Apache](https://wiki.jenkins-ci.org/display/JENKINS/Running+Jenkins+behind+Apache)
* <http://wiki.eclipse.org/Jetty/Tutorial/Apache>
* <http://httpd.apache.org/docs/2.2/mod/mod_proxy.html>
* [Nexus FAQ: How can I integrate Nexus with Apache Httpd and Mod_Proxy?](https://docs.sonatype.com/display/SPRTNXOSS/Nexus+FAQ#NexusFAQ-Q.HowcanIintegrateNexuswithApacheHttpdandModProxy)

Because Jenkins is running on the non-standard `8081` port and *can't* run on the same port `80` already being used by Apache on this server, we'll configure Apache to forward/proxy requests for certain URLs to Jenkins. For this particular configuration, we'll be modifying the `justdavis.com-ssl` virtual site in Apache, as configured in: <%= topic_link("/it/davis/servers/eddings/") %>.

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

	# Proxy the Java web application running at http://localhost:8081/
	<Location /jenkins/>
		ProxyPass http://localhost:8081/jenkins
		ProxyPassReverse http://localhost:8081/jenkins
		ProxyPassReverse http://justdavis.com/jenkins
		SetEnv proxy-nokeepalive 1
	</Location>
~~~~

Please note that the first part of that configuration may already be there if Nexus has also been installed and configured in <%= topic_link("/it/davis/servers/eddings/nexus/") %>. It does not need to be duplicated; just add the `Location /jenkins/` section.

Restart Apache to apply the module and configuration changes:

    $ sudo service apache2 restart

Configure the proxy URL as the base URL in Jenkins, as follows:

1. Browse to <http://eddings.justdavis.com:8081/configure>.
1. Set the following options:
    * Jenkins URL: `https://justdavis.com/jenkins/`
1. Click **Save**.

Modify the Jenkins configuration to use the new prefix/context path by editing `/etc/default/jenkins` to add a `--prefix` to `JENKINS_ARGS`, as follows:

~~~~
PREFIX=/jenkins
JENKINS_ARGS="--webroot=/var/cache/jenkins/war --httpPort=$HTTP_PORT --ajp13Port=$AJP_PORT --prefix=$PREFIX"
~~~~

After restarting Jenkins, it should now be accessible from <https://justdavis.com/jenkins/>:

    $ sudo service jenkins restart

