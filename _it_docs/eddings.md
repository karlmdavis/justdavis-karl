---
title: "Eddings"
layout: it_doc
group: servers
description: Describes the setup and configuration of eddings, my main server.
---

`eddings` is the primary server for `justdavis.com`. It hosts hosts the following services: DNS, Kerberos, LDAP, OpenAFS, a Zimbra mail server, and a KVM virtual machine host. This page documents everything done to get all of that up, running, and configured.


## Specs

`eddings` is an older server-class physical machine. Most of the parts were purchased from Newegg in 2014-08. (Note: Had to replace the motherboard due to a lightning strike in 2017-08. Upgraded the disk and power supply at this time.)

* CPU
    * [Intel Xeon E5-2630 v2 Ivy Bridge-EP 2.6 GHz 15MB L3 Cache LGA 2011 80W BX80635E52630V2 Server Processor](https://www.newegg.com/Product/Product.aspx?Item=N82E16819116933)
* Motherboard
    * [SUPERMICRO MBD-X9DRI-F-O Extended ATX Server Motherboard Dual LGA 2011 DDR3 1600](https://www.newegg.com/Product/Product.aspx?Item=N82E16813182349)
* RAM
    * 32 GB
* Disks
    * [Samsung 850 EVO 1TB 2.5-Inch SATA III Internal SSD (MZ-75E1T0B/AM)](https://www.amazon.com/gp/product/B00OBRFFAS/ref=oh_aui_detailpage_o03_s00?ie=UTF8&psc=1)
* Power
    * [EVGA SuperNOVA 750 P2, 80+ PLATINUM 750W, Power Supply 220-P2-0750-X1](https://www.amazon.com/gp/product/B010HWDP48/ref=oh_aui_detailpage_o01_s00?ie=UTF8&psc=1)
    * [CyberPower CP1500PFCLCD PFC Sinewave UPS 1500VA 900W PFC Compatible Mini-Tower](https://www.amazon.com/gp/product/B00429N19W/ref=oh_aui_detailpage_o01_s00?ie=UTF8&psc=1)


## Setup

The content on this page covers the base OS install and configuration; it doesn't cover configuration of any of the main services hosted by the machine.

Those services are either covered in the following (older) sub-guides for details on those:

{% assign sub_docs = site.it_docs | where:"parent","/it/eddings" | sort:"date" %}{% for sub_doc in sub_docs %}* {% collection_doc_link_long {{sub_doc.id}} baseurl:true %}
{% endfor %}

Or the services' configuration is handled by the Ansible playbooks mentioned below. Most all of the configuration is being transitioned to the Ansible playbooks; the above sub-guides haven't yet been updated to reflect that.


### Install 64bit Ubuntu 16.04.03 (Xenial), Server Edition


#### Installation Media

Acquire and prepare the installer:

1. Download the installer `ubuntu-16.04.3-server-amd64.iso` file at [Download Ubuntu Server](http://www.ubuntu.com/download/server/download).
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
1. Country of origin for the keyboard: **English (US)**
1. Keyboard layout: **English (US)**
1. Primary network interface: **enp2s0f1**
    * This corresponds to the motherboard's bottom NIC, which I had connected to the home office LAN. Much safer than a public IP, until everything is configured and secured.
1. Hostname: `eddings`
1. Full name for the new user: `Local User`
    * We're not using an actual person name here as the machine will (eventually) be set to use Kerberos for authentication.
1. Username for your account: `localuser`
1. Choose a password for the new user: (create a password)
    * As this won't be used much once Kerberos has been configured, I recommend using a long randomly-generated password.
    * Be sure to write this down in a safe place!
1. Encrypt your home directory?: **No**
    * No need to, as the disk itself is already encrypted.
1. Is this time zone correct?: **Yes**
    * For me, it was `America/New_York`. If it didn't auto-detect correctly, you'll need to change it.
1. Partitioning method: **Guided - use entire disk and set up encrypted LVM**
1. Disk to partition: **SCSI2 (0,0,0) (sda) - 1.0 TB ATA Samsung SSD 850**
1. Write the changes to disks and configure LVM?: **Yes**
1. Encryption passphrase: (create a password)
    * Be sure to write this down in a safe place!
1. Amount of volume group to use for guided partitioning: `max`
1. Write the changes to disks?: **Yes**
1. HTTP proxy information: (leave blank)
1. How do you want to manage upgrades on this system?: **Install security updates automatically**
1. Choose software to install: **standard system utilities**
    * Generally, I'm not a fan of using these package groups, but the stuff in this one is just basic.
1. Install the GRUB boot loader to the master boot record?: **Yes**
1. Device for boot loader installation: **/dev/sda**

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


### Removing Separate Boot Partition

References:

* [Encrypting More: /boot Joins The Party](https://dustymabe.com/2015/07/06/encrypting-more-boot-joins-the-party/)
    * Provides the instructions used to switch from using the `/boot` partition (though doesn't cover how to remove it afterwards).
* [Linux Mint encryption](http://www.pavelkogan.com/2015/01/25/linux-mint-encryption/)
    * Describes how to avoid having to enter the encryption passphrase twice at every boot.

Ubuntu 16.04's full-disk encryption setup insists on creating a separate (unencrypted) `/boot` partition. Way back when, this was necessary because GRUB didn't support encryption itself. Now it does, however, and painful experience has shown that having a separate `/boot` partition causes problems. Specifically, it's not sized large enough to ensure that it won't run out of space, eventually causing updates to fail.

The first step here is to copy the current `/boot` partition into a `/boot` directory on the root partition:

```
$ sudo mkdir /mnt/root-bind && sudo mount --bind / /mnt/root-bind
$ sudo cp --archive --no-target-directory /boot /mnt/root-bind/boot
$ sudo diff -ur /boot /mnt/root-bind/boot  # Check output of this to verify that no differences are found.
$ sudo umount /mnt/root-bind && sudo rmdir /mnt/root-bind
```

Next, unmount the `/boot` partition and prevent it from being automatically mounted in the future:

```
$ sudo umount /boot 
$ sudo cp -a /etc/fstab /etc/fstab.backup-before-removing-boot && sudo sed -i -e '/\/boot/d' /etc/fstab
```

Next, configure GRUB to load the `cryptodisk` module:

```
$ echo 'insmod cryptodisk' | sudo tee --append /etc/grub.d/40_custom
$ echo 'GRUB_ENABLE_CRYPTODISK=y' | sudo tee --append /etc/default/grub
$ sudo update-grub
$ sudo grub-install /dev/sda
```

At this point, you can reboot the system and—even though it's still present—boot without using the `/boot` partition. The boot process will prompt for the disk encryption passphrase twice: once for GRUB and once for the rest of the system. If that bothers you, this article presents a relatively simple method for fixing it: [Linux Mint encryption](http://www.pavelkogan.com/2015/01/25/linux-mint-encryption/). I didn't apply it to `eddings`, though, as 1) the issue doesn't bother me, and 2) I'm not 100% comfortable with adding the extra keyfile to main memory.

You should also note that this leaves the `/boot` partition there. It's not being used and isn't ever mounted, but it's there. To resolve that, the system would have to be booted from a live CD and adjusted there. A combo of GParted and this article would likely do the trick: [Ubuntu Wiki: ResizeEncryptedPartitions](https://help.ubuntu.com/community/ResizeEncryptedPartitions).


### Configuration via Ansible

The configuration for this server is managed by ansible using these Ansible plays: [justdavis-ansible](https://github.com/karlmdavis/justdavis-ansible). The first run of Ansible was done with the server still only connected to the private LAN (using `en2ps0f1`, the motherboard's bottom ethernet port). This prevents the not-yet-secured server from becoming a target of internet attacks.

SSH was installed:

    $ sudo apt-get install openssh-server

The `localuser` account was given permission to run `sudo` without having to enter a password every time. An editor was started like this:

    $ sudo visudo --file=/etc/sudoers.d/localuser

And the new file was given the following contents:

    # Allow the `localuser` account sudo access without requiring a password.
    localuser ALL=(ALL) NOPASSWD:ALL

The current private LAN IP address was discovered by running `ifconfig`.

On a separate system on the same LAN, the [justdavis-ansible](https://github.com/karlmdavis/justdavis-ansible) project was cloned. The development/runtime environment was configured per that project's `README.md`.

The `hosts` file was edited to specify a temporary static `ansible_host` (replacing `<eddings_private_ip>` with the IP discovered a bit ago):

    eddings ansible_user=localuser ansible_host=<eddings_private_ip> ansible_python_interpreter=/usr/bin/python2.7 public_ip=96.86.32.137

My SSH key was given access to the `localuser` account:

    $ ssh-copy-id -i ~/.ssh/id_rsa.pub localuser@<eddings_private_ip>

The Ansible plays were then run:

    $ ansible-playbook site.yml


