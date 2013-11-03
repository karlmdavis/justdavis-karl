--- 
title: Eddings SonarQube Server
kind: topic
summary: "Describes the steps necessary to make eddings a SonarQube server."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make eddings a [SonarQube](http://www.sonarqube.org/) server. It assumes that the following guides have already been followed:

* <%= topic_summary_link("/it/davis/servers/eddings/ldap/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/puppet/") %>

SonarQube provides a code quality analysis service and web application dashboard. It can be used to run static analysis tools such as [PMD](http://pmd.sourceforge.net/), storing, and tracking the results over time.


## Installing the SonarQube Server

References:

* [GitHub: karlmdavis/puppet-sonar](https://github.com/karlmdavis/puppet-sonar)

The installation of Sonar was actually handled via Puppet: <https://github.com/karlmdavis/justdavis-puppet/blob/master/manifests/nodes/eddings.pp>. This included the [LDAP plugin for Sonar](http://docs.codehaus.org/display/SONAR/LDAP+Plugin), along with the DB that is used to store Sonar's data.

In addition, an Apache proxy was setup was Sonar, using the following configuration in `/etc/apache2/sites-enabled/justdavis.com-ssl`:

    # Proxy the Java web application running at http://localhost:9000/
    <Location /sonar>
    	ProxyPass http://localhost:9000/sonar
    	ProxyPassReverse http://localhost:9000/sonar
    	ProxyPassReverse http://justdavis.com/sonar
    	SetEnv proxy-nokeepalive 1
    </Location>

This makes Sonar available at the following URL: <https://justdavis.com/sonar/>.


## Configuring SonarQube

References:

* [SonarQube Docs: Setup and Upgrade](http://docs.codehaus.org/display/SONAR/Setup+and+Upgrade)

The following was done after installing Sonar, to configure it:

1. Open the Sonar web application: <https://justdavis.com/sonar/>.
1. Log in using the default `admin` account. The default password is "`admin`".
1. Reset the `admin` user's password:
    1. Open the *Settings > Users* page: <https://justdavis.com/sonar/users>.
    1. Click the **Change Password** link for the `admin` user.
    1. In the pane on the right, enter the new password.
    1. Write down the password in a secure location.
    1. Click the **Update** button.
1. Populate the `karl` accoutn from LDAP:
    1. Log out.
    1. Log in using the `karl` account from LDAP/Kerberos.
    1. Log out.
    1. Lock back in as `admin`.
1. Make the `karl` user a Sonar admin:
    1. Open the *Settings > Users* page: <https://justdavis.com/sonar/users>.
    1. Click the **(select)** link for the `karl` user's groups.
    1. Add the account to the *sonar-users* and *sonar-administrators* groups.
    1. Click the **Save** button.
1. Log out.
1. Log in using the `karl` account.

