--- 
title: Eddings
kind: topic
summary: "Describes the setup of eddings, the primary server for justdavis.com. This server hosts the following services: DNS, Kerberos, LDAP, OpenAFS, a Zimbra mail server, and a KVM virtual machine host."
---

# <%= @item[:title] %>

`eddings` is the primary server for `justdavis.com`. It hosts hosts the following services: DNS, Kerberos, LDAP, OpenAFS, a Zimbra mail server, and a KVM virtual machine host. This page documents everything done to get all of that up, running, and configured.


## Specs

`eddings` is an older server-class physical machine. Most of the parts were purchased in October, 2007.

* CPU
    * [Intel Xeon E5310 Clovertown 1.6GHz LGA 771 80W Quad-Core](http://www.newegg.com/Product/Product.aspx?Item=N82E16819117113)
* Motherboard
    * [ASUS DSBV-D SSI CEB 1.1 Server Motherboard Dual LGA 771](http://www.newegg.com/Product/Product.aspx?Item=N82E16813131152)
* RAM
    * 4GB
* Disks
    * 1 TB hard drive
    * [LITE-ON Black DVD burner](http://www.newegg.com/Product/Product.aspx?Item=N82E16827106055)
* Power
    * Antec TruePower TP3-650 650W power supply
    * [CyberPower CP1500AVRLCD 1500VA 900W UPS](http://www.newegg.com/Product/Product.aspx?Item=N82E16842102048)


## Setup

The content on this page covers the base OS install and configuration; it doesn't cover configuration of any of the main services hosted by the machine. Please see the following sub-guides for details on those:

* <%= topic_summary_link("/it/davis/servers/eddings/vms/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/dns/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/kerberos/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/ldap/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/openafs/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/web/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/tomcat/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/nexus/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/jenkins/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/spideroak/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/nagios/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/puppet/") %>
* <%= topic_summary_link("/it/davis/servers/eddings/sonarqube/") %>


### Install 64bit Ubuntu 10.04.03 (Lucid), Server Edition


#### Installation Media

Acquire and prepare the installer:

1. Download the installer `ubuntu-10.04.3-server-amd64.iso` file at [Download Ubuntu Server](http://www.ubuntu.com/download/server/download).
1. Follow the "Burn your CD or create a bootable USB stick" instructions on that page to create a bootable flash drive from the `.iso`.


#### Installation

Boot from the flash drive created earlier (press `F8` at the POST screen).

You may receive the following error when booting from the flash drive:

    Unknown keyword in configuration file: gfxboot
    vesamenu.c32: not a COM32R image

To get around this, type `help` at the prompt and then press `ENTER` to start the installer.

Select the following options to proceed through the install:

1. Choose a language: **English**
1. Choose a country, territory, or area: **United States**
1. Detect keyboard layout?: **No**
1. Origin of the keyboard: **USA**
1. Keyboard layout: **USA**
1. Primary network interface: **eth1**
    * I had disconnected `eth0` for the installation, as it's used as my "public" network connection. `eth1` is behind a NAT and firewall, making it the safer choice until everything is configured correctly.
1. Hostname: `eddings`
1. Is this time zone correct?: **Yes**
    * For me, it was `America/Phoenix`. If it didn't auto-detect correctly, you'll need to change it.
1. Partitioning method: **Guided - use entire disk and set up encrypted LVM**
1. Disk to partition: **SCSI3 (0,1,0) (sda) - 750.2 GB ATA WDC ...**
    * This was not actually the server's "normal" primary disk. Instead, I installed to an alternate disk I had lying around, copied things over from the previous install on the primary disk, cloned the disks, and switched them out. See TODO for details.
1. Write the changes to disks and configure LVM?: **Yes**
1. Encryption passphrase: (create a password)
    * Be sure to write this down in a safe place!
1. Amount of volume group to use for guided partitioning: `max`
1. Write the changes to disks?: **Yes**
1. Full name for the new user: `Local User`
    * We're not using an actual person name here as the machine will (eventually) be set to use Kerberos for authentication.
1. Username for your account: `localuser`
1. Choose a password for the new user: (create a password)
    * As this won't be used much once Kerberos has been configured, I recommend using a long randomly-generated password.
    * Be sure to write this down in a safe place!
1. Encrypt your home directory?: **No**
    * No need to, as the disk itself is already encrypted.
1. HTTP proxy information: (leave blank)
1. How do you want to manage upgrades on this system?: **Install security updates automatically**
1. Choose software to install: (leave this blank; we'll install things later)
    * I've used this feature in the past, and it works just fine to install things. I've noticed, though, that it makes documentation more difficult, e.g. what actual packages does "Mail server" correspond to?
1. Install the GRUB boot loader to the master boot record?: **Yes**

At the *Installation Complete* screen, select **Continue**. Remove the USB flash drive and allow the computer to reboot onto the newly-installed OS.


### First Boot

When prompted for the encryption passphrase, enter the one you set (and wrote down) earlier. Then, login with the `localuser` account and the password you created for it.

Before doing anything else, run the following commands:

    $ sudo apt-get update
    $ sudo apt-get upgrade
    $ sudo apt-get dist-upgrade

This will update the installed versions of the libraries and applications installed on the system. This is important as there may be security vulnerabilities and other bugs in the version of libraries and applications included with the installer, that there are patches available to fix them. It's especially important to do this before enabling SSH!

Once the patches are installed, you'll want to reboot the server to ensure the latest kernel available is being used. Please note that this is only necessary if kernel updates were applied:

    $ sudo reboot


### Connecting via SSH

Before installing an SSH server, we're going to turn on [fail2ban](https://help.ubuntu.com/community/Fail2Ban), a service that will automatically blacklist any IP addresses that attempt to login over SSH after a certain number of failed attempts. This will make brute force attacks against your SSH server much more difficult. Install fail2ban by running the following command:

    $ sudo apt-get install fail2ban

Install the OpenSSH server by running the following command:

    $ sudo apt-get install openssh-server openssh-blacklist openssh-blacklist-extra

Run the following command to determine what the system's IP address is:

    $ ifconfig

If that command's output scrolls off the screen you can pipe it through `less`, use the up/down arrow keys to scroll, and press the `q` key to quit:

    $ ifconfig | less

Look for the `inet addr` entry, which will be the system's IP address. On my system, it was `192.168.1.100`. Please note that `127.0.0.1` is not what you're looking for: it's the default [loopback address](http://en.wikipedia.org/wiki/Loopback) and cannot be used remotely.

After the network connection has been setup, you should be able to connect to the computer from other hosts via the following SSH command (substituting the correct IP address):

    $ ssh localuser@192.168.1.100

Once you've connected via SSH, log out of the local server console by running the following command:

    $ exit


### Keeping the Clock Synchronized

References:

* <https://help.ubuntu.com/8.04/serverguide/C/NTP.html>

A number of network services, e.g. Kerberos, rely on the server having the correct time. The `ntpd` service can be installed to periodically correct any "clock drift":

    # apt-get install ntp


### Setting the FQDN

References:

* <http://ubuntuforums.org/showthread.php?t=1467978>

A number of services such as Kerberos rely on each machine having a valid fully qualified domain name. In this server's case, that should be `eddings.justdavis.com`. To ensure this is the case, two files have to be setup correctly:

1. `/etc/hostname`: This file should have the non-qualified hostname.
1. `/etc/hosts`: This file should have the fully qualified hostname, as well as the non-qualified hostname as an alias assigned to `127.0.0.1`.

Specifically, the first two entries in `/etc/hosts` should read as follows:

~~~~
127.0.0.1       localhost
127.0.1.1       eddings.justdavis.com   eddings
~~~~

The hostname configuration can be tested with the `hostname` command. The first command should return the unqualified name and the second command should return the fully qualified name:

    $ hostname
    $ hostname -f


### Configuring Networking (and Decommissioning VMs)

Initially, `eddings` was configured to have one private IP on `eth1` and use `eth0` as only a bridging interface: no IP was assigned to it at all. This configuration is detailed in <%= topic_summary_link("/it/davis/servers/eddings/vms/") %>. This lack of public IP on `eth0` was primarily due to the limited number of public IPs I had available (4); it would have been convenient for `eddings` itself to have a public IP.

As the virtual machines hosted by `eddings` were decommissioned, e.g. `tolkien`'s web services being migrated to `eddings` in <%= topic_link("/it/davis/servers/eddings/web/") %> and <%= topic_link("/it/davis/servers/eddings/nexus/") %>, those public IPs became available for `eddings` to use.

First, the VM was shutdown and set to not boot automatically. For example, these commands were used to disable `tolkien`:

    $ sudo virsh --connect qemu:///system shutdown tolkien
    $ sudo virsh --connect qemu:///system autostart --disable tolkien

Then, the configuration for `eth0` in `/etc/network/interfaces` was updated. For example, here's the configuration after decommisioning `tolkien` and assigning its public IP to `eddings`:

~~~~
# The public network's interface
auto eth0
iface eth0 inet manual

# The bridge used by libvirt guests, runs on eth0 (the public network)
auto br0
iface br0 inet static
	address 174.79.40.37
	netmask 255.255.255.240
	gateway 174.79.40.33
	bridge_ports eth0
	bridge_stp off
	bridge_fd 0
	bridge_maxwait 0
~~~~

Some applications, notably Zimbra and OpenAFS also expect `/etc/hosts` resolution to have been configured correctly for the public IP and FQDN. See the following link for a discussion of this change: <https://lists.ubuntu.com/archives/foundations-bugs/2011-July/011275.html>. To that end, edit the `/etc/hosts` file and make the following changes:

* Comment out or delete the "`127.0.1.1`" line.
* Add the following line:

~~~~
174.79.40.37    eddings.justdavis.com   eddings
~~~~

After modifying `/etc/network/interfaces`, the following had to be done to restart networking, and bring the remaining VMs back up afterwards:

    $ sudo virsh --connect qemu:///system shutdown piers
    $ sudo virsh --connect qemu:///system shutdown asimov
    $ sudo virsh --connect qemu:///system shutdown lewis
    $ sudo /etc/init.d/networking restart
    $ sudo virsh --connect qemu:///system net-destroy default
    $ sudo virsh --connect qemu:///system net-start default
    $ sudo virsh --connect qemu:///system start lewis
    $ sudo virsh --connect qemu:///system start asimov
    $ sudo virsh --connect qemu:///system start piers


### Upgrade to 64bit Ubuntu 12.04.1 (Precise), Server Edition

Ubuntu 12.04 was released in April of 2012. The first point release, 12.04.1, was released in August of 2012.

**Please note:** I intended to perform this upgrade (as described below) on 2012-05-11. However, I discovered that this is against recommended practice: it is recommended that users wait for the first point release (12.04.1, in this case) before upgrading from LTS to LTS. See the following links for more information:

* [Why is “No new release found” when upgrading 10.04 to 12.04 LTS?](http://askubuntu.com/questions/125392/why-is-no-new-release-found-when-upgrading-10-04-to-12-04-lts)
* [Upgrading LTS to LTS (server) — why wait for the first point release?](http://askubuntu.com/questions/125825/upgrading-lts-to-lts-server-why-wait-for-the-first-point-release)

The `eddings` server was upgraded in October of 2012 to that new [LTS](https://wiki.ubuntu.com/LTS) release.

First, I connected to the server over SSH, using a local account (rather than an LDAP/Kerberos one):

    $ ssh localuser@192.168.1.100

Before running the OS upgrade, I installed all of the updates available for the current release:

    $ sudo apt-get update
    $ sudo apt-get dist-upgrade

Then, I shutdown all of the virtual machines being hosted:

    $ sudo virsh --connect qemu:///system shutdown tolkien
    $ sudo virsh --connect qemu:///system shutdown piers
    $ sudo virsh --connect qemu:///system shutdown asimov
    $ sudo virsh --connect qemu:///system shutdown lewis

I then restarted the server to ensure everything came back up correctly:

    $ sudo reboot

The actual upgrade is quite simple to start:

    $ sudo do-release-upgrade

When prompted, select the following options:

* Restart services during package upgrades without asking? **Yes**

You will receive warnings that a number of configuration files have new versions, but been modified since installation. For all of these files, the safest option is to overwrite the changes with the new version, as it's best to just manually re-create those changes after the upgrade has finished. The following is a list of the files such warnings were received for on the 2012-10-13 upgrade of `eddings`:

* `/etc/security/group.conf`
    * See <%= topic_link("/it/davis/misc/netclients/") %> after the upgrade to re-do the changes.
* `/etc/ldap/ldap.conf`
    * See <%= topic_link("/it/davis/misc/netclients/") %> after the upgrade to re-do the changes.
* `/etc/apparmor.d/usr.sbin.slapd`
    * See <%= topic_link("/it/davis/servers/eddings/ldap/") %> after the upgrade to re-do the changes.
* `/etc/default/slapd`
    * See <%= topic_link("/it/davis/servers/eddings/ldap/") %> after the upgrade to re-do the changes.
* `/etc/pam.d/common-*`
    * See <%= topic_link("/it/davis/misc/netclients/") %> after the upgrade to re-do the changes: specifically, the section on using `auth-client-config`.
* `/etc/pam.d/login`
    * See <%= topic_link("/it/davis/misc/netclients/") %> after the upgrade to re-do the changes: specifically, the section on using `auth-client-config`.
* `/etc/sudoers`
    * See <%= topic_link("/it/davis/misc/netclients/") %> after the upgrade to re-do the changes.
* `/etc/default/saslauthd`
    * See <%= topic_link("/it/davis/servers/eddings/ldap/") %> after the upgrade to re-do the changes.
* `/etc/msmtprc`?
    * See <%= topic_link("/it/davis/servers/eddings/spideroak/") %> after the upgrade to re-do the changes.
* `/etc/default/jetty`
    * See <%= topic_link("/it/davis/servers/eddings/nexus/") %> after the upgrade to re-do the changes.

Once the upgrade has completed, it's strongly recommended that the server be restarted. Once restarted, log back in with a non-LDAP/Kerberos account (e.g. `localuser`), and fix up all of the configuration files that were overwritten during the upgrade.

If OpenJDK was installed before the upgrade, it will also need to be reinstalled:

    $ sudo apt-get install openjdk-7-jdk


### Changing IP Addresses for FiOS

When my internet connection changed to FiOS (as part of our move to the Baltimore area), the following had to be done to update various bits & bobs on `eddings` to cope with that:

1. Update the `/etc/bind/db.*` DNS DBs.
2. Update the `/etc/network/interfaces` file.
3. Update the `/etc/hosts` file.
4. Update OpenAFS (from `eddings`):

       $ kdestroy
       $ kinit karl/admin
       $ aklog
       $ bos removehost -server eddings.justdavis.com -host eddings.justdavis.com
       $ bos addhost -server eddings.justdavis.com -host eddings.justdavis.com
       $ sudo service openafs-fileserver restart

