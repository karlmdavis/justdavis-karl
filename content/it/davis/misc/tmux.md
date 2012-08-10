--- 
title: TMUX
kind: topic
summary: "Describes the configuration and use of the TMUX terminal multiplexer."
---


# <%= @item[:title] %>

This guide describes the configuration and use of the [TMUX](http://tmux.sourceforge.net/) terminal multiplexer. TMUX is a popular alternative to the [screen](http://www.gnu.org/software/screen/) terminal multiplexer and provides the following features:

* Persistent remote terminal sessions that are not lost if the SSH connection is dropped.
* Nestable window clients: allows multiple terminal sessions over a single SSH connection.


## Installing TMUX

Installing TMUX is as simple as:

    $ sudo apt-get install tmux


## Using TMUX

References:

* [Hawk Host Blog: TMUX](http://blog.hawkhost.com/2010/06/28/tmux-the-terminal-multiplexer/)
* [TMUX SourceForge Project](http://tmux.sourceforge.net/)
* [Persistent SSH connections with tmux](http://blog.somsip.com/2012/01/persistent-ssh-connections-with-tmux/)
* [man tmux](http://manpages.ubuntu.com/manpages/precise/en/man1/tmux.1.html)

For the complete TMUX novice, here are the basic functions:

* Log in to the remote server via `ssh` and start TMUX by running `tmux`. This starts a new TMUX session that will persist and survive accidental or intentional disconnection of the host SSH session.
* To discconect the TMUX session, leaving it active, press `ctrl+b, d`.
* To reconnect to a disconnected TMUX session, run `tmux attach`.
* To end a TMUX session (such that it can't be reconnected), simply run `exit` at the prompt inside the session.

If you find yourself wishing you could split the current SSH session into multiple terminals, it is strongly recommended that you read through the TMUX man page listed above. However, here are the basic TMUX commands that should get you started:

* `ctrl+b, "` will split the current pane into two: top and bottom.
* `ctrl+b, arrow key` will cycle to the pane in the specified direction relative to the current one.

