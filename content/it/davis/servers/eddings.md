--- 
title: Eddings
kind: topic
summary: "Describes the setup of eddings, the primary server for justdavis.com. This server hosts the following services: DNS, Kerberos, LDAP, OpenAFS, a Zimbra mail server, and a KVM virtual machine host."
---

# <%= @item[:title] %>

`eddings` is the primary server for `justdavis.com`. It hosts hosts the following services: DNS, Kerberos, LDAP, OpenAFS, a Zimbra mail server, and a KVM virtual machine host. This page documents everything done to get all of that up, running, and configured.


## Specs

* `eddings` is an older server-class physical machine. Most of the parts were purchased in October, 2007.
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

Please see the following sub-guides:

* <%= topic_summary_link("/it/davis/servers/eddings/vms/") %>


### 64bit Ubuntu 10.04.03 (Lucid), Server Edition


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
    * We're not using an actual person name here as the machine will (eventually) be set to use Kerberos for authentication. See <%= topic_link("/it/davis/servers/eddings/kerberos/") for details.
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

