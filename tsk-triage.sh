#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

DISK="$1"
NAME="$2"
OUTPUTDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "DISK" "OUTPUTDIR" && exit 1
fi

LOG="$OUTPUTDIR/$NAME.log"
START "$0" "$LOG" "$*"

INFO "-----------------------------------------------------------------------" "$LOG"
INFO "Display forensic operating system disk information (system_profiler)..." "$LOG"
INFO "-----------------------------------------------------------------------" "$LOG"
INFO "$(system_profiler SPUSBDataType SPParallelATADataType SPCardReaderDataType SPFireWireDataType SPHardwareRAIDDataType SPNVMeDataType SPParallelSCSIDataType SPSASDataType SPSerialATADataType SPThunderboltDataType | grep -B 14 -A 4 "BSD Name: $(basename "$DISK" | $SEDCMD -r 's/^r//')$" | $SEDCMD -r 's/^[[:space:]]*//; /^$/d')" "$LOG" | tee "$OUTPUTDIR/$NAME-system_profiler.txt"
INFO "" "$LOG"

INFO "-----------------------------------------------------------------------" "$LOG"
INFO "Display forensic operating system disk information (diskutil)..." "$LOG"
INFO "-----------------------------------------------------------------------" "$LOG"
INFO "$(diskutil info "$DISK")" "$LOG" | tee "$OUTPUTDIR/$NAME-diskutil.txt"
INFO "$(diskutil list "$DISK")" "$LOG" | tee -a "$OUTPUTDIR/$NAME-diskutil.txt"
INFO "" "$LOG"

INFO "-----------------------------------------------------------------------" "$LOG"
INFO "Display the partition layout of a volume system (mmls)..." "$LOG"
INFO "-----------------------------------------------------------------------" "$LOG"
LOG_VERSION "mmls" "$(mmls -V)" "$LOG"
INFO "$(mmls -B -r "$DISK")" "$LOG" | tee "$OUTPUTDIR/$NAME-mmls.txt"
INFO "" "$LOG"

INFO "-----------------------------------------------------------------------" "$LOG"
INFO "Display details about the volume system (mmstat)..." "$LOG"
INFO "-----------------------------------------------------------------------" "$LOG"
LOG_VERSION "mmstat" "$(mmstat -V)" "$LOG"
INFO "$(mmstat "$DISK")" "$LOG" | tee "$OUTPUTDIR/$NAME-mmstat.txt"
INFO "" "$LOG"

INFO "-----------------------------------------------------------------------" "$LOG"
INFO "Display general details of a file system (fsstat)..." "$LOG"
INFO "-----------------------------------------------------------------------" "$LOG"
LOG_VERSION "fsstat" "$(fsstat -V)" "$LOG"
for PARTITION in $(_tsk_mmls_partitions "$DISK"); do
	OFFSET="$(_tsk_mmls_offset "$DISK" "$PARTITION")"
	INFO "$PARTITION ($OFFSET):" "$LOG"
	INFO "$(fsstat -o $OFFSET "$DISK")" "$LOG" | tee "$OUTPUTDIR/$NAME-$PARTITION-fsstat.txt"
done
INFO "" "$LOG"

MCT_TMP=$(MKTEMP "$0" || exit 1)
INFO "-----------------------------------------------------------------------" "$LOG"
INFO "Collect MAC times from a disk image into a body file (tsk_gettimes)..." "$LOG"
INFO "$MCT_TMP" "$LOG"
INFO "-----------------------------------------------------------------------" "$LOG"
LOG_VERSION "tsk_gettimes" "$(tsk_gettimes -V)" "$LOG"
LOG_VERSION "datatime" "$(datatime --version)" "$LOG"
tsk_gettimes "$DISK" > "$MCT_TMP"
"${BASH_SOURCE%/*}/tsk-fix-mct.sh" "$MCT_TMP" "$NAME" | tee "$OUTPUTDIR/$NAME.mct" | datatime > "$OUTPUTDIR/$NAME-mct.txt"
head-tail.sh "$OUTPUTDIR/$NAME-mct.txt" 50
INFO "" "$LOG"
rm "$MCT_TMP"

NOTIFY "Finished triage for $NAME ($DISK)!" "$0"
END "$0" "$LOG"

