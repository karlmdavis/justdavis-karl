---
title: "Getting Started with i3"
layout: post
date: 2018/05/28
categories: it
description: "Switching to i3 for laptop portability."
---

I recently switched my external display setup from two 1600x1200 monitors to a single 4K monitor. It's a bit more difficult for my aging eyes, but the increase in total resolution hs been great. I also love that "all" of my monitors are now on a monitor arm, freeing more desk surface up, and making it easier to convert my desk from sit to stand mode (previously, only one of my two monitors had been mounted on an adjustable arm). It's really been a great improvement!

Somewhat unexpectedly, though, I've found that it makes it harder for me to undock my laptop and cart it around. On the 4K display, it's ludicrous to run things maximized, so I typically have at least four (often more!) windows all going at once, arranged in different portions of the screen. When I undock, though, that layout falls apart. Even worse, Gnome 3 collapses all of my workspaces down to just one, leaving me to re-sort the dozens of windows back into their proper place. These are minor problems, all things considered, but they've made me very reluctant to dock/undock my laptop. Given that we just wrapped up a longer-than-usual winter, that really grates -- I want to be outside on the porch enjoying the gorgeous weather!

So what to do? Well, for a while now I've been considering switching to a tiling window manager. I had similar problems, though to a lesser degree, even with my previous setup and I've always suspected that a tiling layout would solve the problems. So: I started doing some research this weekend. Here's a giant brain dump of what I've learned:

* Arch's wiki provides a useful list of tiling display managers: <https://wiki.archlinux.org/index.php/Comparison_of_tiling_window_managers>.
* Of those, i3 seems to be the most popular.
    * That may change in the future if/when Wayland gains popularity, as i3 doesn't support it (and seems unlikely to).
    * But I'm not using Wayland, and can't, due to NVIDIA suckage, so that's not relevant right now.
* Installing the `i3` package and restarting on Ubuntu 18.04 was enough to get things running.
    * Did have to restart the system before the option to log into an i3 session appeared.
* i3's User Guide is pretty solid: <https://i3wm.org/docs/userguide.html#_interprocess_communication>.
    * Arch's wiki for it provides lots of more advanced info that was super helpful once I was familiar with the basics: <https://wiki.archlinux.org/index.php/I3>.
* I'm not smart enough to use `nmcli` for network/wifi management, it seems, so I needed to enable `i3bar`'s tray output, per <https://wiki.archlinux.org/index.php/I3#Tray_icons_not_visible>.
    * This won't work unless/until you mark the display as `--primary` in `xrandr`.
* It turns out that Gnome was managing my external displays for me behind the scenes; that wasn't the NVIDIA settings or X settings or anything like that. i3, however, doesn't do that for you. Instead, turning on/off external monitors and all of that fun stuff has to be done by hand, typically with `xrandr`.
* Power management is also different with i3 than it was with Gnome. Specifically, I noticed that my laptop started going to sleep when I closed the lid (e.g. after docking it).
* Each i3 workspace is explicitly associated with a display. If you switch displays, you have to move the workspaces to the new one(s).

## Problem Solving: Stay Awake

References:

