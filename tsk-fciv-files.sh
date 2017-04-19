#!/bin/bash
. $(dirname "$0")/common-include.sh

IMAGE="$1"
OFFSET="$2"
DOSHA1="$3"

MCT=$(mktemp -t $(basename "$0") || exit 1)
fls -o $OFFSET -m "" -F -r "$IMAGE" | $SEDCMD -r 's/^([[:digit:]]+\|)\/?/\1/' > "$MCT"

KEY="1.75"
TMP=$(mktemp -t $(basename "$0") || exit 1)
TMPDIR=$(mktemp -d -t $(basename "$0") || exit 1)
pushd "$TMPDIR" 2>&1 > /dev/null

$(dirname "$0")/fciv.sh 

while read LINE; do
	if [ -n "$LINE" ]; then
		FILE=$($(dirname "$0")/tsk-mct-recover-files_worker.sh "$IMAGE" "$OFFSET" "./" "$LINE")
		if [ -n "$FILE" ]; then
			$(dirname "$0")/fciv_worker.sh "./$FILE" $DOSHA1 | tee -a "$TMP" > /dev/stderr
			rm "./$FILE"
		fi
	else
		ERROR "Read invalid line!" "$0"
	fi
done < "$MCT"

sort --key=$KEY "$TMP"
popd 2>&1 > /dev/null

