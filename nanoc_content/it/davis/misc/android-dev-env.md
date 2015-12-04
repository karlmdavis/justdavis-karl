--- 
title: Android Development Environment
kind: topic
summary: "Describes how to install an Android development environment."
---


# <%= @item[:title] %>

This guide describes how to install an Android development environment.

It assumes that the following guides have already been completed:

* <%= topic_summary_link("/it/davis/misc/java/") %>
* <%= topic_summary_link("/it/davis/misc/eclipse/") %>



## Ubuntu 12.04 (and later)

This section covers installing v20.0.3 of the Android SDK on Ubuntu 12.04 and later.

References:

* [Android SDK: Installing](http://developer.android.com/sdk/installing/index.html)
* [Stack Overflow: Is there a way to automate the android sdk installation?](http://stackoverflow.com/questions/4681697/is-there-a-way-to-automate-the-android-sdk-installation/4682241#4682241)

At this time, the Android SDK doesn't provide an automated installer for Ubuntu; only a binary bundle is available. 

The following script can be saved as `android-sdk-install.sh`, and will download and install Eclipse 4.2:

~~~~
#!/bin/sh

# Define the URL to download the "installation" package from.
installationUrl=http://dl.google.com/android/android-sdk_r21.1-linux.tgz

# Pull apart the name of the file that will be downloaded.
installationName=android-sdk_r21.1-linux
installationFile=$installationName.tgz

# Define the directory to save the install to.
installationDirectoryRoot=/usr/local/android-sdk
installationDirectory=$installationDirectoryRoot/$installationName

# Create the installation directory root.
mkdir -p $installationDirectoryRoot/

# Download, extract, and relocate the installation bundle.
wget $installationUrl
tar -xzf $installationFile
rm $installationFile
mv android-sdk-linux/ $installationDirectory/
chmod -R a+rX $installationDirectory/

# Create the shell profile snippet.
cat <<EOF > /etc/profile.d/android-sdk.sh
#!/bin/sh

export ANDROID_HOME=$installationDirectory

ANDROID_TOOLS=\$ANDROID_HOME/tools
ANDROID_PLATFORM_TOOLS=\$ANDROID_HOME/platform-tools

if [ -d "\$ANDROID_TOOLS" ] ; then
	export PATH="\$PATH:\$ANDROID_TOOLS"
fi

if [ -d "\$ANDROID_PLATFORM_TOOLS" ] ; then
	export PATH="\$PATH:\$ANDROID_PLATFORM_TOOLS"
fi
EOF

# Mark the snippet as executable.
chmod a+x /etc/profile.d/android-sdk.sh

# Apply the snippet to the current shell (all other shells will pick it up at the next login).
. /etc/profile.d/android-sdk.sh

# Install some of the SDK's downloadable components.
$installationDirectory/tools/android update sdk --filter platform-tools --no-ui
$installationDirectory/tools/android update sdk --filter extra-android-support,extra-google-admob_ads_sdk,extra-google-analytics_sdk_v2,extra-google-gcm,extra-google-google_play_services,extra-google-play_apk_expansion,extra-google-play_billing,extra-google-play_licensing,extra-google-webdriver --no-ui
$installationDirectory/tools/android update sdk --filter android-17,doc-17,sample-17,sysimg-17,addon-google_apis-google-17 --no-ui
$installationDirectory/tools/android update sdk --all --filter android-10,sample-10,sysimg-10,addon-google_apis-google-10 --no-ui
~~~~

Run the following commands to mark the script as executable and then run it:

    $ chmod a+x android-sdk-install.sh
    $ sudo ./android-sdk-install.sh

The next time you login, a profile snippet will be run that will add the SDK's `tools` directory to the default path. To accomplish that in an existing terminal session (without having to logoff and login), run the following:

    $ . /etc/profile.d/android-sdk.sh


### Eclipse Plugin: ADT

References:

* [Installing the Eclipse Plugin](http://developer.android.com/sdk/installing/installing-adt.html)
* [Eclipse Juno Documentation: Installing software using the p2 director application](http://help.eclipse.org/juno/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Fguide%2Fp2_director.html&resultof=%22command%22%20%22line%22%20%22plugin%22)

Android's Developer Tools include an Eclipse plugin that greatly aids in the
development of Android code. It should be installed as follows:

1. Install the plugin from the <https://dl-ssl.google.com/android/eclipse/> Eclipse update site. The following command will do this automatically (run it from the Eclipse installation to be modified):

        $ eclipse -application org.eclipse.equinox.p2.director -repository https://dl-ssl.google.com/android/eclipse/ -installIU com.android.ide.eclipse.adt.feature.group

1. Allow Eclipse to restart.
1. The *Configure SDK* screen will appear for ADT.
1. Select **Use existing SDKs**.
1. Enter the path to the Android SDK, e.g. 
   `/usr/local/android-sdk/android-sdk_r21.1-linux`.
1. Click **Next**.
1. Select whether or not you wish to *Send usage statistics to Google* and click 
   **Finish**.


