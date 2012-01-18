--- 
title: Fforde Microsoft Office
kind: topic
summary: Describes the steps necessary to install, configure, and run Microsoft Office on fforde.
---

# Lewis DNS Service

This <%= topic_link("/workstations/fforde/") %> sub-guide describes the steps necessary to install, configure, and run Microsoft Office 2010 on fforde.


## Installing PlayOnLinux and Wine

References:

* <http://appdb.winehq.org/objectManager.php?sClass=version&iId=17336&iTestingId=67549>
* <http://superuser.com/questions/275120/how-install-office-2010-under-wine-in-linux-ubuntu>

[Wine](http://www.winehq.org/) is a compatibility layer that allows Linux to run Microsoft Windows applications. It's not complete; a number of applications don't run at all or have glitches. However, it is impressively comprehensive; a lot of applications do run just fine. Ubuntu 10.04 has version 1.2.x of Wine available, so we'll add a PPA repository to make the more up-to-date (but less stable) version 1.3.x available.

[PlayOnLinux](http://www.playonlinux.com/) is a GUI and management tool for Wine applications that simplifies things some. The version of PlayOnLinux available in Ubuntu 10.04 is out of date and no longer supported by the upstream developers, unfortunately. We'll need to add the upstream-produced repositories to get a working version. Both PlayOnLinux and Wine (a dependency of it) will be installed by running the following commands:

<pre><code># add-apt-repository ppa:ubuntu-wine/ppa
$ wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
# wget http://deb.playonlinux.com/playonlinux_lucid.list -O /etc/apt/sources.list.d/playonlinux.list
# apt-get update
# apt-get install playonlinux
</code></pre>

Once this installation is complete, you'll need to run the ''Configure Wine'' application at least once, which can be found in the ''Wine'' application menu. Opening it up and then just clicking ''OK'' to exit is sufficient.

Because this laptop doesn't have a CD/DVD drive, the MS Office installation CDs had to be shared from another computer. This was accomplished by inserting the CD and running the following commands on the EeePC:

<pre><code># apt-get install sshfs
$ mkdir cdShare
$ sshfs remoteUser@remotemachine.domain:/media/cdrom0 cdShare
</code></pre>

In the above command, replace the following values, as necessary:

* `remoteUser`: the name of a user account on the remote machine to login as
* `remoteMachine.domain`: the fully-qualified hostname of the remote machine
* `/media/cdrom0`: the location on the remote machine that the installation CD has been mounted at

After the installation completes, the PlayOnLinux application can be found in the Games category of the applications menu. Start the application and it will walk you through configuring you for its first use.

Once PlayOnLinux is ready, click on ''Install'', select ''Testing > Microsoft Office 2010'', and then click ''Apply''. The installation wizard will start up, download the appropriate version of Wine, do some additional housekeeping, and then walk you start the installation process. When prompted for the CD-ROM directory, select "Other" and then enter the path to the mount created earlier, e.g. `/home/username/cdShare/`.



## Installing Microsoft Office 2010

Before Office can be installed, it has a number of dependencies that need to be installed first. This may seem odd if you're unfamiliar with Wine; you can just stick the Office CD in and run the installer on any Windows computer and things just work. However, that's because standard Windows installs come with a number of libraries and applications that the Office installer expects to be there and takes advantage of. Things are a bit different on Wine-- it's helpful to think of it as a "lean and mean" version of Windows that has less cruft. The 
