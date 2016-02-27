---
layout: post
title: "A sad tale of VPN troubles on Intrepid"
date: 2015-08-29
categories: it linux vpn
description: "I've now spent a few evenings this week debugging a VPN client error at home: \"LCP: timeout sending Config-Requests ... Connection terminated. ... Modem hangup\""
---

I've now spent a few evenings this week debugging a VPN client error at home.  I'm running Ubuntu Intrepid, whose VPN client [has](https://bugs.launchpad.net/ubuntu/+source/network-manager-pptp/+bug/278309) [had](https://bugs.launchpad.net/ubuntu/+source/network-manager-pptp/+bug/291895) [some](https://bugs.launchpad.net/ubuntu/+source/network-manager-pptp/+bug/259168) [issues](https://bugs.launchpad.net/ubuntu/+source/network-manager-pptp/+bug/284212), I've noticed.  So running into yet another problem was less "surprising" and more "depressing."  Whenever I tried to connect to a VPN server, I'd get an error and see the following in the messages log:

<pre>Mar 21 12:20:27 feist pppd[28594]: Plugin /usr/lib/pppd/2.4.4/nm-pptp-pppd-plugin.so loaded.
Mar 21 12:20:27 feist pppd[28594]: pppd 2.4.4 started by root, uid 0
Mar 21 12:20:27 feist pppd[28594]: Using interface ppp0
Mar 21 12:20:27 feist pppd[28594]: Connect: ppp0 &lt;--&gt; /dev/pts/0
Mar 21 12:20:58 feist pppd[28594]: LCP: timeout sending Config-Requests
Mar 21 12:20:58 feist pppd[28594]: Connection terminated.
Mar 21 12:20:58 feist pppd[28594]: Modem hangup
Mar 21 12:20:58 feist pppd[28594]: Exit.</pre>

This problem appeared last weekend and since then I've spent a few fun-filled evenings learning all sorts of interesting things about pptp, the Linux VPN client used "under the hood" in Ubuntu.  Two of those things I learned might actually be useful someday:

* [How to start a VPN client connection from the command line](https://help.ubuntu.com/community/VPNClient#Manually%20configuring%20your%20connection) (useful for servers and debugging)
* [How to use tcpdump to log VPN attempts](http://pptpclient.sourceforge.net/howto-diagnosis.phtml#tcpdump)

Unfortunately, nothing I tried resolved the problem; I couldn't connect to VPN from Linux on this computer at all.  I could from my wife's laptop (running Hardy) and I could if I booted into Windows in the exact same desktop.  Very frustrating.

Then, about a half hour ago I was doing some more Googling on this problem and wandered across a few folks that mentioned they had to play with the port forwarding on their router to make things work.  I knew that wasn't my problem as it worked on Windows and had been working just fine on this Linux install too.  But it did get me thinking about my router (running [DD-WRT](http://www.dd-wrt.com)) and I decided to fall back on the sysadmin's old standby:

Restart It and Try Again (an analgue of the more modern [JFGI](http://justfuckinggoogleit.com/))

Not my computer, mind you (that was the first thing I'd tried).  No, I restarted the router.  There's no reason for that to have fixed it, no reason at all... but it did.  Of course.

I'm just glad I don't [owe Dell any royalties](http://www.bbspot.com/News/2003/08/dell_tech_support.html) for this solution.
