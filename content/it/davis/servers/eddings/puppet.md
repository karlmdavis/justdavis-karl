--- 
title: Eddings Puppet Master Server
kind: topic
summary: "Describes the steps necessary to make eddings a Puppet master server."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make the computer a [Puppet](http://puppetlabs.com/) master server. It assumes that the following guides have already been followed:

* <%= topic_summary_link("/it/davis/servers/eddings/kerberos/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/ldap/") %>

Puppet is a configuration management system: it can be used to manage the packages installed on systems, configuration files, services, users, etc. As the `justdavis.com` network is adding Puppet in late, only new services added going forwards will be managed via Puppet; already-installed services will continue to be managed manually.


## Installing the Puppet Master Server

References:

* [Puppet Docs: Using the Puppet Labs Package Repositories](http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html)
* [Puppet Docs: Installing Puppet](http://docs.puppetlabs.com/guides/installation.html#change-puppet-masters-web-server)

The version of Puppet available in the Ubuntu Precise repositories is 2.7. This is rather old (compared to the version 3.3 that's out as of 2013-10-26), and makes life using Puppet quite a bit more difficult. To avoid that, it's best to get Puppet from the [apt.puppetlabs.com](http://apt.puppetlabs.com/) repositories. This can be done by installing the `puppetlabs-release` package that they make available, as follows:

    $ wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
    $ sudo dpkg -i puppetlabs-release-precise.deb
    $ rm puppetlabs-release-precise.deb
    $ sudo apt-get update

Once this is complete, the Puppet master can be installed:

    $ sudo apt-get install puppetmaster


## Version Controlling the Puppet Configuration

References:

* [GitHub Help: Adding a remote](https://help.github.com/articles/adding-a-remote)
* [Stack Overflow: How can I associate local unversioned code to git remote repository?](http://stackoverflow.com/a/13362116)

One of the primary advantages of configuration management systems like Puppet is that the network's configuration can be version controlled. For the `justdavis.com` network and this Puppet master, the following GitHub repository was created and used: <https://github.com/karlmdavis/justdavis-puppet>.

First, configure Git for the local user (e.g. `karl`):

    $ sudo apt-get install git
    $ git config --global user.name "Karl M. Davis"
    $ git config --global user.email karl@justdavis.com

Then, either generate a new SSH key on the Puppet master or, preferably, copy an existing key from the workstation typically used for GitHub access, e.g.:

    karl@jordan-u:~$ scp ~/.ssh/id_rsa{.pub,} karl@eddings.justdavis.com:/home/karl/.ssh/

All Git commits and pushes should be run as that user. Git commands that might modify the local files, e.g. pulls, will have to be run as `root` via `sudo` or by temporarily giving users write access to the Puppet directory (i.e. `chmod -R a+w /etc/puppet/ && git pull && chmod -R a-w /etc/puppet/`). For pulls, another option is to break them apart into separate `git fetch` and `sudo git merge origin/master` commands.

On the Puppet master, run the following to initialize version control using this repository:

    $ cd /etc/puppet
    $ sudo git init --shared=all
    $ sudo chmod -R a+w .git
    $ git remote add --track master origin git@github.com:karlmdavis/justdavis-puppet.git
    $ git fetch
    $ sudo git merge origin/master
    $ sudo git reset --hard origin/master
    $ git add -A
    $ git commit -m "Initial Puppet config."
    $ git push


### Librarian-puppet

References:

* [GitHub: rodjek / librarian-puppet](https://github.com/rodjek/librarian-puppet)

Much of a typical Puppet deployment's configuration actually comes from modules, such as those from [Puppet Forge](https://forge.puppetlabs.com/). As each of these modules typically have their own Git repositories, version controlling them locally is a bad idea. Far better to use [Librarian-puppet](https://github.com/rodjek/librarian-puppet) and let it track what version from Puppet Forge is being used or to handle cloning the remote repositories being tracked. It's actually a pretty fantastic tool.

It can be installed and initialized as follows:

    $ sudo apt-get install rubygems
    $ sudo gem install librarian-puppet
    $ sudo librarian-puppet init
    $ git add -A
    $ git commit -m "Initialized Librarian-puppet."

See the reference link above for instructions on how to use Librarian-puppet now that it's ready.


## Puppet Master Configuration

The rest of the Puppet configuration from here on out is covered in the actual commits to the repository: <https://github.com/karlmdavis/justdavis-puppet>.

## Puppet Agent/Client Setup

Installation and initial configuration of Puppet agents/clients is covered in <%= topic_link("/it/davis/misc/puppet-agent/") %>.

