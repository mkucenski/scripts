#!/usr/bin/env bash

# $1 = Directory to prune (e.g. /usr/local/var/log/daemonlogger)
# $2 = Mount point for prune directory (e.g. /usr)
# $3 = Percentage threshold (e.g. 75)
# $4 = Number of files to delete if above threshold (e.g. 5)
# $5 = Prefix of files to delete if above threshold (e.g. daemonlogger.pcap.)

DIR="$1"
MOUNT="$2"
THRESHOLD=$3
DELCOUNT=$4
PREFIX="$5"
SCRIPT=`basename "$0"`

DIRSIZE=`/usr/bin/du -m -x -d 0 "$DIR" | /usr/local/bin/gsed -r 's/^([^[:space:]]+).*/\1/'`
MOUNTSIZE=`/bin/df -m "$2" | /usr/bin/tail -n +2 | /usr/local/bin/gsed -r s'/^[^[:space:]]+[[:space:]]+([^[:space:]]+).*/\1/'`
DIRPERCENT=`/bin/expr $DIRSIZE \* 100 / $MOUNTSIZE`

if [ $DIRPERCENT -gt $THRESHOLD ]; then
	echo "Removing $DELCOUNT files from \"$DIR\"..."
	ls -rth "$DIR"/${PREFIX}* | /usr/bin/head -n $DELCOUNT | /usr/bin/xargs -I {} rm -vf {}
else
	echo "\"$DIR\" is below threshold at ${DIRPERCENT}%. No files will be deleted."
fi

