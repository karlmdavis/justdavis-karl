---
title: Piers SpiderOak Backup
parent: /it/piers
layout: it_doc
description: "Describes the steps necessary to backup piers using SpiderOak."
---

This {% collection_doc_link /it/piers baseurl:true %} sub-guide describes the steps necessary to backup `piers` using [SpiderOak](https://spideroak.com/), a "zero-knowledge" encrypted backup and synchronization service.

Specifically, the following will be backed up from `piers`:

* the Zimbra data on the server (see {% collection_doc_link /it/piers/zimbra baseurl:true %} for details on Zimbra)
* the `/etc` directory


## Installing SpiderOak

References:

* [FAQ: How do I set up a new user from the commandline?](https://spideroak.com/faq/questions/1017/how_do_i_set_up_a_new_user_from_the_commandline/)

Recent versions of [SpiderOak](https://spideroak.com/) now support headless installation and operation; they can be used on computers without a GUI environment, like `eddings`. To install SpiderOak, first go to <https://spideroak.com/download/> and locate the download link for 64bit Ubuntu. Copy the URL, e.g. <https://spideroak.com/directdownload?platform=ubuntulucid&arch=x86_64>. Then, download and install the `.deb` package (after installing its dependencies). For example:

    $ sudo apt-get install libfontconfig1 libxrender1 libice6 libsm6 dbus
    $ wget -O spideroak.deb https://spideroak.com/directdownload?platform=ubuntulucid\&arch=x86_64
    $ sudo dpkg -i spideroak.deb

Please note that the SpiderOak installation will add an `apt` repository that will be used to keep SpiderOak up to date.

Once SpiderOak is installed, it needs to be configured with the account login and machine name. This can be done as follows:

    $ SpiderOak --setup=-

When prompted, answer the questions as follows:

* Login: (the SpiderOak account name)
* Password: (the SpiderOak account password)
* Device ID: (leave blank, to setup a new device)
* Device Name: `piers`


## Backup Script

Install the `timelimit` utility:

    $ sudo apt-get install timelimit

Create the following script file as `/usr/local/bin/spideroak-backup.sh`:

~~~~
#!/bin/bash

# References:
# - http://stackoverflow.com/questions/637827/redirect-stderr-and-stdout-in-a-b$
# - http://linuxcommando.blogspot.com/2008/03/how-to-check-exit-status-code.html
# - http://stackoverflow.com/questions/64786/error-handling-in-bash
# - http://stackoverflow.com/questions/2275593/email-from-bash-script
# - http://wiki.zimbra.com/wiki/Open_Source_Edition_Backup_Procedure

backupLog=/var/log/backup-spideroak

# Call this function when an error occurs to log it (via email)
# and exit the script.
function error() {
	local CALLER_LINENO="$1"
	local MESSAGE="$2"
	local CODE="${3:-1}"

	local FULL_MESSAGE="Error on or near line ${CALLER_LINENO}: \"${MESSAGE}\". Exiting with status: ${CODE}."

	echo -e "$(date +%T) ${FULL_MESSAGE}" >> $backupLog

	# Try to start Zimbra back up, so mail can go out. Should be a no-op if it's already running.
	/etc/init.d/zimbra start
	echo -e "${FULL_MESSAGE}" | mail -s "Backup error" "karl@justdavis.com"

	exit "${CODE}"
}

# [DISABLED: the grep command used below will error when nothing is found.]
# Trap any errors, calling error() when they're caught.
#trap 'error ${LINENO}' ERR
# Checks the value of the third parameter passed.
# If non-zero, passes the args on to error().
function checkError() {
	local CALLER_LINENO="$1"
	local MESSAGE="$2"
	local CODE="${3:-1}"

	if [ ${CODE} -ne 0 ]; then
		error ${CALLER_LINENO} "${MESSAGE}" ${CODE}
	fi
}

# The timelimit command is used below to stop the backups if they're hanging.

# Backup all of the /opt/zimbra/ directory and ensure it didn't drop any
# errors in the SpiderOak log.
# Please note that the backup will stop and produce an error if everything
# can't be backed up within an hour.
echo "$(date +%T) Backup Zimbra: stopping services..." > $backupLog
zimbraStopTime="$(date +%s)"
/etc/init.d/zimbra stop
echo "$(date +%T) Backup Zimbra: services stopped." >> $backupLog
echo "$(date +%T) Backup Zimbra: starting backup..." >> $backupLog
timeout=$((60*60*4))
timelimit -t $timeout /usr/bin/SpiderOak --backup=/opt/zimbra &>> $backupLog
checkError ${LINENO} "Backup of AFS failed." $?
echo "$(date +%T) Backup Zimbra: backup completed." >> $backupLog
echo "$(date +%T) Backup Zimbra: starting services..." > $backupLog
/etc/init.d/zimbra start
zimbraStartTime="$(date +%s)"
zimbraDownTime="$(($zimbraStartTime - $zimbraStopTime))"
echo "$(date +%T) Backup Zimbra: services started (down for $(($zimbraDownTime/60)) minutes)." >> $backupLog
grep "[[:space:]]ERROR[[:space:]]" ~/.SpiderOak/*.log
[ $? -eq 0 ] && error ${LINENO} "SpiderOak backup log has errors."
~~~~

Mark the script as executable:

    $ sudo chmod a+x /usr/local/bin/spideroak-backup.sh

Create the log file the script will write to:

    $ sudo touch /var/log/backup-spideroak
    $ sudo chmod a+w /var/log/backup-spideroak

Make sure the script runs as expected:

    $ sudo /usr/local/bin/spideroak-backup.sh


### Email Configuration

References:

* [ Re: How To: Command-Line Email as Simply as Possible, #13](http://ubuntuforums.org/showpost.php?p=6014887&postcount=13)

The above script makes use of the `mail` command, which requires configuration before it will work correctly. Specifically, the use of an SMTP gateway is required, as most ISPs and mail servers will block mails sent from random computers. The `msmtp` package can be used to route outgoing mail to a "real" SMTP server. Install the packages:

    $ sudo apt-get install bsd-mailx msmtp

Edit the system-wide `/etc/mail.rc` file to include the following setting:

    set sendmail=/usr/bin/msmtp

Edit the system-wide `/etc/msmtprc` file to include the configuration for the SMTP server to be used. Details on this configuration can be found by running `man msmtp`. For example, a configuration similar to the following was used on `piers`:

~~~~
host		mail.justdavis.com
from		piers@justdavis.com
auth		login
tls		on
user		piers@justdavis.com
password	ASuperSecretPassword
tls_certcheck	off
~~~~

This setup can be verified by running the following command:

    $ mail -s "Test Subject" "karl@justdavis.com"

This will then prompt for the message body, which should be typed in. When complete, terminate it with a line that only has a period. After that, hit `ENTER` again when prompted for the CC addresses. For example:

~~~~
$ mail -s "Test Subject" "karl@justdavis.com"
test body
.
Cc: 
~~~~


## Running Script Automatically

Simply add the backup job to the `root` user's crontab, scheduled to run every day at 3am:

    $ sudo crontab -e

Use the following entry:

~~~~
0   3  *   *   *     /usr/local/bin/spideroak-backup.sh
~~~~

Finally, initialize SpiderOak for the `root` user, as above (except now with `sudo`):

    $ sudo su -
    # SpiderOak --setup=-

When prompted, answer the questions as follows:

* Login: (the SpiderOak account name)
* Password: (the SpiderOak account password)
* Device ID: (select `piers`)

At this point, everything should be ready to go. To ensure the script, is working, temporarily set the cron job's schedule to a time two minutes ahead of the clock, and then wait for the job to run. The last modification time on `/var/log/backup-spideroak` can be checked, as well.

