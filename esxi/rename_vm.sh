#!/bin/ash

VMDIR=$1
REPL=$2
WITH=$3

#IFS=$'\n'; for FILE in $(ls "$VMDIR"); do
#	echo "$FILE"
#	NEW=$(echo "$FILE" | sed -r "s/$REPL/$WITH/")
#	if [ "$FILE" != "$NEW" ]; then
#		if [ "$FILE" != "$REPL.vmx"]; then
#			mv "$FILE" "$NEW"
#		fi
#	fi
#done

if [ -e "$VMDIR/$REPL.vmx" ]; then
	cat "$VMDIR/$REPL.vmx" | sed -r "s/displayName = \"$REPL\"/displayName = \"$WITH\"/;s/annotation = \".*\"/annotation = \"$WITH\"/" > "$VMDIR/$WITH.vmx"
	diff "$VMDIR/$REPL.vmx" "$VMDIR/$WITH.vmx"
	rm "$VMDIR/$REPL.vmx"
else
	echo "ERROR! Unable to find '$VMDIR/$REPL.vmx'!" > /dev/stderr
fi
