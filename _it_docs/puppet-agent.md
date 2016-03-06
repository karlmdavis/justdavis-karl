---
title: Puppet Agents/Clients
layout: it_doc
description: "Describes the steps necessary to install and configure the Puppet agent service."
---

This page describes the steps necessary to install and configure the Puppet agent service such that it is running against the Puppet master described in {% collection_doc_link /it/eddings/puppet baseurl:true %}.


## Prerequisite: Correct Hostname

Before installing Puppet, it's important to ensure that the soon-to-be new agent node has the correct short and fully-qualified hostname. Run the following command to verify this on Ubuntu:

    $ hostname -f

If not, verify that the following two files are correct (it might be wise to verify this anyways):

1. `/etc/hostname`: Should just contain the short hostname.
1. `/etc/hosts`: Should contain `localhost` and both the short and fully qualified hostnames, as follows:

        127.0.0.1	localhost
        127.0.1.1	shortname.fully.qualified.com	shortname


## Installing the Puppet Agent: Ubuntu Precise (12.04)

References:

* [Puppet Docs: Using the Puppet Labs Package Repositories](http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html)
* [Puppet Docs: Installing Puppet](http://docs.puppetlabs.com/guides/installation.html#change-puppet-masters-web-server)

The version of Puppet available in the Ubuntu Precise repositories is 2.7. This is rather old (compared to the version 3.3 that's out as of 2013-10-26), and makes life using Puppet quite a bit more difficult. To avoid that, it's best to get Puppet from the [apt.puppetlabs.com](http://apt.puppetlabs.com/) repositories. This can be done by installing the `puppetlabs-release` package that they make available, as follows:

    $ wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
    $ sudo dpkg -i puppetlabs-release-precise.deb
    $ rm puppetlabs-release-precise.deb
    $ sudo apt-get update

Once this is complete, the Puppet agent can be installed:

    $ sudo apt-get install puppet


## Configuring and Starting the Puppet Agent: Ubuntu (All Versions)

The following steps are necessary to configure and start the Puppet agent service:

1. Configure the agent service:

        $ sudo apt-get instal augeas-tools
        $ sudo augtool --autosave set /files/etc/puppet/puppet.conf/main/server eddings.justdavis.com
        $ sudo augtool --autosave set /files/etc/default/puppet/START "yes"

1. Start the agent service:

        $ sudo service puppet start

1. On the Puppet master view and sign/accept the agent certificate request that is waiting:

        $ sudo puppet cert --list
        $ sudo puppet cert --sign /etc/puppet/manifests/nodes/someagent/shortname.fully.qualified.com.pp

In general, most nodes will pull their Puppet configuration from Hiera (see TODO). However, if node-specific configuration is needed, it can be handled as follows:

1. On the Puppet master, create the node `.pp` definition in `/etc/puppet/manifests/nodes/`, e.g. `/etc/puppet/manifests/nodes/someagent/shortname.fully.qualified.com.pp`:

        # The configuration file for this node.
        node 'shortname.fully.qualified.com' {
        }

1. Notify Puppet that the nodes' configuration has changed:

        $ sudo touch /etc/puppet/manifests/site.pp

1. The new node's configuration should probably also be committed to Git:

        $ cd /etc/puppet/
        $ git add /etc/puppet/manifests/nodes/someagent/shortname.fully.qualified.com.pp
        $ git commit -m "Created an initial node config for shortname."

By default, the new Puppet agent will now pick up new configs from the master every 30 minutes. To "kick" the agent such that it immediately checks for a new configuration, run the following on the agent system:

    $ sudo pkill -SIGUSR1 -f "puppet agent"


