--- 
title: Install Eclipse
kind: topic
summary: Describes how to install the Eclipse IDE.
---

# <%= @item[:title] %>

This guide describes how to install the [Eclipse IDE](http://eclipse.org/) on Ubuntu.


## Installing Eclipse

References:

* [How do I install Eclipse Juno in Ubuntu 12.04?](http://ksearch.wordpress.com/2012/10/26/how-do-i-install-eclipse-juno-in-ubuntu-12-04/)
* [Super User: How to pass variables to a HEREDOC in bash?](http://superuser.com/questions/456615/how-to-pass-variables-to-a-heredoc-in-bash)

While Ubuntu does have a somewhat-recent version of Eclipse in its repositories, it's rarely the latest release. On Ubuntu 12.10, the Eclipse in the repositories in 3.8, while the latest Eclipse release at that time was 4.2, Juno.

The following script can be saved as `eclipse-juno-install.sh`, and will download and install Eclipse 4.2:

~~~~
#!/bin/sh

# Define the URL to download the "installation" package from.
installationUrl=http://download.eclipse.org/technology/epp/downloads/release/juno/SR2/eclipse-java-juno-SR2-linux-gtk-x86_64.tar.gz

# Pull apart the name of the file that will be downloaded.
installationName=eclipse-java-juno-SR2-linux-gtk-x86_64
installationFile=$installationName.tar.gz

# Define the directory to save the install to.
installationDirectoryRoot=/usr/local/eclipse
installationDirectory=$installationDirectoryRoot/$installationName

# Create the installation directory root.
mkdir -p $installationDirectoryRoot/

# Download, extract, and relocate the installation bundle.
wget $installationUrl
tar -xzf $installationFile
rm $installationFile
mv eclipse/ $installationDirectory/

# Create the application launcher.
cat <<EOF > /usr/share/applications/$installationName.desktop
[Desktop Entry]
Version=1.0
Name=Eclipse Juno
  
Exec=$installationDirectory/eclipse
Terminal=false
Icon=$installationDirectory/icon.xpm
Type=Application
Categories=IDE;Development
X-Ayatana-Desktop-Shortcuts=NewWindow

[NewWindow Shortcut Group]
Name=New Window
Exec=$installationDirectory/eclipse
TargetEnvironment=Unity
EOF
~~~~

Run the following commands to mark the script as executable and then run it:

    $ chmod a+x eclipse-juno-install.sh
    $ sudo ./eclipse-juno-install.sh

That's it. There should now be an **Eclipse Juno** application launcher available.
