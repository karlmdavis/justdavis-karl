--- 
title: Android Development Environment
kind: topic
summary: "Describes how to install an Android development environment."
---


# <%= @item[:title] %>

This guide describes how to install an Android development environment.


## Ubuntu 12.04

This section covers installing v20.0.3 of the Android SDK on Ubuntu 12.04.

References:

* [Android SDK: Installing](http://developer.android.com/sdk/installing/index.html)

At this time, the Android SDK doesn't provide an installer for Ubuntu; only a binary bundle is available. Download the latest release of the bundle from the following URL: <http://developer.android.com/sdk/index.html>. The following commands will extract that bundle to the `/usr/local/bin/android-sdk/android-sdk_r20.0.3-linux/` directory:

    $ sudo mkdir -p /usr/local/bin/android-sdk
    $ sudo chown -R root:root /usr/local/bin/android-sdk
    $ sudo chmod -R a=rwX /usr/local/bin/android-sdk
    $ tar -xz -C /usr/local/bin/android-sdk -f android-sdk_r20.0.3-linux.tgz
    $ mv /usr/local/bin/android-sdk/android-sdk-linux /usr/local/bin/android-sdk/android-sdk_r20.0.3-linux

Create the following file as `/etc/profile.d/android-sdk.sh`:

~~~~
#!/bin/sh

SDK=/usr/local/bin/android-sdk/android-sdk_r20.0.3-linux
SDK_TOOLS=$SDK/tools

if [ -d "$SDK_TOOLS" ] ; then
        export PATH="$PATH:$SDK_TOOLS"
fi
~~~~

Mark the file as executable:

    $ sudo chmod a+x /etc/profile.d/android-sdk.sh

The next time you login, that script will be run and will add the SDK's `tools` directory to the default path. To accomplish that in your current terminal session (without having to logoff and login), run the following:

    $ . /etc/profile.d/android-sdk.sh

Run the following command to start the Android SDK Manager:

    $ android sdk

This will start a GUI that can be used to install the SDK components needed. I installed the following components:

* SDK Platform-tools
* Android 4.1
* Android Support Library

