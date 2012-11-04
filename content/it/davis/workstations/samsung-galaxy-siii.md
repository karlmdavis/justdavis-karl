--- 
title: Samsung Galaxy S III
kind: topic
summary: Describes the setup of a Samsung Galaxy S III phone.
---

# <%= @item[:title] %>

In October of 2012, both Karl and Erica purchased Samsung Galaxy S III phones (for the T-Mobile network). The stock image for those phones includes a lot of uninstallable and (arguably) useless applications. Unfortunately, the only way to remove those applications is to root the phone. This page documents how to root these phones and install [CyanogenMod](http://www.cyanogenmod.com/) 10.M1 on them.


## Specs

* Hardware
    * CPU: Intel 1.6GHz Atom N270
    * Hard Drive: 4GB SSD
    * WLAN: 802.11b/g
    * Display: 8.9", 1024x600
    * Display Card: Intel UMA
    * Weight: 0.99kg


## Root Permissions

References:

* [No Tripping Flash Counter Tmobile / Wind / Mobilicity](http://forum.xda-developers.com/showthread.php?t=1771687)
* [Samsung Galaxy S III (T-Mobile): Full Update Guide](http://wiki.cyanogenmod.com/wiki/Samsung_Galaxy_S_III_%28T-Mobile%29:_Full_Update_Guide)

Before much anything else can be done, even just backing up properly, root access to the device is needed. There are a couple of methods for gaining root access, but some of those will trip the S III's "flash counter." This is a mechanism built into the phone to detect when the stock OS has been customized. Not a big deal, but it will result in a big exclamation point graphic being displayed during every boot up. The "No Tripping Flash Counter" walkthrough linked above describes a way of achieving root that doesn't have this drawback.

Download the `root66_TMO_T999UVALH2.7z` linked from the walkthrough and extract the `root66.stock_TMO_T999UVALH2.tar` file from it by running `p7zip -d Downloads/root66_TMO_T999UVALH2.7z`. Boot the phone into "Download Mode" (a mode where it waits to be flashed) by disconnecting the USB cable, turning the phone off, and then booting it by holding Volume Down, Home, and Power until the "Warning!!" screen appears. Then, release those keys, and press Volume Up once to enter Download Mode.

The phone is now waiting for a flash image to be sent to it. The most common application for doing this is a leaked-from-Samsung Windows application named "Odin," which can be downloaded from a link at the CyanogenMod wiki page referenced above. However, there's also an open source application named [Heimdall](http://www.glassechidna.com.au/products/heimdall/) available. Unfortunately, version 1.3.2 doesn't seem to support 64 bit Linux (only 32 bit) or the S III, so Odin has to be used from a Windows machine, instead. Download and install the Windows USB drivers using the link at the CyanogenMod wiki page referenced above and then download and unzip Odin.

Connect the phone to the Windows computer and launch `Odin3 v3.04.exe`. In Odin, click the **PDA** button and select the `root66.stock_TMO_T999UVALH2.tar` file that was downloaded. Leave the **Auto Reboot** and **F. Reset Time** options enabled, then click the **Start** button to push the rooted image to the phone. The flash will take around ten minutes, and when complete, the phone should reboot automatically. All of the phone's data and applications should be left in place.


## Backup

Before proceeding, it is strongly recommended that you backup the device. A full system backup can be made via `adb`, which is included in the <%= topic_link("/it/davis/misc/android-dev-env/") %>. The following command will backup just about everything, except for the media/file storage:

    $ adb backup -apk -shared -system -f samsung-galaxy-siii-karl-backup-2012-10-04.ab

In addition to that backup, it's strongly recommended that a backup also be performed with each of the following applications:

* [Titanium Backup](http://matrixrewriter.com/android/), which makes it much easy to restore individual applications
* [SMS Backup & Restore](http://market.android.com/details?id=com.riteshsahu.SMSBackupRestore)
* [Call Backup & Restore](http://market.android.com/details?id=com.riteshsahu.CallLogBackupRestore)

Be sure to copy any backups made off of the device storage before proceeding! For example, the following will pull all of the Titanium Backups from the phone to the local computer:

    $ adb pull /sdcard/TitaniumBackup/ ~/samsung-galaxy-siii-karl-titanium-backup-2012-10-06


## Installing ClockworkMod Recovery

References:

* [CWM Touch Recovery](http://forum.xda-developers.com/showthread.php?t=1766552)

Prior to installing CyanogenMod or another custom ROM, it's generally necessary to install a custom recovery image, like ClockworkMod's. Download the latest "Touch Recovery" listed for the T-Mobile S III from the following URL: <http://www.clockworkmod.com/rommanager>. Copy this file to the phone's SD card area using `adb push`, e.g.:

    $ adb push ~/Downloads/recovery-clockwork-touch-6.0.1.2-d2tmo.img /sdcard/

Then, use `adb shell` along with `dd` to apply the recovery image, e.g.:

    karl@pratchett:~$ adb shell
    shell@android:/ $ su
    shell@android:/ # dd if=/sdcard/recovery-clockwork-touch-6.0.1.2-d2tmo.img of=/dev/block/platform/msm_sdcc.1/by-name/recovery
    shell@android:/ # reboot recovery

The last command should cause the phone to reboot into the recovery image. It's recommended to make another backup here via the **backup and restore** menu: one can never have too many backups. To do so, first change the backup format to `tar` by selecting ****backup and restore > choose backup format > tar** and then start the backup by selecting **backup and restore > backup**.

There's nothing to flash in here yet, so select the **reboot system now** option to reboot the phone normally.

If you did create a backup using ClockworkMod, be sure to copy it off of the device, e.g.:

    $ adb pull /sdcard/clockworkmod/backup/1970-01-04.14.39.25/ ~/samsung-galaxy-siii-karl-clockworkmod-backup-2012-10-06


## Installing CyanogenMod

References:

* [Samsung Galaxy S III (T-Mobile): Full Update Guide](http://wiki.cyanogenmod.com/wiki/Samsung_Galaxy_S_III_%28T-Mobile%29:_Full_Update_Guide)

Please note that, as of this writing (2012-10-06), there is not a final release of CyanogenMod for the S III yet, either in the 9.x or 10.x series. There is, however, a stable milestone/monthly 10.x release available: "cm-10-20120911-EXPERIMENTAL-d2tmo-M1". This guide covers the installation of that release; the instructions for the first "complete" 10.x release may be different, though that's unlikely.

Because ClockworkMod was flashed using `dd`, rather than Odin, the Android [ROM Manager](https://play.google.com/store/apps/details?id=com.koushikdutta.rommanager&hl=en) application can't be used to install CyanogenMod; it will have to be installed in recovery, instead. First download the latest stable CyanogenMod release from [CyanogenMod Files for Samsung Galaxy S III (TMUS) - d2tmo](http://download.cyanogenmod.com/?device=d2tmo&type=) and the latest Google apps bundle from [CyanogenMod: Google Apps](http://wiki.cyanogenmod.com/wiki/Latest_Version#Google_Apps). Copy these files to the phone using `adb push`, e.g.:

    $ adb push ~/Downloads/cm-10-20120911-EXPERIMENTAL-d2tmo-M1.zip /sdcard/
    $ adb push ~/Downloads/gapps-jb-20120726-signed.zip /sdcard/

Once these have been copied to the phone, reboot into recovery using `adb`, e.g.:

    $ adb reboot recovery

In Clockwork Recovery, do the following to install both CyanogenMod and the Google apps:

1. Clear the device's current data (make sure you have backups!):
    1. **wipe data/factory reset**
    1. **wipe cache partition**
1. Install CyanogenMod:
    1. **install zip from sdcard**
    1. **choose zip from sdcard**
    1. Select the `cm-10-20120911-EXPERIMENTAL-d2tmo-M1.zip` file. Wait for the installation to complete, which should only take a minute or so.
1. Install the Google apps bundle:
    1. **install zip from sdcard**
    1. **choose zip from sdcard**
    1. Select the `gapps-jb-20120726-signed.zip` file. Wait for the installation to complete, which should only take a minute or so.

Once all of the installations have been completed, select **Go Back > reboot system now** to reboot into CyanogenMod.

