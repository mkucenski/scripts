#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

IMAGE="$1"
OUTPUTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OUTPUTDIR" && exit 1
fi

IMAGE_NAME="$(STRIP_EXTENSION "$(basename "$IMAGE")")"
LOG="$OUTPUTDIR/$IMAGE_NAME.log"

START "$0" "$LOG" "$*"

INFO "Display the partition layout of a volume system (mmls)..." "$LOG"
LOG_VERSION "mmls" "$(mmls -V)" "$LOG"
INFO "$(mmls -B -r "$IMAGE")" "$LOG" | tee "$OUTPUTDIR/$IMAGE_NAME-mmls.txt"

INFO "Display details about the volume system (mmstat)..." "$LOG"
LOG_VERSION "mmstat" "$(mmstat -V)" "$LOG"
INFO "$(mmstat "$IMAGE")" "$LOG" | tee "$OUTPUTDIR/$IMAGE_NAME-mmstat.txt"

INFO "Display general details of a file system (fsstat)..." "$LOG"
LOG_VERSION "fsstat" "$(fsstat -V)" "$LOG"
for PARTITION in $(_tsk_mmls_partitions "$IMAGE"); do
	OFFSET="$(_tsk_mmls_offset "$IMAGE" "$PARTITION")"
	INFO "$(fsstat -o $OFFSET "$IMAGE")" "$LOG" | tee "$OUTPUTDIR/$IMAGE_NAME-$PARTITION-fsstat.txt"
done

INFO "Collect MAC times from a disk image into a body file." "$LOG"
LOG_VERSION "tsk_gettimes" "$(tsk_gettimes -V)" "$LOG"
LOG_VERSION "datatime" "$(datatime --version)" "$LOG"
tsk_gettimes "$IMAGE" | tee "$OUTPUTDIR/$IMAGE_NAME.mct" | datatime > "$OUTPUTDIR/$IMAGE_NAME-mct.txt"
head-tail.sh "$OUTPUTDIR/$ID-mct.txt"

END "$0" "$LOG"

