--- 
title: Eddings Jenkins Server
kind: topic
summary: "Describes the steps necessary to make eddings a Jenkins CI server."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make the computer a [Jenkins](http://jenkins-ci.org/) CI build server. It assumes that the following guides have already been followed:

* <%= topic_summary_link("/it/davis/servers/eddings/web/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/ldap/") %>


## Installing the Java JDKs

Jenkins is a Java web application, that can be run via an embedded application server. This requires a JRE. As Jenkins will be used to build Java projects, it also requires a Java JDK. Install the JDKs that it will use as follows:

    $ sudo apt-get install openjdk-7-jdk openjdk-6-jdk


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


## Configuring Jenkins Authentication

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


## Build Settings/Configuration

The following Jenkins-wide settings were configured on <https://justdavis.com/jenkins/configure>:

1. **JDK**
    1. Click **JDK installations...**.
    1. Click **Delete JDK**.
    1. Click **Add JDK**.
        1. Name: `java-7-openjdk`
        1. Install automatically: false/disabled
        1. JAVA_HOME: `/usr/lib/jvm/java-7-openjdk-amd64`
    1. Click **Add JDK**.
        1. Name: `java-6-openjdk`
        1. Install automatically: false/disabled
        1. JAVA_HOME: `/usr/lib/jvm/java-6-openjdk-amd64`
1. **Git**
    1. Click **Git installations...**.
        1. Name: `Default`
        1. Installation directory: `git`
1. **Maven**
    1. Click **Maven installations...**.
    1. Click **Delete Maven**.
    1. Click **Add Maven**.
        1. Name: `maven-3.1.1`
        1. Install automatically: true/enabled
        1. Version: `3.1.1`
1. **Jenkins Location**
    1. System Admin e-mail address: `Jenkins Admin <admin.jenkins@justdavis.com>`
1. **E-mail Notification**
    1. SMTP server: `mail.justdavis.com`
    1. Click **Advanced...**
    1. Use SSL: true/enabled
1. **GitHub Web Hook**
    1.  Let Jenkins auto-manage hook URLs: true/enabled
        1. API key: (created at <https://github.com/settings/applications>)

**Note:** For GitHub integration to work, I had to update to version 1.8 of the Jenkins GitHub plugin.

The following node-specific settings were configured on <https://justdavis.com/jenkins/computer/%28master%29/configure>:

1. \# of executors: `1`
1. Labels: `linux`


## Configuring SSH Access for Git

References:

* [Stack Overflow: Jenkins Host key verification failed](http://stackoverflow.com/a/15196114)
* [GitHub Help: Generating SSH Keys](https://help.github.com/articles/generating-ssh-keys)

Generate an SSH keypair for the `jenkins` user (just leaving the options blank, as below):

    $ sudo su - jenkins
    $ ssh-keygen -t rsa -C "admin.jenkins@justdavis.
    Enter file in which to save the key (/var/lib/jenkins/.ssh/id_rsa): 
    Enter passphrase (empty for no passphrase): 
    Enter same passphrase again: 
    $ exit

Configure Git for the `jenkins` user:

    $ sudo su - jenkins
    $ git config --global user.email "admin.jenkins@justdavis.com"
    $ git config --global user.name "https://justdavis.com/jenkins/"
    $ exit

Authorize the GitHub host key, enter `yes` when prompted to accept it:

    $ sudo su - jenkins
    $ git ls-remote -h git@github.com:karlmdavis/jessentials.git HEAD
    $ exit

Authorize the SSH public key for the `jenkins` user on GitHub. Run the following commands to write out the public key to the terminal:

    $ sudo su - jenkins
    $ cat ~/.ssh/id_rsa.pub
    $ exit

Copy-paste the output from `cat` into <https://github.com/settings/ssh>.


## Configuring PostgreSQL Access for Jenkins

This section assumes the following pre-requisites have been completed:

* <%= topic_summary_link("/it/davis/servers/eddings/sonarqube/") %>

Some of the Jenkins builds will need access to a PostgreSQL database server as part of their automated tests. While the installation of PostgreSQL was handled via Puppet as part of the Sonar configuration (as referenced just above), a separate role/user was also created for Jenkins.

The following was run to create that role:

    $ sudo -u postgres createuser --createdb --no-createrole --no-superuser jenkins --pwprompt

The following was then added to the Global Maven `settings.xml` for Jenkins, via the [Config File Management plugin](https://justdavis.com/jenkins/configfiles/) (the password was set to the correct one):

    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" 
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
      <profiles>
        <profile>
          <!-- This profile sets the properties needed for integration tests that use the 
             com.justdavis.karl.misc.datasources.provisioners API. -->
          <id>justdavis-integration-tests</id>
          <properties>
            <com.justdavis.karl.datasources.provisioner.postgresql.server.url>jdbc:postgresql:postgres</com.justdavis.karl.datasources.provisioner.postgresql.server.url>
            <com.justdavis.karl.datasources.provisioner.postgresql.server.user>jenkins</com.justdavis.karl.datasources.provisioner.postgresql.server.user>
            <com.justdavis.karl.datasources.provisioner.postgresql.server.password>secretpw</com.justdavis.karl.datasources.provisioner.postgresql.server.password>
          </properties>
        </profile>
      </profiles>
      <activeProfiles>
        <activeProfile>justdavis-integration-tests</activeProfile>
      </activeProfiles>
    </settings>


### Troubleshooting: GitHub Web Hooks Not Working

Due to [JENKINS-20140](https://issues.jenkins-ci.org/browse/JENKINS-20140), I had to do the following:

1. Go to <https://justdavis.com/jenkins/configureSecurity/?>.
1. Set **Prevent Cross Site Request Forgery exploits** to disabled.


### Troubleshooting: SSL Errors When Sending Test Email

References:

* [StartCom Forums: How to make Java trust StartCom CA at Runtime](https://forum.startcom.org/viewtopic.php?f=15&t=1815)
* [Ubuntu Launchpad Bug #983302: ca-certificates-java fails to install java cacerts on oneiric](https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/983302)

This is really frustrating, but apparently StartSSL's CA certificate is not trusted by Java by default. However, Ubuntu should import the system's CA trust store into the Java trust store. For whatever reason, that hadn't happened correctly on `eddings`. The problem was fixed by running the following:

    $ sudo dpkg --purge --force-depends ca-certificates-java; sudo apt-get install ca-certificates-java

