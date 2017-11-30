#!/bin/bash

CASE="$1"
LOCALROOT="$2"
REMOTEROOT="$3"

LOG="$LOCALROOT/$SUB/unison-sync.log"
LOCKFILE="$LOCALROOT/$SUB/unison-sync.pid"

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

SUB="App Case Data"
unison -backup "Name *" -backuploc "local" -logfile "$LOG" -auto -batch -confirmbigdel -fastcheck -contactquietly "$LOCALROOT/$SUB" "$REMOTEROOT/$SUB/Non-Contraband/$CASE"

SUB="Forensic Images"
unison -backup "Name *" -backuploc "local" -logfile "$LOG" -auto -batch -confirmbigdel -fastcheck -contactquietly "$LOCALROOT/$SUB" "$REMOTEROOT/$SUB/Non-Contraband/$CASE"

UNLOCK

echo "Press any key to continue..."
read

