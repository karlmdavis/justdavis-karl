--- 
title: Eddings Nagios Monitoring
kind: topic
summary: "Describes the steps necessary to make eddings a Nagios monitoring server."
---

# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make the computer a [Nagios](http://www.nagios.org/) monitoring server. It assumes that the following guides have already been followed:

* <%= topic_summary_link("/it/davis/servers/eddings/kerberos/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/ldap/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/web/") %>

This monitoring will help ensure that the network and the devices hosted on it are all functioning correctly.


## Installation

References:

* [Ubuntu Server Guide: Nagios](https://help.ubuntu.com/12.04/serverguide/nagios.html)
* [Ask Ubuntu: How do I install nagios?](http://askubuntu.com/questions/145518/how-do-i-install-nagios)

Run the following command to install Nagios and the [nagios-nrpe-plugin](https://launchpad.net/ubuntu/precise/+package/nagios-nrpe-plugin) package for it, which will allow Nagios to monitor remote systems (systems other than the one it is installed on):

    $ sudo apt-get install nagios3 nagios-nrpe-plugin

When prompted during the install to enter the *Nagios web administration password*, enter a password, being sure to write it down someplace safe.

Once the install has completed, Nagios can be accessed by browsing to <https://justdavis.com/nagios3/>. The `nagiosadmin` user can be used for authentication, with the password entered earlier.


## Kerberos Authentication

As an Apache web application, Nagios can be configured via [mod_auth_kerb](http://modauthkerb.sourceforge.net/) to delegate authentication to Kerberos. This will prevent the need for separate users & passwords.

Install the required Apache module:

    $ sudo apt-get install libapache2-mod-auth-kerb

Ensure that Apache's `www-data` user group has read access to the Kerberos `/etc/krb5.keytab` file:

    $ sudo chown root:www-data /etc/krb5.keytab
    $ sudo chmod g+r /etc/krb5.keytab

Nagios' Apache configuration needs to be modified to use Kerberos for authentication. Edit the `/etc/apache2/conf.d/nagios3.conf` file and modify the following section:

~~~~
<DirectoryMatch (/usr/share/nagios3/htdocs|/usr/lib/cgi-bin/nagios3|/etc/nagios3/stylesheets)>
	Options FollowSymLinks

	DirectoryIndex index.php index.html

	AllowOverride AuthConfig
	Order Allow,Deny
	Allow From All

	AuthName "Nagios Access"
	AuthType Basic
	AuthUserFile /etc/nagios3/htpasswd.users
	# nagios 1.x:
	#AuthUserFile /etc/nagios/htpasswd.users
	require valid-user
</DirectoryMatch>
~~~~

That section should instead read as follows:

~~~~
<DirectoryMatch (/usr/share/nagios3/htdocs|/usr/lib/cgi-bin/nagios3|/etc/nagios3/stylesheets)>
	Options FollowSymLinks

	DirectoryIndex index.php index.html

	AllowOverride AuthConfig
	Order Allow,Deny
	Allow From All

	AuthName "Nagios Access"
	AuthType Kerberos
	Krb5KeyTab /etc/krb5.keytab
	KrbAuthRealms JUSTDAVIS.COM
	require valid-user
</DirectoryMatch>
~~~~

By default, `mod_auth_kerb` will use an `HTTP` service principal on the server. This Kerberos principal will need to be created and added to the system's default keytab file (`/etc/krb5.keytab`). The simplest way to do this is to run the `kadmin` tool, as follows:

~~~~
# sudo kadmin -p karl/admin@JUSTDAVIS.COM
kadmin:  addprinc -policy services -randkey HTTP/eddings.justdavis.com
kadmin:  ktadd HTTP/eddings.justdavis.com
kadmin:  quit
~~~~

Restart Apache to apply all of the configuration changes:

    $ sudo service apache2 restart

Nagios now needs to be configured to authorize Kerberos users as admins. To do so, edit the `/etc/nagios3/cgi.cfg` file and modify the related options, as follows:

~~~~
authorized_for_system_information=nagiosadmin,karl@JUSTDAVIS.COM
authorized_for_configuration_information=nagiosadmin,karl@JUSTDAVIS.COM
authorized_for_system_commands=nagiosadmin,karl@JUSTDAVIS.COM
authorized_for_all_services=nagiosadmin,karl@JUSTDAVIS.COM
authorized_for_all_hosts=nagiosadmin,karl@JUSTDAVIS.COM
authorized_for_all_service_commands=nagiosadmin,karl@JUSTDAVIS.COM
authorized_for_all_host_commands=nagiosadmin,karl@JUSTDAVIS.COM
~~~~


## Nagios Graphs

References:

* The docs in `/usr/share/doc/nagiosgrapher/` from the `nagiosgrapher` package.
* The sample graphing configurations in `/usr/share/nagiosgrapher/debian/cfg/ngraph.d/` from the `nagiosgrapher` package.
* [Install NagiosGrapher On Ubuntu](http://www.ftmon.org/blog/install-nagiosgrapher-ubuntu/)

By default, the only graphs Nagios produces are "Good/Warning/Critical" trends of monitors over time. However, plugins are available that can graph fine-grained data.

First, install the relevant Nagios plugin:

    $ sudo apt-get install nagiosgrapher

Set Nagios to process performance data and route that processing through the grapher by editing `/etc/nagios3/nagios.cfg` and setting the following options:

~~~~
process_performance_data=1
service_perfdata_command=ngraph-process-service-perfdata-pipe
~~~~

Give users access to the graphs by editing the `` file and modifying the following option:

~~~~
    fe_use_browser_for      nagiosadmin,karl@JUSTDAVIS.COM
~~~~

Individual monitors may or may not have graphs at this point. Monitor-specific configuration is needed to enable graphing for each. For some reason, the Ubuntu version of this package disables some of the standard Debian configurations. They can be enabled, as follows:

    $ sudo cp /usr/share/nagiosgrapher/debian/cfg/ngraph.d/standard/check_disk.ncfg /etc/nagiosgrapher/ngraph.d/standard/
    $ sudo cp /usr/share/nagiosgrapher/debian/cfg/ngraph.d/standard/check_load.ncfg /etc/nagiosgrapher/ngraph.d/standard/
    $ sudo cp /usr/share/nagiosgrapher/debian/cfg/ngraph.d/standard/check_ping.ncfg /etc/nagiosgrapher/ngraph.d/standard/
    $ sudo cp /usr/share/nagiosgrapher/debian/cfg/ngraph.d/standard/check_procs.ncfg /etc/nagiosgrapher/ngraph.d/standard/
    $ sudo cp /usr/share/nagiosgrapher/debian/cfg/ngraph.d/standard/check_users.ncfg /etc/nagiosgrapher/ngraph.d/standard/

Restart Nagios and the grapher:

    $ sudo service nagiosgrapher restart
    $ sudo service nagios3 restart

After a few minutes, restart Nagios again so that it picks up the new graph data:

    $ sudo service nagios3 restart


## Common Service Monitors: Disable HTTP Monitor

The default Nagios service definitions (used for all hosts) included a call to the [check_http](http://nagiosplugins.org/man/check_http) plugin. This is problematic as a) not all monitored systems are web servers and b) those systems that are don't necessarily serve HTTP on the IP Nagios uses to reach them.

To resolve this, the "`HTTP`" service definition was commented out in `/etc/nagios3/conf.d/services_nagios2.cfg`.


## Host Monitors: eddings

The following monitors were added to the default set for `eddings` (called `localhost` by the Nagios server).


### Disk Space on eddings

The default Nagios service definitions for `eddings` included a call to the `check_all_disks` command. This is problematic as the `/boot` partition on `eddings` is mostly full (this is pretty much the default behavior for Ubuntu).

To resolve this, the "`Disk Space`" service definition was commented out in `/etc/nagios3/conf.d/localhost_nagios2.cfg` and the following service definitions were added to replace it:

~~~~
define service{
	use			generic-service     ; Inherit values from a template
	host_name		localhost           ; The name of the host the service is associated with
	service_description	Disk Space: /root   ; The service description
	check_command		check_disk!20%!10%!/root
	}

define service{
	use			generic-service     ; Inherit values from a template
	host_name		localhost           ; The name of the host the service is associated with
	service_description	Disk Space: /vicepa ; The service description
	check_command		check_disk!20%!10%!/vicepa
	}
~~~~

Nagios needs to be restarted after adding these definitions:

    $ sudo service nagios3 restart


### Packet Loss Between eddings and the Internet

I've had troubles with my server's connection to the internet at various points in time. Every time this occurs, my ISP's technical support asks me "How long has this been going on?", and I never have a very good answer. Has it been bad for just the hour I've been using it? Has it been intermittently bad all week? I never really know. These Nagios monitors solve that lack-of-data problem.

The following command definition was added to `/etc/nagios3/commands.cfg`:

~~~~
# Custom command definition: 'check_remote_ping'
define command{
	command_name	check_remote_ping
	command_line	/usr/lib/nagios/plugins/check_ping -H '$ARG1$' -w '$ARG2$' -c '$ARG3$'
	}
~~~~

The following service definitions were added to `/etc/nagios3/conf.d/localhost_nagios2.cfg`:

~~~~
define service{
	use			generic-service     ; Inherit values from a template
	host_name		localhost           ; The name of the host the service is associated with
	service_description	Ping Google         ; The service description
	check_command		check_remote_ping!8.8.8.8!200.0,5%!500.0,10%	; The command used to monitor the service: warn at 5% loss, error at 10% loss
	normal_check_interval	5	            ; Check the service every 5 minutes under normal conditions
	retry_check_interval	1	            ; Re-check the service every minute until its final/hard state is determined
	}

define service{
	use			generic-service     ; Inherit values from a template
	host_name		localhost           ; The name of the host the service is associated with
	service_description	Ping OpenDNS        ; The service description
	check_command		check_remote_ping!208.67.222.222!200.0,5%!500.0,10%	; The command used to monitor the service: warn at 5% loss, error at 10% loss
	normal_check_interval	5	            ; Check the service every 5 minutes under normal conditions
	retry_check_interval	1	            ; Re-check the service every minute until its final/hard state is determined
	}
~~~~

Nagios needs to be restarted after adding these definitions:

    $ sudo service nagios3 restart

The following graphing definitions were added to `/etc/nagiosgrapher/ngraph.d/extra/check_ping_remote.ncfg`:

~~~~
define ngraph{
	service_name		Ping Google
	graph_log_regex		loss = (\d+)
	graph_value		Loss
	graph_units		%
	graph_legend		Loss
	graph_legend_eol	none
	page			2 Loss
	rrd_plottype		LINE2
	rrd_color		ff0000
}

define ngraph{
	service_name		Ping OpenDNS
	graph_log_regex		loss = (\d+)
	graph_value		Loss
	graph_units		%
	graph_legend		Loss
	graph_legend_eol	none
	page			2 Loss
	rrd_plottype		LINE2
	rrd_color		ff0000
}
~~~~


### HTTPS Server on eddings

The `eddings` server hosts several applications (including Nagios) via apache over HTTPS on its `174.79.40.37` IP address. This service should be monitored.

The following command definition was added to `/etc/nagios3/commands.cfg`, using the [check_http](http://nagiosplugins.org/man/check_http) plugin:

~~~~
# Custom command definition: 'check_https_remote'
define command{
        command_name    check_https_remote
        command_line    /usr/lib/nagios/plugins/check_http --ssl -H '$ARG1$' -I '$ARG1$' -u '$ARG2$' -e '$ARG3$'
        }
~~~~

The following service definition was added to `/etc/nagios3/conf.d/localhost_nagios2.cfg`:

~~~~
define service{
	use			generic-service     ; Inherit values from a template
	host_name		localhost           ; The name of the host the service is associated with
	service_description	Check Apache        ; The service description
	check_command		check_https_remote!174.79.40.37!/karl/!HTTP/1.1 200 OK
	}
~~~~

Nagios needs to be restarted after adding these definitions:

    $ sudo service nagios3 restart


## Host Monitors: dumas

References:

* [Monitoring Windows with Nagios](http://awaseroot.wordpress.com/2012/11/23/monitoring-windows-with-nagios/)

Erica's Windows desktop, `dumas`, was also added to Nagios monitoring. This is mostly to track the health of the wireless ethernet connectoin it uses.

Download and install the latest version of [NSClient++](http://nsclient.org/nscp/) on the Windows system. When prompted during install, enter the following options:

* *Allowed hosts*: `192.168.1.100` (the IP of `eddings` on the LAN)
* *NSClient password*: (leave blank)
* *Modules to install*: (select all but **Enable NSCA client**)

There are a couple of bugs with the default [check_nt]() command templates distributed by Ubuntu. Edit the `/etc/nagios-plugins/config/nt.cfg` file and modify the command definition to match the following (note the lack of single quotes, the additional port parameter, and the addition of `$ARG2$`):

~~~~
# 'check_nt' command definition
define command {
	command_name	check_nt
	command_line	/usr/lib/nagios/plugins/check_nt -H $HOSTADDRESS$ -p 12489 -v $ARG1$ $ARG2$
}

~~~~

Save the following template for Windows hosts as `/etc/nagios3/conf.d/generic-windows_nagios2.cfg`:

~~~~
define host{
	name                    windows-server
	use                     generic-host
	check_period            24x7
	check_interval          5
	retry_interval          1
	max_check_attempts      10
	check_command           check-host-alive
	notification_period     24x7
	notification_interval   30
	notification_options    d,r
	contact_groups          admins
	register                0
	}
~~~~

The following host definition was created as `/etc/nagios3/conf.d/dumas_nagios2.cfg`:

~~~~
define host{
	use			windows-server
	host_name		dumas.justdavis.com
	alias			dumas.justdavis.com
	address			192.168.1.8
	}

define service{
	use			generic-service
	host_name		dumas.justdavis.com
	service_description	PING
	check_command		check_ping!200.0,2%!500.0,5%
	normal_check_interval	5
	retry_check_interval	1
	}

define service{
	use			generic-service
	host_name		dumas.justdavis.com
	service_description	NSClient++ Version
	check_command		check_nt!CLIENTVERSION
}

define service{
	use			generic-service
	host_name		dumas.justdavis.com
	service_description	Uptime
	check_command		check_nt!UPTIME
}

define service{
	use			generic-service
	host_name		dumas.justdavis.com
	service_description	CPU Load
	check_command		check_nt!CPULOAD!-l 5,80,90
}
define service{
	use			generic-service
	host_name		dumas.justdavis.com
	service_description	Memory Usage
	check_command		check_nt!MEMUSE!-w 80 -c 90
}

define service{
	use			generic-service
	host_name		dumas.justdavis.com
	service_description	C:\ Drive Space
	check_command		check_nt!USEDDISKSPACE!-l C -w 80 -c 90
}
~~~~

Nagios needs to be restarted after adding these definitions:

    $ sudo service nagios3 restart

