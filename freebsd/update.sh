#!/bin/sh

EMAIL=""

FBSD_UPDATE=`mktemp /tmp/freebsd-update.XXXXXXXX`
PORT_UPDATE=`mktemp /tmp/portsnap.XXXXXXXX`
PORT_VERSION=`mktemp /tmp/portversion.XXXXXXXX`
PORT_AUDIT=`mktemp /tmp/portaudit.XXXXXXXX`
COMBINED=`mktemp /tmp/portaudit.XXXXXXXX`

HOST=`hostname -s`

# If -o is specified on the command line, output to stdout. Otherwise
# send the output to $EMAIL specified above.
STDOUT="false"
if [ $# -eq 1 ]; then
	if [ "$1" = "-o" ]; then
		STDOUT="true"	
	fi
fi

# Download any system updates and mail notification to <root>
if [ $STDOUT = "true" ]; then	
	/usr/sbin/freebsd-update fetch >> $FBSD_UPDATE 2>&1
else
	/usr/sbin/freebsd-update cron >> $FBSD_UPDATE 2>&1
fi
if [ -s $FBSD_UPDATE ]; then
	echo "FreeBSD Updates (freebsd-update)" >> $COMBINED
	cat $FBSD_UPDATE | /usr/local/bin/gsed -r 's/^/\t/' >> $COMBINED
	echo "" >> $COMBINED
fi
rm $FBSD_UPDATE

# Update and index ports tree
if [ $STDOUT = "true" ]; then	
	/usr/sbin/portsnap fetch >> $PORT_UPDATE 2>&1
else
	/usr/sbin/portsnap cron >> $PORT_UPDATE 2>&1
fi
/usr/sbin/portsnap -I update >> $PORT_UPDATE 2>&1
rm $PORT_UPDATE

# Check for out-of-date ports
/usr/local/sbin/portversion -v -l "<" >> $PORT_VERSION 2>&1
if [ -s $PORT_VERSION ]; then
	echo "FreeBSD Outdated Ports (portsnap/portversion)" >> $COMBINED
	cat $PORT_VERSION | /usr/bin/grep -v "Updating the portsdb" | /usr/local/bin/gsed -r 's/^/\t/' >> $COMBINED
	echo "" >> $COMBINED
fi
rm $PORT_VERSION

# Fetch newest port vulnerability database and audit all installed ports
/usr/local/sbin/portaudit -Faq >> $PORT_AUDIT 2>&1
if [ -s $PORT_AUDIT ]; then
	echo "FreeBSD Port Vulnerabilities (portaudit)" >> $COMBINED
	cat $PORT_AUDIT | /usr/local/bin/gsed -r 's/^/\t/' >> $COMBINED
	echo "" >> $COMBINED
fi
rm $PORT_AUDIT

if [ -s $COMBINED ]; then
	if [ $STDOUT = "true" ]; then	
		cat $COMBINED
	else
		/usr/bin/mail -s "[$HOST] FreeBSD Update Check" $EMAIL < $COMBINED
	fi
fi
rm $COMBINED

