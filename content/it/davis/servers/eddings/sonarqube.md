--- 
title: Eddings SonarQube Server
kind: topic
summary: "Describes the steps necessary to make eddings a SonarQube server."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make eddings a [SonarQube](http://www.sonarqube.org/) server. It assumes that the following guides have already been followed:

* <%= topic_summary_link("/it/davis/servers/eddings/ldap/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/puppet/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/jenkins/") %>

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
1. Populate the `karl` account from LDAP:
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
1. Create a `jenkins` user:
    1. Open the *Settings > Users* page: <https://justdavis.com/sonar/users>.
    1. In the *Add new user* pane on the right:
        1. Login: `jenkins`
        1. Name: `Jenkins Service Account`
        1. Email: (leave blank)
        1. Enter a password for the account.
        1. Write down the password in a secure location.
        1. Click **Create**.
    1. Click the **(select)** link for the `karl` user's groups.
    1. Add the account to the *sonar-users* and *sonar-administrators* groups.
    1. Click the **Save** button.


## Configuring the Analysis Profile

When SonarQube analyzes a project, it does so against a set of rules known as a Quality Profile. This is basically a set of PMD rules that can be enabled/disabled. The default profiles have some silly rules, which need to be changed:

1. Open the *Quality Profiles* page: <https://justdavis.com/sonar/profiles>.
1. Click the **Copy** button for the *Sonar way with Findbugs* profile.
    1. New name: `justdavis.com`
    1. Click the **Copy** button.
1. Click the **Set as default** button for the new *justdavis.com* profile.
1. Open the new **justdavis.com** profile and make the following changes:
    * *Coding rules*
        * *if/else/for/while/do statements should always use curly braces*: disable
        * *Tabulation characters should not be used*: disable


## Running SonarQube Analysis in Jenkins

References:

* [Sonar Docs: Jenkins Plugin](http://docs.codehaus.org/display/SONAR/Jenkins+Plugin)

The primary way that projects will be added to SonarQube, and analyzed when changes are made to them, is via [Jenkins](https://justdavis.com/jenkins/).


### Installing the SonarQube Plugin in Jenkins

The SonarQube plugin for Jenkins was installed, as follows:

1. Open the [Manage Jenkins > Manage Plugins](https://justdavis.com/jenkins/pluginManager/?) page in Jenkins.
1. Switch to the **Available** tab.
1. Select the **Jenkins Sonar Plugin** from the list.
1. Click the **Download now and install after restart** button.
1. Restart Jenkins, as follows:

       $ sudo service jenkins restart

1. Open the [Manage Jenkins > Configure System](https://justdavis.com/jenkins/configure) page in Jenkins.
1. Scroll down to the *sonar > Sonar installations* section (not the *Sonar Runner* section).
1. Click **Add Sonar**.
    1. Name: `https://justdavis.com/sonar/`
    1. Click **Advanced...**.
    1. Server URL: `https://justdavis.com/sonar/`
    1. Sonar account login: `jenkins`
    1. Sonar account password: (the password that was set for the `jenkins` account in SonarQube that was created above)
    1. Database URL: `jdbc:postgresql://localhost/sonar`
    1. Database password: `sonarpassword`
    1. Database driver: `org.postgresql.Driver`
    1. Click the **Save** button at the bottom of the page.


### Adding SonarQube Analysis to a Jenkins Project

SonarQube analysis needs to be configured for each project it's desired for. This was done, as follows:

1. Open the project's **Configure** page, e.g. <https://justdavis.com/jenkins/job/jessentials/configure>.
1. Click the **Add post-build action** dropdown.
1. Select **Sonar**.
1. Click the **Save** button at the bottom of the page.

Once this has been configured, trigger a build of the project.

