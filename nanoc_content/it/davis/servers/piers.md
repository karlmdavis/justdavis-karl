--- 
title: Piers
kind: topic
summary: "Describes the setup of piers, the Zimbra email server for justdavis.com."
---

# <%= @item[:title] %>

`piers` is the email server for `justdavis.com` and other domains. It uses the open source [Zimbra Collaboration Suite](http://www.zimbra.com/products/zimbra-open-source.html) to provide all of the email services. This page documents everything done to get all of that up, running, and configured.

Please note that this documentation covers the "second life" of `piers`: the first `piers` was a 32-bit Ubuntu 8.04 VM. The machine had to be rebuilt from scratch, as it was time to move to a 64-bit OS: the latest Zimbra versions (e.g. 8.0) no longer support 32-bit Ubuntu releases.


## Specs

`piers` is a virtual machine hosted on <%= topic_summary_link("/it/davis/servers/eddings/") %>. It was configured with the following virtual hardware:

* CPU
    * 2 virtual CPUs
* RAM
    * 2GB
* Disks
    * 1 40GB disk image


## Setup

The content on this page covers the base OS install and configuration; it doesn't cover configuration of any of the main services hosted by the machine. Please see the following sub-guides for details on those:

* <%= topic_summary_link("/it/davis/misc/netclients/") %>
* <%= topic_summary_link("/it/davis/misc/tmux/") %>
* <%= topic_summary_link("/it/davis/servers/piers/zimbra/") %>
* <%= topic_summary_link("/it/davis/servers/piers/spideroak/") %>


### Rename Old piers VM

In order to migrate the Zimbra data from the "old" `piers` to the "new" `piers`, both VMs will need to be hosted on `eddings` temporarily. To make things easier, the old VM should first be renamed to `piers-old`.

First, log in to the old `piers` and turn it off (`sudo poweroff`). Then, dump its definition to a file and remove the VM:

    $ sudo virsh dumpxml piers > piers-old.xml
    $ sudo virsh undefine piers

Rename the disk image file:

    $ sudo mv /var/lib/libvirt/images/piers.qcow2 /var/lib/libvirt/images/piers-old.qcow2

Edit the `piers-old.xml` file, changing the name to "`piers-old`" in the `/domain/name` element and the disk image path in the `/domain/devices/disk/source` element. Once that's complete, recreate the VM with the new name and start it:

    $ sudo virsh define piers-old.xml
    $ sudo virsh start piers-old

A new `piers` VM can now be created without worrying about VM name or disk path conflicts.


### Create Virtual Machine

References:

* [JeOS and vmbuilder](https://help.ubuntu.com/12.04/serverguide/jeos-and-vmbuilder.html)

As mentioned above, `piers` will be hosted as a VM on <%= topic_summary_link("/it/davis/servers/eddings/") %>. The VM should be created using Ubuntu's `vmbuilder` tool. Install that tool:

    $ sudo apt-get install python-vm-builder

Then, use the `vmbuilder` tool to create the new virtual machine. Run `vmbuilder kvm ubuntu --help` for all options, but the following is what was used for `piers` (be sure to modify the password):

    $ sudo vmbuilder kvm ubuntu --suite=lucid --flavour=virtual --hostname=piers --domain=justdavis.com --user=localuser --name="Local User" --pass="SuperSecretPassword" --cpus=2 --arch=amd64 --mem=2048 --rootsize=40960 --bridge=br0 --ip=174.79.40.35 --mask=255.255.255.240 --gw=174.79.40.33 --dns=174.79.40.37 --libvirt=qemu:///system

**Troubleshooting Note:** Unless/until [Bug #966439](https://bugs.launchpad.net/vmbuilder/+bug/966439) has been resolved, be sure to add a `--removepkg=cron` option to the above `vmbuilder` command. After the VM has been created, install `cron` manually by running the following on the VM:

    $ sudo apt-get install cron

**Note on Ubuntu Version:** The above command selects `lucid` as the `suite` to be used, which corresponds to Ubuntu 10.04, rather than 12.04 (which is available at the time of this writing). This older version is required due to the migration of Zimbra from the old `piers` to the new one that will be performed: both machines have to be running the same Zimbra release and the only one that they can both run does not support Ubuntu 12.04. Accordingly, the new `piers` will have to start off its life on Ubuntu 10.04, and be upgraded to 12.04 after the Zimbra migration has been completed.

That command will take about fifteen minutes to complete. Once it's done, the disk image should be converted to the new [QED](http://wiki.qemu.org/Features/QED) format, which []() offers [much better performance than the default QCOW2 format](http://wiki.qemu.org/Qcow2/PerformanceRoadmap#Benchmark_results). To do so, use `virsh dumpxml` to determine the current image location, use `qemu-img` to convert the file, and then use `virsh edit` to modify the location in the guest definition file and change the `<driver/>` element's `type` attribute from `qcow2` to `qed`:

    $ sudo virsh dumpxml piers|grep "source file"
    $ sudo qemu-img convert -O qed /home/karl/ubuntu-kvm/tmpmh79CC.qcow2 /var/lib/libvirt/images/piers.qed
    $ sudo virsh edit piers
    $ sudo rm -rf /home/karl/ubuntu-kvm/

Start the new domain:

    $ sudo virsh start piers

On a separate workstation (one with a graphical shell), the `virt-viewer` application can be used to view the VMs' consoles:

    $ sudo apt-get install virt-viewer
    $ virt-viewer --connect qemu+ssh://localuser@192.168.1.100/system --wait --reconnect piers


### First Boot

Before doing anything else, run the following commands:

    $ sudo apt-get update
    $ sudo apt-get upgrade
    $ sudo apt-get dist-upgrade

This will update the installed versions of the libraries and applications installed on the system. This is important as there may be security vulnerabilities and other bugs in the version of libraries and applications included with the installer, that there are patches available to fix them. It's especially important to do this before enabling SSH!

Once the patches are installed, you'll want to reboot the server to ensure the latest kernel available is being used. Please note that this is only necessary if kernel updates were applied:

    $ sudo reboot

**Troubleshooting Note:** If the virtual machine is supposed to be using a public IP but has no connectivity, the problem could be caused by the ISP's ARP tables. I've had this problem with Cox: just have to call in and have them flush the cable modem's ARP tables.


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

You can then close the local server console and just use the SSH connection, instead.


### Keeping the Clock Synchronized

References:

* <https://help.ubuntu.com/8.04/serverguide/C/NTP.html>

A number of network services, e.g. Kerberos, rely on the server having the correct time. The `ntpd` service can be installed to periodically correct any "clock drift":

    $ sudo apt-get install ntp


### Setting the FQDN

References:

* <http://ubuntuforums.org/showthread.php?t=1467978>

A number of services such as Kerberos rely on each machine having a valid fully qualified domain name. In this server's case, that should be `eddings.justdavis.com`. To ensure this is the case, two files have to be setup correctly:

1. `/etc/hostname`: This file should have the non-qualified hostname.
1. `/etc/hosts`: This file should have the fully qualified hostname, as well as the non-qualified hostname as an alias assigned to `127.0.0.1`.

Specifically, the first two entries in `/etc/hosts` should read as follows:

~~~~
127.0.0.1       localhost
127.0.1.1       piers.justdavis.com   piers
~~~~

The hostname configuration can be tested with the `hostname` command. The first command should return the unqualified name and the second command should return the fully qualified name:

    $ hostname
    $ hostname -f


### Installing Basic Utilities

References:

* [Ask Ubuntu: How do I enable automatic updates?](http://askubuntu.com/questions/9/how-do-i-enable-automatic-updates)

The JeOS Ubuntu installs are stripped-down by default, which helps reduce the resources required to run VMs. However, some of the stuff that was stripped out will be needed for `piers`, and should be installed as follows:

    $ sudo apt-get install nano man ufw locate command-not-found


### Configuring Timezone

By default, the server will be set to use the UTC timezone. Change it to the correct one:

    $ sudo dpkg-reconfigure tzdata


### Configuring Automatic Upgrades

Ensure security and bugfix updates are applied automatically when available:

    $ sudo apt-get install unattended-upgrades
    $ sudo dpkg-reconfigure unattended-upgrades

When prompted, answer the questions as follows:

* *Automatically download and install stable updates?* **Yes**


## Upgrading to Ubuntu 12.04

Due to the requirements of the Zimbra migration process (as described in <%= topic_link("/it/davis/servers/piers/zimbra/") %>), this machine had to start off on 64-bit Ubuntu 10.04, even though 12.04.1 had already been released by then.

Once the Zimbra migration has been completed, though, the machine can and should be upgraded to Ubuntu 12.04. Before proceeding with this upgrade, though, power down the virtual machine and backup the disk image on `eddings` (the VM host), as follows:

    $ sudo virsh shutdown piers
    $ sudo cp /var/lib/libvirt/images/piers.qed /var/lib/libvirt/images/piers-beforeOsUpgrade-2012-10-18.qed
    $ sudo virsh start piers

Once the backup is in place, log back in to `piers` as `localuser`, stop and disable Zimbra, and begin the upgrade (inside a `tmux` session, to prevent disconnects from breaking the upgrade):

    $ sudo -i -u zimbra zmcontrol stop
    $ sudo mv /etc/init.d/zimbra ~/disabled-init-d-zimbra
    $ tmux
    $ sudo apt-get install update-manager-core
    $ sudo do-release-upgrade

When prompted, select the following options:

* Something about deleting `sysstat` data: **Yes**
* Restart services during package upgrades without asking? **Yes**

You will receive warnings that a number of configuration files have new versions, but been modified since installation. For all of these files, the safest option is to overwrite the changes with the new version, as it's best to just manually re-create those changes after the upgrade has finished. The following is a list of the files such warnings were received for on the 2012-10-13 upgrade of `eddings`:

* `/etc/security/group.conf`
    * See <%= topic_link("/it/davis/misc/netclients/") %> after the upgrade to re-do the changes.
* `/etc/ldap/ldap.conf`
    * See <%= topic_link("/it/davis/misc/netclients/") %> after the upgrade to re-do the changes.
* `/etc/pam.d/common-*`
    * See <%= topic_link("/it/davis/misc/netclients/") %> after the upgrade to re-do the changes: specifically, the section on using `auth-client-config`.
* `/etc/pam.d/login`
    * See <%= topic_link("/it/davis/misc/netclients/") %> after the upgrade to re-do the changes: specifically, the section on using `auth-client-config`.
* `/etc/sudoers`
    * See <%= topic_link("/it/davis/misc/netclients/") %> after the upgrade to re-do the changes.
* `/etc/default/ufw`
    * See <%= topic_link("/it/davis/servers/piers/zimbra/") %> after the upgrade to re-do the changes.
* `/etc/rsyslog.d/50-default.conf`
    * I have no clue what modified this file. My guess is that the changes are either an artifact from the JeOS install or were made by the Zimbra installer. If it was Zimbra, the upgrade to Zimbra 8.0 should fix it.

Once the upgrade has completed, it's strongly recommended that the server be restarted. Once restarted, log back in with a non-LDAP/Kerberos account (e.g. `localuser`), and fix up all of the configuration files that were overwritten during the upgrade.

