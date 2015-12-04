--- 
title: Eddings OpenAFS Server
kind: topic
summary: "Describes the steps necessary to make eddings an OpenAFS file server."
---


# <%= @item[:title] %>

This <%= topic_link("/it/davis/servers/eddings/") %> sub-guide describes the steps necessary to make the computer an [http://www.openafs.org/](OpenAFS) file server.

Previously, I'd been using `asimov` as an OpenAFS server hosting the `davisonlinehome.name` cell (see <%= wiki_entry_link("AsimovSetupAfsServer") %>). This functionality has now been moved to `eddings`. The cell formerly hosted by `asimov`, `davisonlinehome.name`, was decomissioned and replaced with the new `justdavis.com` cell on `eddings`.

This OpenAFS installation will depend on Kerberos. Please ensure that the `JUSTDAVIS.COM` Kerberos realm has been setup as described in <%= topic_link("/it/davis/servers/eddings/kerberos/") %>.


## Preliminary Preparation

OpenAFS will need a dedicated partition to store its data volumes. This will require shrinking the existing volumes while the server is offline, bringing everything back up, creating the new volume, formatting it, and mounting it.


### Backing Up

References:

* <https://help.ubuntu.com/community/Mount/USB/>
* <https://help.ubuntu.com/community/BackupYourSystem/TAR>

Before doing any repartitioning, though, making a backup of the server is **required**. To make a backup, we'll first need to find an external disk with enough free space to store everything. How much space is needed? Run the `df` command and note the "Used" number of bytes on the root filesystem, denoted by '`/`'. Once you've found an external drive with that much free space, connect it to the server and mount it. For example (lines starting with '`#`' are comments that can be safely ignored):

~~~~
# Note the drive's device node under "Device", e.g. /dev/sdc1
$ sudo fdisk -l
# Note the drive's file system type, e.g. ext4
$ sudo file -sL /dev/sdc1
# Run a file system check and repair to ensure integrity of drive (optional)
$ sudo fsck -y /dev/sdc1
# Create a mount point for drive and mount it
$ sudo mkdir /media/externalbackup
$ sudo mount -t ext4 /dev/sdc1 /media/externalbackup
~~~~

Before proceeding with the backup, all virtual machines should be stopped so that their volume images can be backed up correctly. The following commands were used to stop all virtual machines on `eddings`:

~~~~
sudo virsh --connect qemu:///system shutdown lewis
sudo virsh --connect qemu:///system shutdown asimov
sudo virsh --connect qemu:///system shutdown piers
sudo virsh --connect qemu:///system shutdown tolkien
~~~~

The simplest backup mechanism is to create a compressed `.tar.gz` arhive of all files. The following command will back everything up to the external drive, excluding some virtual files:

    $ sudo tar -cvpzSf /media/externalbackup/eddings-backup-2012-07-08-beforeResizeForAfs.tar.gz --exclude=/proc --exclude=/lost+found --exclude=/sys --exclude=/mnt --exclude=/media --exclude=/dev /

Once the backup has complete, unmount the drive and remove the mount point, as follows:

    $ sudo umount /media/externalbackup/
    $ sudo rmdir /media/externalbackup/


### Shrinking Root Partition

References:

* <https://help.ubuntu.com/community/ResizeEncryptedPartitions>
* <http://askubuntu.com/questions/124465/how-do-i-shrink-the-root-partition-lv-on-lvm>

In order to resize the root partition, the system will have to be shutdown and then booted into a Live CD environment. Acquire and prepare the Live CD:

1. Download the installer `ubuntu-12.04-desktop-i386.iso` file at [Download Ubuntu Desktop](http://www.ubuntu.com/download/desktop/). A later version may also be acceptable.
1. Follow the "Burn your CD or create a bootable USB stick" instructions on that page to create a bootable flash drive from the `.iso`.

Boot from the flash drive (press `F8` at the POST screen to select the boot drive). This should launch the Ubuntu Live CD environment. Select "Try Ubuntu" when prompted.

**Troubleshooting Note:** Ubuntu crashed on me here and never got around to bringing up a desktop. To work around this, I simply switched to console mode by hitting `ctrl+alt+F1`, as all that was needed here was a terminal.

In order to operate on the partitions, the libraries for using encrypted drives and `lvm`-managed partitions will need to be installed:

    $ sudo apt-get update
    $ sudo apt-get install lvm2 cryptsetup

Load the `cryptsetup` kernel module:

    $ sudo modprobe dm-crypt

Run `fdisk` and examine the output to determine the device node (listed under "Device") of the encrypted system partition:

$ sudo fdisk -l

On `eddings`, the encrypted partition was `/dev/sdb5`.

Run `cryptsetup` to decrypt the encrypted partition, entering the encryption key when prompted:

$ sudo cryptsetup luksOpen /dev/sdb5 crypt1

Locate and activate the drive's LVM groups and volumes:

sudo vgscan --mknodes
sudo vgchange -ay

The `vgscan` command above will report the name of the volume group it finds, e.g. "`eddings`". Make note of this name, as it will be needed in later commands.

Run a file system check, resize the file system and logical volume, and check the file system again. Run the following commands, replacing `<vgname>` with the volume group name noted earlier and <sizechange> with the amount of space to free up, e.g. "`-120G`" will reduce the existing volume's size by 120 GB:

    $ sudo e2fsck -f /dev/mapper/<vgname>-root
    $ sudo lvresize --resizefs --size <sizechange> /dev/<vgname>/root
    $ sudo e2fsck -f /dev/mapper/<vgname>-root

Once the volume has been resized, unmount the LVM and crypt and then reboot into the normal operating system to continue:

    $ sudo vgchange -an
    $ sudo cryptsetup luksClose crypt1
    $ sudo reboot

**Please note:** Neither the enclosing volume group nor the enclosing crypt need to be resized, as the new partition will be contained within both of those.


### Creating New Volume for AFS Data

References:

* <http://ubuntuforums.org/showthread.php?t=1782296>
* <https://lists.openafs.org/pipermail/openafs-info/2001-March/000433.html>

The equivalent of a partition (something that can house a file system) with LVM is a "logical volume". Creating a logical volume is a simple one-line command. To create a new `openafs-a` logical volume using all of the free/unallocated space, on the volume group named `eddings` (as noted earlier):

    $ sudo lvcreate --name openafs-a --extents 100%FREE eddings

Once the logical volume has been created, it needs to be formatted as `ext4`, which is the default for Ubuntu to 10.04:

    $ sudo mkfs -t ext4 /dev/mapper/eddings-openafs--a

The AFS convention is to store volumes on dedicated file systems, mounted as `/vicepa`, `/vicepb`, etc. In this setup, there is no need for more than one partition (multiple AFS volumes can be stored on a single partition), so the file system just created should be mounted as `/vicepa`. To configure this, add the following entry to `/etc/fstab`:

~~~~
/dev/mapper/eddings-openafs--a /vicepa               ext4    defaults,noatime 0       1
~~~~

After the entry has been added, run the following commands to create the mountpoint and mount the new volume:

    $ sudo mkdir /vicepa
    $ mount /vicepa


## Installing OpenAFS

References:

* <http://tig.csail.mit.edu/wiki/TIG/OpenAFSOnUbuntuLinux>
* <http://bobcares.com/blog/?p=501>
* <http://www.debian-administration.org/article/610/OpenAFS_installation_on_Debian>

The OpenAFS server and client packages should be installed as follows:

    $ sudo apt-get install openafs-doc openafs-dbserver openafs-krb5 krb5-user

When prompted by the installer, provide the following responses:

* AFS cell this workstation belongs to: `justdavis.com`
* Size of AFS cache in kB: `500000`


## Creating justdavis.com Cell

[http://www.openafs.org/](OpenAFS) is a complicated beast. In addition, there's not a lot of up-to-date information available on the internet on how to set it up. However, the documentation provided with the OpenAFS Debian/Ubuntu packages is fantastic and more than makes up for the lack of internet references. It's strongly recommended that you read through this packaged documentation before proceeding further with the installation. The documentation can be read by running the following commands:

    $ less /usr/share/doc/openafs-dbserver/README.Debian.gz
    $ less /usr/share/doc/openafs-dbserver/README.servers.gz

The rest of this guide is basically just a summary of the `README.servers` guide mentioned above, slightly customized for the particulars of the `justdavis.com` domain.

A Kerberos principal and keytab will be needed for the AFS service. The following commands should be used to create this:

~~~~
$ sudo kadmin.local
kadmin.local: addprinc -policy services -randkey -e des-cbc-crc:v4 afs/justdavis.com
kadmin.local: ktadd -k /tmp/afs.justdavis.com.keytab -e des-cbc-crc:v4 afs/justdavis.com
kadmin.local: quit
~~~~

Due to deficiencies in OpenAFS, the Kerberos KDC will also have to be configured to allow the use of DES. This deficiency is discussed in the following mailing list trhead: <http://lists.openafs.org/pipermail/openafs-info/2010-January/032746.html>. To enable this, add the following entry to the `[libdefaults]` section of the `/etc/krb5.conf` file:

~~~~
	allow_weak_crypto = true
~~~~

After doing this, restart the KDC with the following command:

    $ sudo /etc/init.d/krb5-kdc restart

The `ktadd` command above will create a keytab file named `/tmp/afs.justdavis.com.keytab`. It will also report the "`kvno`" of the keytab in its console output, which will be needed for the next step, so be sure to make note of it.

The keytab will need to be converted into an AFS keyfile using the `asetkey` utility. The following commands will do so (replace "`<kvno>`" with the value noted from the `ktadd` command above):

    $ sudo asetkey add <kvno> /tmp/afs.justdavis.com.keytab afs/justdavis.com
    $ rm /tmp/afs.justdavis.com.keytab

Edit the `/etc/openafs/CellServDB` file and add the following entry (replace the IP address with the server's static public IP, as returned by `nslookup eddings.justdavis.com`):

~~~~
>justdavis.com          #Davis Family cell
174.79.40.37                    #eddings.justdavis.com
~~~~

Debian/Ubuntu include a number of scripts to ease the configuration of OpenAFS. One of these scripts is `afs-newcell`, which will setup the AFS `ptserver`, `volserver`, etc. such that a new cell is up, running, and (mostly) empty. Run the script as follows:

    $ sudo /etc/init.d/openafs-client stop
    $ sudo afs-newcell

When prompted, answer the questions as follows:

* Do you meet these requirements?: `y` (strongly recommended you read through the requirements and confirm this, first)
* What administrative principal should be used?: `karl/admin`

After this has completed, the AFS server has been setup. However, it lacks any volumes, as `ls /afs/justdavis.com` will demonstrate. To fix that, you should obtain tokens for the cell and run the `afs-rootvol` script, as follows:

    $ sudo kinit karl/admin
    $ sudo aklog
    $ sudo afs-rootvol

When prompted, answer the questions as follows:

* What AFS Server should volumes be placed on?: `eddings.justdavis.com`
* What partition?: `a`

At this point, the cell's root volume has been populated with several "standard" volumes.

Modern OpenAFS clients support the use of DNS to retrieve the list of AFS servers for a given cell via the use of `AFSDB` records. This is a convenient alternative to manually updating `/etc/openafs/CellServDB` files on every client workstation. The following record was added for the `justdavis.com` DNS zone:

~~~~
justdavis.com.                  IN      AFSDB             1 eddings.justdavis.com.
~~~~


## Populating justdavis.com Cell

As the `justdavis.com` AFS cell is intended to replace `davisonlinehome.name`, most of the work in populating the cell involves backing up volumes in the old cell and importing them into the new one. However, the following guide does an excellent job of explaining how to navigate and populate a new AFS cell being setup from scratch: <http://www.debian-administration.org/article/610/OpenAFS_installation_on_Debian#afs-concepts>.

The first step in migrating from `davisonlinehome.name` was getting a list of the volumes in the cell. The following commands were used to produce such a list:

    karl@asimov:~$ kinit karl/admin@DAVISONLINEHOME.NAME
    karl@asimov:~$ aklog
    karl@asimov:~$ vos listvol -server asimov.davisonlinehome.name

This returned the following:

~~~~
Total number of volumes on server asimov.davisonlinehome.name partition /vicepa: 12 
bogus.536870924                   536870924 RW          0 K Off-line
group                             536870930 RW          3 K On-line
group.karlanderica                536870933 RW    8948688 K On-line
root.afs                          536870912 RW        189 K On-line
root.afs.readonly                 536870913 RO        189 K On-line
root.cell                         536870915 RW          6 K On-line
root.cell.readonly                536870916 RO          6 K On-line
service                           536870921 RW          2 K On-line
sysAdmin                          536870936 RW   17413305 K On-line
user                              536870918 RW          4 K On-line
user.erica                        536870927 RW   25417194 K On-line
user.karl                         536870961 RW   26611473 K On-line
~~~~

All of the volumes above that are larger than 200 K contain actual data, while the rest contain just mountpoints. That means the following volumes need to be moved: `group.karlanderica`, `sysAdmin`, `user.erica`, and `user.karl`.

The volumes will need to be dumped (see `man vos_dump`) to `eddings` in order to be loaded (see `man vos_restore`) into the `justdavis.com` cell. The first step is to mount a directory on `eddings` from `asimov` using `sshfs` so that the dump can be created directly, rather than having to be copied over afterwards (which `asimov` doesn't have the drive space for, anyways). The following commands were used to create that mountpoint on `asimov`, named `/home/karl/eddings-karl`:

    karl@asimov:~$ sudo apt-get install sshfs
    karl@asimov:~$ sudo gpasswd -a $USER fuse
    karl@asimov:~$ mkdir ~/eddings-localuser
    karl@asimov:~$ sshfs -o idmap=user localuser@eddings.justdavis.com:/home/localuser ~/eddings-localuser

With this done, the volumes were dumped from `asimov`, as follows:

    karl@asimov:~$ mkdir ~/eddings-localuser/asimov-afs-dumps
    karl@asimov:~$ vos dump -id group.karlanderica -file ~/eddings-localuser/asimov-afs-dumps/group.karlanderica.vosdump &
    karl@asimov:~$ vos dump -id sysAdmin -file ~/eddings-localuser/asimov-afs-dumps/sysAdmin.vosdump &
    karl@asimov:~$ vos dump -id user.erica -file ~/eddings-localuser/asimov-afs-dumps/user.erica.vosdump &
    karl@asimov:~$ vos dump -id user.karl -file ~/eddings-localuser/asimov-afs-dumps/user.karl.vosdump &

Once the dumps were complete, the SSHFS mount was unmounted:

    karl@asimov:~$ fusermount -u ~/eddings-localuser

The dumps need to be restored into the `justdavis.com` cell, by running the following commands on `eddings`:

    $ vos restore -server eddings.justdavis.com -partition a -name group.karlanderica -file ~/asimov-afs-dumps/group.karlanderica.vosdump &
    $ vos restore -server eddings.justdavis.com -partition a -name group.sysadmin -file ~/asimov-afs-dumps/sysAdmin.vosdump &
    $ vos restore -server eddings.justdavis.com -partition a -name user.erica -file ~/asimov-afs-dumps/user.erica.vosdump &
    $ vos restore -server eddings.justdavis.com -partition a -name user.karl -file ~/asimov-afs-dumps/user.karl.vosdump &

The end goal is to obtain the following structure in the `justdavis.com` cell:

~~~~
Path					Permissions			Description
----					-----------			-----------
/afs/justdavis.com/			admins w, anyone r		
	group/				admins w, anyone r		The group volume.
		karlanderica/		admins w, karlanderica w	The group.karlanderica volume.
		sysadmin/		admins w, authuser r		The group.sysadmin volume.
	user/				admins w, anyone r		The user volume.
		erica/			admins w, erica w		The user.erica volume.
		karl/			admins w, karl w		The user.karl volume.
~~~~

The following commands were run on `eddings` (starting from the cell setup created by `afs-newcell` and `afs-rootvol`) to realize this:

    $ fs rmmount -dir /afs/.justdavis.com/service
    $ vos remove -id service -cell justdavis.com
    $ vos create -server eddings.justdavis.com -partition a -name group
    $ fs mkmount -dir /afs/.justdavis.com/group -vol group
    $ fs mkmount -dir /afs/.justdavis.com/group/karlanderica -vol group.karlanderica
    $ fs mkmount -dir /afs/.justdavis.com/group/sysadmin -vol group.sysadmin
    $ fs mkmount -dir /afs/.justdavis.com/user/karl -vol user.karl
    $ fs mkmount -dir /afs/.justdavis.com/user/erica -vol user.erica
    $ pts createuser -name karl
    $ pts createuser -name erica
    $ pts creategroup -name sysadmins -owner system:administrators
    $ pts adduser -user karl.admin karl -group sysadmins
    $ pts creategroup -name karlanderica -owner karl
    $ pts adduser -user karl erica -group karlanderica
    $ fs setacl /afs/justdavis.com/ -acl system:administrators all system:anyuser read -clear
    $ fs setacl /afs/justdavis.com/group -acl system:administrators all system:anyuser read -clear
    $ find /afs/justdavis.com/group/karlanderica -type d -exec fs setacl {} \-acl system:administrators all karlanderica all \-clear \;
    $ find /afs/justdavis.com/group/sysadmin -type d -exec fs setacl {} \-acl system:administrators all sysadmins all system:authuser read \-clear \;
    $ fs setacl /afs/justdavis.com/user -acl system:administrators all system:anyuser read -clear
    $ find /afs/justdavis.com/user/erica -type d -exec fs setacl {} \-acl system:administrators all erica all \-clear \;
    $ find /afs/justdavis.com/user/karl -type d -exec fs setacl {} \-acl system:administrators all karl all \-clear \;
    $ vos release -id root.cell -cell justdavis.com

