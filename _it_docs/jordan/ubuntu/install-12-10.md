---
title: Install Ubuntu 12.10
parent: /it/jordan
layout: it_doc
description: Describes the installation of Ubuntu 12.10 on jordan-u.
---

This {% collection_doc_link /it/jordan baseurl:true %} sub-guide descibes the installation of Ubuntu 12.10 on `jordan-u`.

`jordan-u` is the Ubuntu Linux install on {% collection_doc_link /it/jordan baseurl:true %}, Karl's primary workstation. This install is stored on the system's primary drive: a 256 GB SSD.

Installation of Ubuntu is covered in the following sub-sections.


## Selecting an Ubuntu Version

References:

* [Privacy in Ubuntu 12.10: Full Disk Encryption](https://www.eff.org/deeplinks/2012/11/privacy-ubuntu-1210-full-disk-encryption)

Before starting the install, a decision on which version of Ubuntu to install needs to be made. For Ubuntu, there are generally two options: Long Term Support (LTS) or latest. Whenever possible, I always prefer the LTS release. However, I seem to have a lot of trouble sticking with that choice: almost every system I manage (other than my server) has ended up being upgraded from the LTS for one reason or other.

For this system, `jordan-u`, I opted for the latest release available: 12.10. The reason for this selection was that 12.10 is the first Ubuntu install to provide full disk encryption and LVM options in the installer. While home folder encryption is probably sufficient for my needs (this functionality is available in the 12.04 LTS installer), having LVM configured will likely prove useful on this system.


## Creating an Ubuntu Install Disk

References:

* [How to create a bootable USB stick](http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-windows)

In order to install Ubuntu, a bootable DVD or USB drive needs to be imaged. For this system, a USB drive was used. The [How to create a bootable USB stick](http://www.ubuntu.com/download/help/create-a-usb-stick-on-windows) wiki page explains how to create such a drive. From Windows, it's as simple as downloading and using the [Universal USB Installer ](http://www.pendrivelinux.com/universal-usb-installer-easy-as-1-2-3/), which can even download the appropriate ISO image file (`ubuntu-12.10-desktop-amd64.iso`).


## Setting BIOS Options

Before starting the Ubuntu installation, some of the system's BIOS options should be configured. Enter the BIOS Setup Utility by pressing the thin rectangular button at the top of the ThinkPad keyboard right after powering on the system. When prompted, press the `F1` key to enter the BIOS Setup Utility.

Make the following configuration changes:

* Config
    * Display
        * Boot Display Device: **Digital 1 on dock**
        * Graphics Device: **Discrete Graphics**
        * OS Detection for NVIDIA Optimus: **Disabled**
* Security
    * Virtualization
        * Intel (R) Virtualization Technology: **Enabled**
        * Intel (R) VT-d Feature: **Enabled**
* Restart
    * Exit Saving Changes: **Yes**

Please note that I was able to leave both Secure Boot and Rapid Restart enabled, though I haven't bothered to make the partitioning changes required for Rapid Restart to work.


## Installing Ubuntu

References:

* [Install Ubuntu 12.10](http://www.ubuntu.com/download/desktop/install-desktop-latest)

Once the bootable drive has been created, boot off of it. On my ThinkPad W530, this was accomplished by pressing `F12` while the computer was booting to select the boot drive. At the "GNU Grub" boot menu, select *Try Ubuntu without installing* using the arrow keys and `Enter`. The system will boot into the Ubuntu live/demo environment.

Start the installation process by double-clicking the *Install Ubuntu 12.10* icon on the desktop. Proceed through the installation as follows:

1. On the *Welcome* screen, select **English** as the language and click **Continue**.
1. On the *Preparing to install Ubuntu* screen, select **Download updates while installing** and **Install this third-party software** and click **Continue**.
    * The **Download updates while installing** option will only be enabled if the system has an active internet connection. If the system has a non-firewalled public IP, selecting this option is very important.
1. On the *Installation type* screen, select **Erase disk and install Ubuntu**, enable **Encrypt the new Ubuntu installation for security**, enable **Use LVM with the new Ubuntu installation** and click **Continue**.
    * This option should only be selected if the system will not be dual-booted **and** if any important data on the system's drive has been backed up.
	* For this system, `jordan`, the main drive (an SSD) will only contain Ubuntu. While Ubuntu was being installed, this was the only drive in the system (as the adapter needed to connect a second drive was not yet available).
1. On the *Choose a security key* screen, enter a unique [passphrase](http://en.wikipedia.org/wiki/Passphrase) and click **Install Now**. Be sure to write down this passphrase and store it in a secure location. If the passphrase is lost, all data on the system will be completely unrecoverable.
1. On the *Where are you?* screen, ensure that the correct timezone location is selected and click **Continue**.
    * For this system, `jordan`, the location used was `Phoenix`.
1. On the *Keyboard layout* screen, select **English (US)** in both selection boxes and click **Continue**.
1. On the *Who are you?* screen, fill out the form as follows:
    1. Your name: `Local User`
	1. Your computer's name: `jordan-u`
	1. Pick a username: `localuser`
	1. Enter a unique password in the two password fields. Be sure to write this password down someplace safe.
	1. Log in automatically: disabled
	1. Require my password to log in: enabled
	1. Encrypt my home folder: disabled
1. On the *Choose a picture* screen, select a photo or image to use and click **Continue**.
1. Wait for the installation to complete.
1. On the *Installation Complete* screen, click **Restart Now**.

Remove the USB drive once the computer has restarted and the system should boot into the new Ubuntu installation.


### Troubleshooting: Ubuntu Installer Hangs

My first attempt to create a bootable drive failed in an odd way: the system was able to boot off of the drive, but would hang on the startup graphic after selecting one of the boot options, e.g. **Try Ubuntu without installing**. Pressing `Esc` displayed the text console, which contained a number of errors that turned out to not have any really useful hits on Google. Some of those errors were:

* `chroot: can't execute '/usr/lib/user-setup/user-setup-apply': Input/output error`
* `install: invalid user `ubuntu'`
* `/usr/lib/pythons2.7/dist-[ackages/LanguageSelector/LocaleInfo.py:256: UserWarning: failed to connect to socket /var/run/dbus/system_bus_socket: No such file or directory`
* `Traceback ... File "/usr/bin/fontconfig-voodoo", line 101, in <module> ... main()`

It seems that this problem was just caused by a bad installer image. Perhaps it's because I didn't initially select the **Format Drive** option in the Universal USB Installer application. After re-downloading the image, selecting that option, and imaging the same USB drive again, I was able to boot the installer without any problems.


### Troubleshooting: Garbled Disk Unlock Screen

When the system boots, a screen will be displayed asking for the drive's encryption key. On my ThinkPad W530, the display of this screen was heavily garbled and not legible. Pressing the `Esc` key reverted to a text-only display that was usable.


## Post-Install Tasks

The following sub-sections detail important tasks that should be completed after the installation.


### Installing Updates

Boot the system. When prompted for the encryption passphrase, enter the one you set (and wrote down) earlier. Then, login with the `localuser` account and the password you created for it.

Before doing anything else, run the following commands:

```shell-session
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get dist-upgrade
```

This will update the installed versions of the libraries and applications installed on the system. This is important as there may be security vulnerabilities and other bugs in the version of libraries and applications included with the installer, that there are patches available to fix them. It's especially important to do this before enabling SSH!

Once the patches are installed, you'll want to reboot the system to ensure the latest kernel available is being used. Please note that this is only necessary if kernel updates were applied:

```shell-session
$ sudo reboot
```


### Troubleshooting: Graphics Driver Issues

On `jordan-u`, a Lenovo ThinkPad W530, with NVIDIA Optimus disabled in the BIOS, and a stock 64bit 12.10 install, the Ubuntu GUI would randomly crash when starting certain applications, such as Firefox or System Log. After the crash, the GUI would immediately restart and diplsay the login screen. In `/var/log/syslog`, the following error was recorded at the time of the crash:

```
Fatal IO error 11 (Resource temporarily unavailable) on X server
```

By default, Ubuntu will install and enable the open source [nouveau](http://nouveau.freedesktop.org/wiki/) graphics drivers. It seems these drivers have some bugs in 12.10, as switching to the proprietary NVIDIA drivers solved the problem. The NVIDIA drivers were enabled as follows:

1. Click the Ubuntu dash icon in the upper left.
1. Start the **System Settings** application.
1. Open the **Software Sources** applet.
1. Switch to the *Additional Drivers* tab.
1. Select the **Using NVIDIA binary Xorg driver, kernel module, and VDPAU library from nvidia-current (proprietary, tested)** option.
1. Click **Apply Changes** and enter the user password, if prompted.
1. Close the **Software Sources** applet and the **System Settings** application.
1. Restart the system.

As mentioned, this seems to have solved the problem.


### Enabling Remote SSH Access

Before installing an SSH server, we're going to turn on [fail2ban](https://help.ubuntu.com/community/Fail2Ban), a service that will automatically blacklist any IP addresses that attempt to login over SSH after a certain number of failed attempts. This will make brute force attacks against your SSH server much more difficult. Install fail2ban by running the following command:

```shell-session
$ sudo apt-get install fail2ban
```

Install the OpenSSH server by running the following command:

```shell-session
$ sudo apt-get install openssh-server openssh-blacklist openssh-blacklist-extra
```

Run the following command to determine what the system's IP address is:

```shell-session
$ ifconfig
```

If that command's output scrolls off the screen you can pipe it through `less`, use the up/down arrow keys to scroll, and press the `q` key to quit:

```shell-session
$ ifconfig | less
```

Look for the `inet addr` entry, which will be the system's IP address. On my system, it was `192.168.1.106`. Please note that `127.0.0.1` is not what you're looking for: it's the default [loopback address](http://en.wikipedia.org/wiki/Loopback) and cannot be used remotely.

After the network connection has been setup, you should be able to connect to the computer from other hosts via the following SSH command (substituting the correct IP address):

```shell-session
$ ssh localuser@192.168.1.106
```


### Setting the System Name and Domain

References:

* <http://ubuntuforums.org/showthread.php?t=1467978>

A number of services such as Kerberos rely on each machine having a valid fully qualified domain name. In this system's case, that should be `jordan-u.justdavis.com`. To ensure this is the case, two files have to be setup correctly:

1. `/etc/hostname`: This file should have the non-qualified hostname.
1. `/etc/hosts`: This file should have the fully qualified hostname, as well as the non-qualified hostname as an alias assigned to `127.0.0.1`.

Specifically, the first two entries in `/etc/hosts` should read as follows:

```
127.0.0.1       localhost
127.0.1.1       jordan-u.justdavis.com   jordan-u
```

The hostname configuration can be tested with the `hostname` command. The first command should return the unqualified name and the second command should return the fully qualified name:

```shell-session
$ hostname
$ hostname -f
```


### Configuration: Displays

My ThinkPad is connected to a docking station with two DVI monitors attached to it. The laptop itself is left closed and out of reach. The following configuration changes were made for this setup:

1. Launch the **System Settings** application.
1. Open the **Displays** applet.
1. Select the **Laptop** device.
    * This may require clicking a bit above the actual icon for this device, seems to be a bug in the applet.
1. Switch the display device to **Off**.
1. Set the *Launcher placement* option to the first DVI-attached monitor.
1. Click **Apply**.
1. When prompted, select **Keep this configuration**.

**Troubleshooting note**: After applying these changes, my two external displays were mirrored and the launcher wasn't visible. This seems to have just been a temporary glitch, though, as moving my mouse all the way to the upper left of the displays resolved the problem: the screen blinked for a moment and then everything was configured correctly.


## Power Management Configuration

References:

* [Ubuntu Help: How do I hibernate my computer?](https://help.ubuntu.com/12.04/ubuntu-help/power-hibernate.html)

Per the above article, verify that hibernate works correctly by running the following command:

```shell-session
$ sudo pm-hibernate
```

This will cause the system to enter hibernation (hopefully). Powering on the system should restore the computer to its previous state: with all applications still running. Please note that the system will prompt for the disk encryption password when restoring from hibernation.

If hibernation worked correctly, it should be enabled as an option by creating a new `/etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla` file with the following content:

```
[Re-enable hibernate by default]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes
```

The following configuration changes were made to the system's power management options:

1. Launch the **System Settings** application.
1. Open the **Power** applet.
1. Set the *Suspend when inactive for* option to **30 minutes** for the *On battery power* state.
1. Set the *When power is critically low* option to **Hibernate**.
1. Set the *When the lid is closed* option to **Do nothing** for both states.
1. Set the *Show battery status in the menu bar* option to **When battery is charging/in use**.


## Security Configuration

The following configuration changes were made to the system's security options:

1. Launch the **System Settings** application.
1. Open the **Brightness and Lock** applet.
1. Set the *Turn screen off when inactive for* option to **1 hour**.