* [How can I tell Ubuntu to do nothing when I close my laptop lid?](https://askubuntu.com/a/372616)

It's not super useful to have the laptop go to sleep every time I dock it and close the lid. I resolved this, as follows:

1. Add the following lines to `/etc/systemd/logind.conf`:
  ```
  HandleLidSwitch=ignore
  HandleLidSwitchDocked=ignore
  ```
    * Note that this fixed the problem for me, even though it _looked_ like the default settings here shouldn't cause a suspend.
2. Restart the system, or at least the `systemd-logind` service. (Either one of these will kill your i3 session, FYI.)

## Problem Solving: Manually Switching Displays

As mentioned above, i3 doesn't have any fancy control panels like Gnome for managing displays. Instead, displays need to be managed directly via the `xrandr` command line tool. Here are some sample commands I use to switch around my displays:

* To turn on both `LVDS-0`, the laptop display and `DP-3`, the external 4K display at the same time:
  ```shell-session
  $ xrandr --output LVDS-0 --auto --primary --output DP-3 --auto --rate 30.0 --right-of LVDS-0
  ```
* To switch to just `DP-3`, the external 4K display:
  ```shell-session
  $ xrandr --output LVDS-0 --off --output DP-3 --auto --rate 30.0 --primary
  ```
* To switch to just `LVDS-0`, the laptop display:
  ```shell-session
  $ xrandr --output LVDS-0 --auto --primary --output DP-3 --off
  ```

Note: I initially ran into some trouble with this, until I realized that my laptop can't drive `DP-3` at the default 60.0 Hz. I learned this by logging back into Gnome, getting the displays configured the way I wanted them, and running `xrandr` with no options to see how things were actually configured.

Second Note: After connecting my external display, the `xrandr` commands to turn it on often fail. Still not sure why yet, but disconnecting and reconnecting it and trying again seems to fix it after a few tries.

## Problem Solving: Audio Controls

i3 doesn't come with any builtin way to manage volume, mute/unmute, etc. My Ubuntu system uses PulseAudio, so I can get by, though painfully, by using the command line utilities for it, as described here: <http://terokarvinen.com/2015/volume-control-with-pulseaudio-command-line-tools>.

If I wanted to, I could probably wire up those commands to some keyboard shortcuts and leave it at that, but I'd prefer to have a GUI, personally. My first try at this is using `pasystray`, which is prett terribly, but has the advantage of being available in Ubuntu's default repositories:

```shell-session
$ sudo apt install pasystray
$ pasystray &> /dev/null &
```

This will add a little volume icon in the systray that you can hover over and then use the mouse wheel to change the volume. For some reason, every other option it has seems disabled. Whatever: good enough for now.

## Problem Solving: Cheatsheet

I made a number of customizations to the default key bindings. Most notably, I switched out the default `j k l ;` bindings for Vim-muscle-memory-friendly `h j k l`. This and the other customizations I made are all great, but invalidate the visual layout cheatsheets that are provided towards the top of the [i3 User Guide](https://i3wm.org/docs/userguide.html#_default_keybindings).

Happily, I came across a great online shortcut cheatsheet generator: [Keyboard Layout Editor](http://www.keyboard-layout-editor.com/). Here are the layouts that I generated for my config:

[mod Bindings](http://www.keyboard-layout-editor.com/##@@=~%0A%60&=!%0A1&=%2F@%0A2&=%23%0A3&=$%0A4&=%25%0A5&=%5E%0A6&=%2F&%0A7&=*%0A8&=(%0A9&=)%0A0&=%2F_%0A-&=+%0A%2F=&_w:2%3B&=Backspace%3B&@_w:1.5%3B&=Tab&=Q&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=W%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Atab%20layout&=E%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Ah%20%2F%2F%20v%20toggle&=R%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Aresize&_t=%23000000%3B&=T&=Y&=U&=I&=O&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=P%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Adisplay&_t=%23000000%3B&=%7B%0A%5B&=%7D%0A%5D&_w:1.5%3B&=%7C%0A%5C%3B&@_w:1.75%3B&=Caps%20Lock&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=A%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Afocus%20parent&=S%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Astack%20layout&=D%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Admenu&_n:true%3B&=F%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Afull-%20screen&_t=%23000000%3B&=G&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=H%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Afocus%20left&_n:true%3B&=J%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Afocus%20down&=K%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Afocus%20up&=L%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Afocus%20right&_t=%23000000%3B&=%2F:%0A%2F%3B&=%22%0A'&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323&w:2.25%3B&=Enter%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Ai3-sensisble-terminal%3B&@_t=%23000000&w:2.25%3B&=Shift&=Z&=X&=C&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=V%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Avert%20layout&_t=%23000000%3B&=B&=N&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=M%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Amark&_t=%23000000%3B&=%3C%0A,&=%3E%0A.&=%3F%0A%2F%2F&_w:2.75%3B&=Shift%3B&@_w:1.25%3B&=Ctrl&_c=%23e82323&w:1.25%3B&=Win&_c=%23cccccc&w:1.25%3B&=Alt&_t=%23000000%0A%23e82323&a:5&w:6.25%3B&=%0Afocus%20floating%20%2F%2F%20tiling&_t=%23000000&a:4&w:1.25%3B&=Alt&_w:1.25%3B&=Win&_w:1.25%3B&=Menu&_w:1.25%3B&=Ctrl):

![i3 mod Bindings]({{ '/assets/images/2018-05-28-getting-started-with-i3-keyboard-layout-mod.png' | prepend: site.baseurl }})

[mod+Shift Bindings](http://www.keyboard-layout-editor.com/##@@=~%0A%60&=!%0A1&=%2F@%0A2&=%23%0A3&=$%0A4&=%25%0A5&=%5E%0A6&=%2F&%0A7&=*%0A8&=(%0A9&=)%0A0&=%2F_%0A-&=+%0A%2F=&_w:2%3B&=Backspace%3B&@_w:1.5%3B&=Tab&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=Q%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Akill&=W&=E%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Ai3%20exit&=R%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Ai3%20restart&_t=%23000000%3B&=T&=Y&=U&=I&=O&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=P&_t=%23000000%3B&=%7B%0A%5B&=%7D%0A%5D&_w:1.5%3B&=%7C%0A%5C%3B&@_w:1.75%3B&=Caps%20Lock&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=A&=S&=D&_n:true%3B&=F&_t=%23000000%3B&=G&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=H%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Amove%20left&_n:true%3B&=J%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Amove%20down&=K%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Amove%20up&=L%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Amove%20right&_t=%23000000%3B&=%2F:%0A%2F%3B&=%22%0A'&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323&w:2.25%3B&=Enter%3B&@_c=%23e82323&t=%23000000&w:2.25%3B&=Shift&_c=%23cccccc%3B&=Z&=X&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=C%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Ai3%20reload&=V%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Ahoriz%20layout&_t=%23000000%3B&=B&=N&_t=%23000000%0A%0A%0A%0A%0A%0A%0A%0A%0A%0A%23e82323%3B&=M%0A%0A%0A%0A%0A%0A%0A%0A%0A%0Aclear%20mark&_t=%23000000%3B&=%3C%0A,&=%3E%0A.&=%3F%0A%2F%2F&_w:2.75%3B&=Shift%3B&@_w:1.25%3B&=Ctrl&_c=%23e82323&w:1.25%3B&=Win&_c=%23cccccc&w:1.25%3B&=Alt&_t=%23000000%0A%23e82323&a:5&w:6.25%3B&=%0Atoggle%20floating%20%2F%2F%20tiling&_t=%23000000&a:4&w:1.25%3B&=Alt&_w:1.25%3B&=Win&_w:1.25%3B&=Menu&_w:1.25%3B&=Ctrl):

![i3 mod+Shift Bindings]({{ '/assets/images/2018-05-28-getting-started-with-i3-keyboard-layout-mod-shift.png' | prepend: site.baseurl }})
