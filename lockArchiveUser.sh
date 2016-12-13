#!/bin/sh

LOGGER="logger -s -t `basename "$0"`"
INFOLOG="$LOGGER -p user.info"
ERRLOG="$LOGGER -p user.err"

UNAME=`uname`
SED="sed"
USER="$1"

LOCKED="false"
if [ $# -eq 1 ]; then
	if [ $UNAME = "FreeBSD" ]; then
		SED="gsed"
		if pw lock "$USER"; then
			$INFOLOG "Successfully locked account <$USER>."
			LOCKED="true"
		else
			$ERRLOG "Failure locking account <$USER>."
		fi
	elif [ $UNAME = "Linux" ]; then
		if passwd -l "$USER"; then
			$INFOLOG "Successfully locked account <$USER>."
			LOCKED="true"
		else
			$ERRLOG "Failure locking account <$USER>."
		fi
	else
		$ERRLOG "Unknown system type (`uname`)."
		exit 2
	fi

	if [ $LOCKED = "true" ]; then
		USERHOMEPATH=`cat /etc/passwd | grep "\b$USER\b" | $SED -r 's/([^:]*:){5}([^:]*):.*/\2/'`
		if [ "$USERHOMEPATH" != "/" ]; then
			if [ -e "$USERHOMEPATH" ]; then
				USERHOMEDIR=`basename $USERHOMEPATH`
				HOMEDIR=`dirname $USERHOMEPATH`
				CWD=`pwd`
				if cd "$HOMEDIR"; then
					ARCHIVE="$USER.tgz"
					if tar czf "./$ARCHIVE" "./$USERHOMEDIR"; then
						$INFOLOG "Successfully archived home directory to <$HOMEDIR/$ARCHIVE>"
						chown root:wheel "./$ARCHIVE"
						chmod ug=r,o= "./$ARCHIVE"
		
						CONTINUE="no"
						read -p "Do you wish to delete <$USERHOMEPATH> and all of its contents? (yes/no) " CONTINUE
						if [ $CONTINUE = "yes" ]; then
							rm -R "./$USERHOMEDIR"
							$INFOLOG "Deleted home directory <$USERHOMEPATH> for <$USER>."
						fi
					else
						$ERRLOG "Failure archiving <$USERHOMEDIR> to <$ARCHIVE>."
					fi
					cd "$CWD"
				else
					$ERRLOG "Failure accessing <$HOMEDIR>."
				fi
			else
				$ERRLOG "Home directory <$USERHOMEPATH> does not exist."
			fi
		else
			$ERRLOG "Home directory for <$USER> set to <$USERHOMEPATH>.  Cannot proceed."
		fi
	fi
else
	echo "You must specify a username (e.g. $0 <username>)"
fi

exit 0

