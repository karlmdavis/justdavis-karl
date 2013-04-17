--- 
title: Switch to Gnome Shell
kind: topic
summary: Describes how to switch a stock Ubuntu install to Gnome Shell.
---

# <%= @item[:title] %>

This <%= topic_link("/it/davis/workstations/jordan/") %> sub-guide describes how to switch a stock Ubuntu install to Gnome Shell.

By default, Ubuntu uses the Unity shell, which is open source but developed primarily by Canonical specifically for Ubuntu. Personally, I'm actually quite fine with Unity as a shell; I think most of the UI decisions made there are sensible. However, there's one very important problem with Unity that's driven me to switch to Gnome Shell: Unity's workspace support is lousy on laptops, or any system where the display configuration changes regularly. Attaching or disconnecting a display, modifying a display's resolution, or even plugging/unplugging a projector causes applications to "shuffle" workspaces. This drives me nuts, as I often have about ten or so workspaces going at once, and having to rearrange all of my windows is very time consuming.

The only reference I've found to this problem via Google is the following Ask Ubuntu question: [Switching displays while keeping windows in workspaces](http://askubuntu.com/q/172712/41593).


## Installing Gnome Shell

Installing Gnome Shell is simple, just run the following command:

    $ sudo apt-get install gnome-shell

When prompted during the installation, I'd recommend you stick with the current default login/display manager: **lightdm**.

After the install has completed, log out. Before logging back in, click the desktop environment icon (probably looks like Ubuntu symbol) next to the user's name on the login screen. In that menu, select **Gnome** and then log in as normal. Rather than Unity, the environment should be Gnome Shell.

**Troubleshooting Note:** I'm not entirely sure why, but when logging in to Gnome Shell, no UI elements are visible or usable until I move my mouse to the upper-left corner of the environment. It's odd, but I'd guess it has something to do with my particular multi-monitor setup.


## Configuring Multiple Monitors and Workspaces

References:

* [Fix Dual Monitors in GNOME 3 (aka My Workspaces are Broken!)](http://gregcor.com/2011/05/07/fix-dual-monitors-in-gnome-3-aka-my-workspaces-are-broken/)

By default, Gnome Shell's handling of multiple monitors and workspaces is fairly bizarre: only the primary display is included in the workspaces, while the other display(s) always have the same windows and aren't affected by switching workspaces.

Fortunately, there's a hidden setting to modify this behavior. Running the following command will cause all displays to be included in workspace switching:

    $ gsettings set org.gnome.shell.overrides workspaces-only-on-primary false

After running this command, restart the system and workspaces should be functioning as expected, again.

