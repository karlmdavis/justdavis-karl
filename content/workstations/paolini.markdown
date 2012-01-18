--- 
title: Paolini
kind: topic
summary: Describes the setup of paolini, which is a Windows Vista guest virtual machine used on Karl's primary desktop.
---

# <%= @item[:title] %>

`paolini` is the Windows virtual machine guest used on Karl's primary desktop. This page documents the steps required to create and configure this VM.


## Specs

* Virtual Hardware
    * RAM: 2 x 2048MB DDR2800 (PC2-6400)
        * G.Skill: F2-6400CL5D-4GBPQ
        * CL5-5-5-15
        * 1.8-1.9V
    * Motherboard: Gigabyte EP45-UD3P
    * Video Card: Sapphire ATI Radeon HD 3870
        * 512MB GDDR4
        * PCI-E
        * Dual DVI
    * CPU: E8400 Intel Core 2 Duo
        * 3 GHz
        * 45nm
        * 6MB L2 shared cache
        * LGA775 socket
        * 1333 MHz FSB
        * Product Code: BX80570E8400
        * MM #: 899035
        * FPO/Batch #: Q832A384
        * S-spec: SLB9J


## VM Creation

References:

* <https://help.ubuntu.com/community/KVM/CreateGuests#Create_VMs_running_other_operating_systems:_virt-install>

The kvm guest was created using the following `virt-install` command:

<pre><code># virt-install \
    --connect qemu:///system \
    --name=paolini \
    --vcpus=1 \
    --ram=1536 \
    --disk path=/var/lib/libvirt/images/paolini.qcow2,size=40 \
    --disk path=windows-vista-homePremium.iso,device=cdrom \
    --os-type windows \
    --os-variant vista
    --graphics vnc
</code></pre>


### Spice Graphics

[SPICE](http://spice-space.org/) is a technology being developed by RedHat that allows for much-improved graphics, with other benefits such as stereo audio and USB redirection. As of 2012-01-14, however, Ubuntu Oneiric did not have the appropriate packages available in the non-PPA repositories. Accordingly, I've opted to just use VNC for graphics to make life easier.

If you'd like to investigate using SPICE instead of VNC, I'd recommend the following documentation:

* <http://www.linux-kvm.org/page/SPICE>
* <http://www.azertech.net/content/view/77/1/>


## VM Startup

Running the `virt-install` command should create, start, and connect to the VM automatically. If you accidentally close the guest console window, you can reconnect to it with the following command:

    $ virt-viewer --connect qemu:///system paolini


## Windows Installation

Because the path to an `.iso` file was specified in the `virt-install` command above, that file will be used as a CDROM image and set as the boot device for the first run. The virtual machine should boot right into the Windows installer.

Proceed through the installer, sticking with the default options when prompted.

When the installer automatically shuts down after completing, run the following command to start the computer back up:

    $ virsh --connect qemu:///system start paolini

Then reconnect to the computer's console using `virt-viewer`, as above. The guest will likely reboot once or twice before bringing up the ''Set Up Windows'' dialog. Proceed through the dialog, answering the questions as follows:

* User name: a short ID for the primary user account, e.g. `karl`
* Password: (leave it blank)
    * This is a good idea if you'll be configuring the computer to login via a Kerberos account.
    * This will also disable remote access to the computer via that account, but can be configured as specified in the following article: [KB 303846](http://support.microsoft.com/default.aspx?scid=303846).
* Computer name: `paolini`
* "Help protect Windows automatically" (i.e. Windows Update): Use recommended settings
* Time zone, date & time: (obvious)
* Select your computer's current location: Home
    * Please note that the default VM networking configuration uses NAT-based networking. This means that the guest machine will not be accessible to computers other than the VM host, unless port forwarding is configured or the networking is switched to a bridge.

