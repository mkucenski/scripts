#!/bin/bash

LOCALROOT="$1"
REMOTEROOT="$2"

LOG="$LOCALROOT/unison.log"
LOCKFILE="$LOCALROOT/unison.pid"

echo "LOCALROOT=$LOCALROOT"
echo "REMOTEROOT=$REMOTEROOT"
echo "LOG=$LOG"
echo "LOCK=$LOCKFILE"
echo

function LOCK {
	if [ -f "$LOCKFILE" ]; then
		PID=$(cat "$LOCKFILE")
		if kill -0 $PID >/dev/null 2>&1; then
			echo "WARNING($(basename "$0")): Active lock; script already running!" | tee -a "$LOG" > /dev/stderr
			echo "Press any key to continue..."
			read
			exit 1
		else
			echo "WARNING($(basename "$0")): Stale lock; removing ($LOCKFILE)" | tee -a "$LOG" > /dev/stderr
		fi
	fi

	echo $$ > "$LOCKFILE"
}

function UNLOCK {
   rm -f "$LOCKFILE"
}

LOCK

unison -backup "Name *" -backuploc "local" -logfile "$LOG" -auto -batch -confirmbigdel -fastcheck -contactquietly "$LOCALROOT" "$REMOTEROOT"

UNLOCK

echo "Press any key to continue..."
read

