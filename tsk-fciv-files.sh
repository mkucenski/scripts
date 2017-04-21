#!/bin/bash
. $(dirname "$0")/common-include.sh

IMAGE="$1"
OFFSET="$2"
DOSHA1="$3"

KEY="1.75"

INFO "Creating Temporary RAM Disk for Processing..."
RAMDIR=$(mktemp -d -t $(basename "$0") || exit 1)
RV=$($(dirname "$0")/mkramdisk.sh 16 "$RAMDIR")
if [ -n "$RV" ]; then

	INFO "Building List of All Files Found in Image/Device..."
	MCT=$(mktemp $RAMDIR/$(basename "$0").mct.XXXXXXXX || exit 1)
	fls -o $OFFSET -m "" -F -r "$IMAGE" | $SEDCMD -r 's/^([[:digit:]]+\|)\/?/\1/' > "$MCT"

	INFO "Extracting and Hashing Each File..."
	pushd "$RAMDIR" 2>&1 > /dev/null
	$(dirname "$0")/fciv.sh 
	UNSORTED=$(mktemp $RAMDIR/$(basename "$0").md5.XXXXXXXX || exit 1)
	while read LINE; do
		if [ -n "$LINE" ]; then
			FILE=$($(dirname "$0")/tsk-mct-recover-files_worker.sh "$IMAGE" "$OFFSET" "./" "$LINE")
			if [ -n "$FILE" ]; then
				$(dirname "$0")/fciv_worker.sh "./$FILE" $DOSHA1 | tee -a "$UNSORTED" > /dev/stderr
				rm "./$FILE"
			fi
		else
			ERROR "Read invalid line!" "$0"
		fi
	done < "$MCT"

	INFO "Sorting Based on File Name..."
	sort --key=$KEY "$UNSORTED"
	popd 2>&1 > /dev/null

	$(dirname "$0")/rmramdisk.sh "$RAMDIR"
else
	ERROR "Unable to initialize RAM disk!" "$0"
	$(dirname "$0")/rmramdisk.sh "$RV"
fi

