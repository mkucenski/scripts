#!/bin/ash

VMDIR=$1
REPL=$2
WITH=$3
if [ $# -eq 0 ]; then
	echo "Usage: $(basename "$0") <VMDIR> <REPL> <WITH>" && exit 0
fi

if [ -e "$VMDIR/$REPL.vmx" ]; then
	cat "$VMDIR/$REPL.vmx" | sed -r "s/displayName = \"$REPL\"/displayName = \"$WITH\"/;s/annotation = \".*\"/annotation = \"$WITH\"/" > "$VMDIR/$WITH.vmx"
	diff "$VMDIR/$REPL.vmx" "$VMDIR/$WITH.vmx"
	rm "$VMDIR/$REPL.vmx"
else
	echo "ERROR! Unable to find '$VMDIR/$REPL.vmx'!" > /dev/stderr
fi
