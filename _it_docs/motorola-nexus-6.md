---
title: Nexus 6
layout: it_doc
group: workstations
description: Describes the setup of a Nexus 6 phone.
---

In 2015, Karl purchased a Motorola Nexus 6 phone (for the T-Mobile network). This page documents how to root this phone, which allows full backups of the phone to be made, amongst other things.

## Installing the Android SDK

This process requires the Android SDK to be installed on a computer that the phone can be connected to via USB. The SDK can be installed by following the instructions on {% collection_doc_link_long /it/android-dev-env baseurl:true %}. All of the `adb` and `fastboot` commands below assume that the `/usr/local/android-sdk/adt-bundle-linux-x86_64-20131030/sdk/platform-tools/` directory is where these commands are installed.

## Unlocking

By default, Nexus phones don't have their permissions set to allow modifying the system such that a custom recovery can be installed or that the phone can be rooted. The phones are "OEM locked." However, with Nexus devices, unlocking the bootloader is fairly simple. Note, though, that this will completely wipe the device as part of the unlocking (to ensure that any info on the device already isn't compromised)! If you already have any data on the phone that you care about, you should first back it up using `adb backup`, which doesn't require root access.

Once you're ready to wipe and unlock the phone, proceed as follows:

1. Enable USB debugging and unlocking:
    1. On the device, launch the **Settings** application.
    1. Select **About phone**.
    1. Tap **Build number** seven times, which will enable the developer settings option.
    1. Go back, and select **Developer options**.
    1. Enable **USB debugging**.
    1. Enable **OEM unlocking**.
1. Get `adb` ready:
    1. Connect the phone to the computer via USB.
    1. Run the following command to verify that `adb` and your phone are communicating:
    
        ```
        $ /usr/local/android-sdk/adt-bundle-linux-x86_64-20131030/sdk/platform-tools/adb devices
        ```
    
    1. Watch the phone to see if it prompts to allow this operation. If so, choose the **Always allow from this computer** option and click **OK**. Then rerun the above command and ensure that it doesn't report the phone as "`offline`".
1. Unlock the bootloader:
    1. Boot into "fastboot" mode by running the following command from your computer:
    
        ```
        $ /usr/local/android-sdk/adt-bundle-linux-x86_64-20131030/sdk/platform-tools/adb reboot bootloader
        ```
    
    1. Once the phone has entered its Fastboot mode, run the following command to unlock the bootloader:
    
        ```
        $ sudo /usr/local/android-sdk/adt-bundle-linux-x86_64-20131030/sdk/platform-tools/fastboot oem unlock
        ```
    
    1. On the phone, press the power button to confirm.
    1. On the *Unlock bootloader?* screen, select **YES** using the volume buttons to confirm that the phone will be wiped (a full factory reset) and then press the power button to proceed.
    1. Once the unlocking is complete, use the volume and power buttons in Fastboot to select the **START** option, which will reboot the phone normally.

## Installing a Custom Recovery: TWRP

References:

