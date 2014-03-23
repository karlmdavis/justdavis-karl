--- 
title: Eddings Tomcat Server
kind: topic
summary: "Describes the steps necessary to make eddings a Tomcat web application server."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make the computer a [Tomcat 7](http://tomcat.apache.org/) web application server. It assumes that the following guides have already been followed:

* <%= topic_summary_link("/it/davis/servers/eddings/kerberos/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/ldap/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/web/") %>


## Installing Java

Tomcat is a Java web application server and requires a JRE.

To check to see if Java is already installed, run the following command:

    $ java -version

If that comes back with an error, install Java as follows:

    $ sudo apt-get install openjdk-7-jre-headless


## Installing Tomcat

Tomcat can be installed as follows:

    $ sudo apt-get install tomcat7 tomcat7-admin

Please note that, with the default configuration, Tomcat will only be accessible at <http://localhost:8080/> on the server; it will not be accessible from any external IPs. This is just fine for our purposes, as we'll be using an Apache proxy to make Tomcat's applications available remotely, anyways. However, if you'd like to change that, you'll need to edit the `/etc/tomcat7/server.xml` file.


## Enabling Remote Deployment

This Tomcat server will also be used to host projects that are in development. Accordingly, a way to remotely and automatically deploy these projects is needed.


### Apache Proxy for Tomcat Manager

This WAR/webapp will be exposed and secured via Apache. Add the following configuration to `/etc/apache2/sites-enabled/justdavis.com-ssl`:

~~~~
# Proxy the Java web application running at http://localhost:8080/manager
<Location /manager>
	ProxyPass http://localhost:8080/manager
	ProxyPassReverse http://localhost:8080/manager
	ProxyPassReverse http://justdavis.com/manager
	SetEnv proxy-nokeepalive 1
</Location>
~~~~

Reload the Apache config:

    $ sudo service apache2 reload

This makes the manager available at the following URL: <https://justdavis.com/manager/>.


### Tomcat LDAP Authentication

References:

* [Tomcat 7: Realm Configuration HOW-TO: JNDIRealm](http://tomcat.apache.org/tomcat-7.0-doc/realm-howto.html#JNDIRealm)

By default, no one will have permissions to use the Tomcat Manager application. To fix this, Tomcat should be configured to use LDAP authentication.

Add the following config to `/var/lib/tomcat7/conf/server.xml`, inside the `<Engine name="Catalina"/>` element:

~~~~
      <!-- Enable login via the justdavis.com LDAP directory. -->
      <Realm className="org.apache.catalina.realm.JNDIRealm"
             connectionURL="ldaps://ldap.justdavis.com"
             userPattern="uid={0},ou=people,dc=justdavis,dc=com"
             roleBase="ou=groups,dc=justdavis,dc=com"
             roleName="cn"
             roleSearch="(memberUid={1})"/>
~~~~

In addition, the LDAP `administrators` group was given permission to use Tomcat's "manager" webapp, by editing the `/usr/share/tomcat7-admin/manager/WEB-INF/web.xml` file, as follows (note the added `<role-name/>` elements):

~~~~
  <!-- Define a Security Constraint on this Application -->
  <!-- NOTE:  None of these roles are present in the default users file -->
  <security-constraint>
    <web-resource-collection>
      <web-resource-name>HTML Manager interface (for humans)</web-resource-name>
      <url-pattern>/html/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
       <role-name>manager-gui</role-name>
       <role-name>administrators</role-name>
    </auth-constraint>
  </security-constraint>
  <security-constraint>
    <web-resource-collection>
      <web-resource-name>Text Manager interface (for scripts)</web-resource-name>
      <url-pattern>/text/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
       <role-name>manager-script</role-name>
       <role-name>administrators</role-name>
    </auth-constraint>
  </security-constraint>
  <security-constraint>
    <web-resource-collection>
      <web-resource-name>JMX Proxy interface</web-resource-name>
      <url-pattern>/jmxproxy/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
       <role-name>manager-jmx</role-name>
       <role-name>administrators</role-name>
    </auth-constraint>
  </security-constraint>
  <security-constraint>
    <web-resource-collection>
      <web-resource-name>Status interface</web-resource-name>
      <url-pattern>/status/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
       <role-name>manager-gui</role-name>
       <role-name>manager-script</role-name>
       <role-name>manager-jmx</role-name>
       <role-name>manager-status</role-name>
       <role-name>administrators</role-name>
    </auth-constraint>
  </security-constraint>
~~~~


### Tomcat Kerberos Authentication

**NOTE:** Was never able to get this working, and went with LDAP, instead (see above).

A Kerberos principal keytab for Tomcat needs to be exported:

    $ sudo kadmin -p karl/admin
    kadmin>  ktadd -k /var/lib/tomcat7/conf/tomcat7.keytab HTTP/eddings.justdavis.com
    kadmin>  quit
    $ sudo chown tomcat7:tomcat7 /var/lib/tomcat7/conf/tomcat7.keytab
    $ sudo chmod u=r,g=,o= /var/lib/tomcat7/conf/tomcat7.keytab

Create the following as `/var/lib/tomcat7/conf/jaas.conf`:

~~~~
com.sun.security.jgss.krb5.initiate {
    com.sun.security.auth.module.Krb5LoginModule required
    doNotPrompt=true
    principal="HTTP/eddings.justdavis.com@JUSTDAVIS.COM"
    useKeyTab=true
    keyTab="/var/lib/tomcat7/conf/tomcat7.keytab"
    storeKey=true;
};

com.sun.security.jgss.krb5.accept {
    com.sun.security.auth.module.Krb5LoginModule required
    doNotPrompt=true
    principal="HTTP/eddings.justdavis.com@JUSTDAVIS.COM"
    useKeyTab=true
    keyTab="/var/lib/tomcat7/conf/tomcat7.keytab"
    storeKey=true;
};
~~~~

Create the following as `/var/lib/tomcat7/conf/krb5.ini`:

~~~~
[libdefaults]
default_realm = JUSTDAVIS.COM
default_keytab_name = FILE:/var/lib/tomcat7/conf/tomcat7.keytab
default_tkt_enctypes = rc4-hmac,aes256-cts-hmac-sha1-96,aes128-cts-hmac-sha1-96
default_tgs_enctypes = rc4-hmac,aes256-cts-hmac-sha1-96,aes128-cts-hmac-sha1-96
forwardable=true

[realms]
JUSTDAVIS.COM = {
        kdc = eddings.justdavis.com:88
}

[domain_realm]
justdavis.com= JUSTDAVIS.COM
.justdavis.com= JUSTDAVIS.COM
~~~~

Add the following to `/etc/default/tomcat7`:

~~~~
# Enable the JAAS Kerberos configuration.
KRB_OPTS="-Djava.security.auth.login.config=/var/lib/tomcat7/conf/jaas.conf"
KRB_OPTS="${KRB_OPTS} -Djava.security.krb5.conf=/var/lib/tomcat7/conf/krb5.ini"
KRB_OPTS="${KRB_OPTS} -Dsun.security.krb5.debug=true"
JAVA_OPTS="${JAVA_OPTS} ${KRB_OPTS}"
~~~~

