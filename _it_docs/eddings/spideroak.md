---
title: Eddings SpiderOak Backup
parent: /it/eddings
layout: it_doc
description: "Describes the steps necessary to backup eddings using SpiderOak."
---

This {% collection_doc_link /it/eddings baseurl:true %} sub-guide describes the steps necessary to backup `eddings` using [SpiderOak](https://spideroak.com/), a "zero-knowledge" encrypted backup and synchronization service.

Specifically, the following will be backed up from `eddings`:

* the contents of the `justdavis.com` AFS cell
* the `/etc` directory


## Installing SpiderOak

References:

* [FAQ: How do I set up a new user from the commandline?](https://spideroak.com/faq/questions/1017/how_do_i_set_up_a_new_user_from_the_commandline/)

Recent versions of [SpiderOak](https://spideroak.com/) now support headless installation and operation; they can be used on computers without a GUI environment, like `eddings`. To install SpiderOak, first go to <https://spideroak.com/download/> and locate the download link for 64bit Ubuntu. Copy the URL, e.g. <https://spideroak.com/directdownload?platform=ubuntulucid&arch=x86_64>. Then, download and install the `.deb` package (after installing its dependencies). For example:

    $ sudo apt-get install libfontconfig1 libxrender1
    $ wget -O spideroak.deb https://spideroak.com/directdownload?platform=ubuntulucid\&arch=x86_64
    $ sudo dpkg -i spideroak.deb

Please note that the SpiderOak installation will add an `apt` repository that will be used to keep SpiderOak up to date.

Once SpiderOak is installed, it needs to be configured with the account login and machine name. This can be done as follows:

    $ SpiderOak --setup=-

When prompted, answer the questions as follows:

* Login: (the SpiderOak account name)
* Password: (the SpiderOak account password)
* Device ID: (leave blank, to setup a new device)
* Device Name: `eddings`


## Manual Backup

References:

* [FAQ: How do I install SpiderOak on a headless Linux server?](https://spideroak.com/faq/questions/31/how_do_i_install_spideroak_on_a_headless_linux_server/)
* [FAQ: How can I use SpiderOak from the commandline?](https://spideroak.com/faq/questions/16/how_can_i_use_spideroak_from_the_commandline/)

Backing up a specific folder one time with SpiderOak is simple. For example, the following command can be used to backup the entire `/afs/justdavis.com` folder:

    $ kdestroy
    $ kinit karl/admin
    $ aklog
    $ SpiderOak --backup=/afs/justdavis.com

If the folder being backed up is large enough, the backup may stop early when the Kerberos/AFS tokens expire. If that happens, just rerun the commands until it completes successfully.


## Backup Script

Create the following script file as `/usr/local/bin/spideroak-backup.sh`:

~~~~
#!/bin/bash

# References:
# - http://stackoverflow.com/questions/637827/redirect-stderr-and-stdout-in-a-b$
# - http://linuxcommando.blogspot.com/2008/03/how-to-check-exit-status-code.html
# - http://stackoverflow.com/questions/64786/error-handling-in-bash
# - http://stackoverflow.com/questions/2275593/email-from-bash-script

backupLog=/var/log/backup-spideroak

# Call this function when an error occurs to log it (via email)
# and exit the script.
function error() {
	local CALLER_LINENO="$1"
	local MESSAGE="$2"
	local CODE="${3:-1}"

	local FULL_MESSAGE="Error on or near line ${CALLER_LINENO}: \"${MESSAGE}\". Exiting with status: ${CODE}."
	echo -e "$(date +%T) ${FULL_MESSAGE}" >> $backupLog
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

# The timelimit command is used below to stop the backups
# if they're hanging.

# Backup all of the justdavis.com AFS cell and ensure it 
# didn't drop any errors in the SpiderOak log.
echo "$(date +%T) Backup AFS: starting..." > $backupLog
timeoutAfs=$((60*60*4))
timelimit -t $timeoutAfs /usr/bin/SpiderOak --backup=/afs/justdavis.com &>> $backupLog
checkError ${LINENO} "Backup of AFS failed." $?
echo "$(date +%T) Backup AFS: completed." >> $backupLog
grep "[[:space:]]ERROR[[:space:]]" ~/.SpiderOak/*.log
[ $? -eq 0 ] && error ${LINENO} "SpiderOak backup log has errors."

# Backup the /etc directory on this server and ensure it 
# didn't drop any errors in the SpiderOak log.
echo "$(date +%T) Backup /etc: starting..." >> $backupLog
timeoutEtc=$((60*60*1))
timelimit -t $timeoutEtc /usr/bin/SpiderOak --backup=/etc &>> $backupLog
checkError ${LINENO} "Backup of /etc failed." $?
echo "$(date +%T) Backup /etc: completed." >> $backupLog
grep "[[:space:]]ERROR[[:space:]]" ~/.SpiderOak/*.log
[ $? -eq 0 ] && error ${LINENO} "SpiderOak backup log has errors."
~~~~

Mark the script as executable:

    $ sudo chmod a+x /usr/local/bin/spideroak-backup.sh

Create the log file the script will write to:

    $ sudo touch /var/log/backup-spideroak
    $ sudo chmod a+w /var/log/backup-spideroak

Make sure the script runs as expected:

    $ kdestroy
    $ kinit karl/admin
    $ aklog
    $ /usr/local/bin/spideroak-backup.sh


### Email Configuration

References:

* [ Re: How To: Command-Line Email as Simply as Possible, #13](http://ubuntuforums.org/showpost.php?p=6014887&postcount=13)

The above script makes use of the `mail` command, which requires configuration before it will work correctly. Specifically, the use of an SMTP gateway is required, as most ISPs and mail servers will block mails sent from random computers. The `msmtp` package can be used to route outgoing mail to a "real" SMTP server. Install the package:

    $ sudo apt-get install msmtp

Edit the system-wide `/etc/mail.rc` file to include the following setting:

    set sendmail=/usr/bin/msmtp

Edit the system-wide `/etc/msmtprc` file to include the configuration for the SMTP server to be used. Details on this configuration can be found by running `man msmtp`. For example, a configuration similar to the following was used on `eddings`:

~~~~
host		mail.justdavis.com
from		eddings@justdavis.com
auth		login
tls		on
user		eddings@justdavis.com
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

The above `spideroak-backup.sh` script can be run manually after a `kinit`-`aklog` login, but can't be set to run automatically via `cron` without some additional work. Specifically, the `cron` job would have no way of performing the login, as putting a Kerberos `/admin` password into a script is a terrible idea.

The alternative to putting the password in a plain-text script file is to make use of a [Kerberos keytab](http://kb.iu.edu/data/aumh.html). This, combined with a separate account to run the `cron` job, will provide a reasonable compromise between security and convenience.

First, create a "`backups`" user on `eddings` that can be used to access the keytab and run the `cron` job:

    $ sudo adduser --disabled-password backups

Note that, with the "`--disabled-password`" flag, this user account will have no password, and thus can't be logged into directly; `su` will have to be used, instead:

    $ sudo su - backups

Log in to the `backups` user, using `su` as above, and then create the Kerberos principal and keytab that will be used to perform the backups:

    $ kadmin -p karl/admin
    kadmin:  addprinc -policy services -randkey backups/afs
    kadmin:  ktadd -k /home/backups/backups.afs.keytab backups/afs
    kadmin:  quit

Give this Kerberos principal access to the AFS cell:

    $ kinit karl/admin
    $ aklog
    $ pts createuser -name backups.afs
    $ pts creategroup -name backups -owner system:administrators
    $ pts adduser -user backups.afs -group backups
    $ find /afs/.justdavis.com/ -type d -exec fs setacl {} \-acl backups read \;
    $ vos release -id root.cell -cell justdavis.com
    $ kdestroy

Now add the backup job (along with authentication) to the `backups` user's crontab, scheduled to run every day at 2am:

    $ crontab -e

Use the following entry:

~~~~
0   22  *   *   *     kinit backups/afs -k -t /home/backups/backups.afs.keytab; aklog; /usr/local/bin/spideroak-backup.sh; kdestroy; unlog
~~~~

Finally, initialize SpiderOak for the `backups` user, as above:

    $ SpiderOak --setup=-

When prompted, answer the questions as follows:

* Login: (the SpiderOak account name)
* Password: (the SpiderOak account password)
* Device ID: (select `eddings`)

At this point, everything should be ready to go. To ensure the script, is working, temporarily set the cron job's schedule to a time two minutes ahead of the clock, and then wait for the job to run. The last modification time on `/var/log/backup-spideroak` can be checked, as well.