* [How To Geek: How to Flash the TWRP Recovery Environment to Your Android Phone](http://www.howtogeek.com/240047/how-to-flash-twrp-recovery-on-your-android-phone/)
* [TWRP Devices: Motorola Nexus 6](https://twrp.me/devices/motorolanexus6.html)

The custom recovery was installed as follows, using `adb` from a Linux system, as needed:

1. Enable USB debugging:
    1. On the device, launch the **Settings** application.
    1. Select **About phone**.
    1. Tap **Build number** seven times, which will enable the developer settings option.
    1. Go back, and select **Developer options**.
    1. Enable **USB debugging**.
1. Get `adb` ready:
    1. Connect the phone to the computer via USB.
    1. Run the following command to verify that `adb` and your phone are communicating:
    
        ```
        $ /usr/local/android-sdk/adt-bundle-linux-x86_64-20131030/sdk/platform-tools/adb devices
        ```
    
    1. Watch the phone to see if it prompts to allow this operation. If so, choose the **Always allow from this computer** option and click **OK**. Then rerun the above command and ensure that it doesn't report the phone as "`offline`".
1. Install TWRP:
    1. Download the correct image file from [TWRP Devices: Motorola Nexus 6](https://twrp.me/devices/motorolanexus6.html) and save it to your Linux system.
    1. Open a terminal and switch to whatever directory the image file was downloaded to.
    1. Rename the file to `twrp.img` (it was originally `twrp-3.0.2-0-shamu.img` for me).
    1. Boot into "fastboot" mode by running the following command from your computer:
    
        ```
        $ /usr/local/android-sdk/adt-bundle-linux-x86_64-20131030/sdk/platform-tools/adb reboot bootloader
        ```
    
    1. Once the phone has entered its Fastboot mode, run the following command to install TWRP:
    
        ```
        $ sudo /usr/local/android-sdk/adt-bundle-linux-x86_64-20131030/sdk/platform-tools/fastboot flash recovery twrp.img
        ```
    
    1. Once the flashing has completed (which won't take long), use the volume controls to select **Reboot Recovery** and the power button to do that. The phone will boot into TWRP.
    1. TWRP will likely prompt you with a **Keep System Read Only?** screen. Swipe right at the bottom to allow modifications.
        * You should read the text and make your own decision, but the gist of it is this: if you don't allow modifications, the TWRP install will be removed as soon as you reboot.

## Take a Backup via TWRP

Now that TWRP is installed, it's fairly simple to create a comprehensive backup of the phone, as follows:

1. Boot into TWRP.
    * If the phone isn't already there, turn it off, then launch Fastboot by holding volume down and the power button for a while, then use the menu controls in Fastboot (volume and power buttons) to launch recovery.
1. Select **Backup**.
1. Ensure that the **System**, **Data**, and **Boot** partitions are selected.
    * On the *Options* tab, you may want to select the **Enable compression** option.
1. Swipe right at the bottom to start the backup operation.
1. Once the backup has completed, reboot the phone, connect it to the computer via USB, disable USB debugging, enable file access (via the charging notification), and copy the backup from **Internal Storage > TWRP > BACKUPS** to the computer's local drive.
1. Also be sure to copy all of the other things over that don't get included in backups, e.g. the pictures in the `DCIM` folder.
    * As I understand it, the backups just include data that's "baked in" to apps; they don't include data that apps write out as regular files to the device's storage.

## Gaining Root by Manually Installing SuperSU

References:

* [How To Geek: How to Root Your Android Phone with SuperSU and TWRP](http://www.howtogeek.com/115297/how-to-root-your-android-why-you-might-want-to/)

The most widely supported mechanism for gaining root access on Nexus devices is installing [SuperSU](http://forum.xda-developers.com/showthread.php?t=1538053). Until you already *have* root access, this must be done via TWRP, as follows:

1. Download the latest SuperSU from here: <https://download.chainfire.eu/supersu>.
1. Copy that file from your computer to your phone. Via `adb`, this can be done with a command like the following:

    ```
    $ sudo /usr/local/android-sdk/adt-bundle-linux-x86_64-20131030/sdk/platform-tools/adb push UPDATE-SuperSU-v2.76-20160630161323.zip /sdcard/UPDATE-SuperSU-v2.76-20160630161323.zip
    ```

1. Boot into TWRP.
    * Turn the phone off, then launch Fastboot by holding volume down and the power button for a while, then use the menu controls in Fastboot (volume and power buttons) to launch recovery.
1. Click **Install**.
1. Scroll down and select the SuperSU ZIP that was copied to the device.
1. On the confirmation screen that appears, swipe right at the bottom to install it. The install should just take a minute or so.
1. Once the install is complete, select the **Wipe cache/dalvik** option at the bottom and swipe to confirm it.
1. Once the cache has been wiped, choose the **Reboot System** option at the bottom. The phone may reboot a couple of extra times (just this once) to finish the rooting process. That's fine; don't interrupt it.

Congratulations: the phone has now been rooted and is ready to go!

## Installing Android OTA Updates Without Losing Root

References:

* [How To Geek: How to Install an Android OTA Update Without Losing Root](http://www.howtogeek.com/192402/why-androids-ota-updates-remove-root-and-how-to-keep-it/)
* [Wonder How To: Update Your Nexus Without Losing Root (No Computer Needed)](http://nexus5.wonderhowto.com/how-to/update-your-nexus-without-losing-root-no-computer-needed-0168428/)

An Android application called [FlashFire](https://play.google.com/store/apps/details?id=eu.chainfire.flash) can be used to install updates on rooted Nexus devices. However, the OTA updates that the phone automatically downloads and displays cannot be used with FlashFire, as we've modified the system and the OTA updates check for this and bail out if it's the case. The first referenced link above, [How To Geek: How to Install an Android OTA Update Without Losing Root](http://www.howtogeek.com/192402/why-androids-ota-updates-remove-root-and-how-to-keep-it/), describes trying to go this route, but it will fail. FlashFire itself will warn of this when trying to flash an OTA: "Warning: it has been detected that you may be trying to flash a block-level OTA, but your /system, /vendor, or /oem partition has been modified. This will likely cause the flash to fail!"

Instead, FlashFire can be used to download and install the latest update of the stock firmware, as described in the second referenced link above, [Wonder How To: Update Your Nexus Without Losing Root (No Computer Needed)](http://nexus5.wonderhowto.com/how-to/update-your-nexus-without-losing-root-no-computer-needed-0168428/). Follow the instructions there.

