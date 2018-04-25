#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

DISK="$1"
NAME="$2"
OUTPUTDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "DISK" "NAME" "OUTPUTDIR" && exit 1
	USAGE_DESCRIPTION "This script is meant to collect information about the filesystem(s) on a device and/or forensic image such that the analyst can get an idea of the volume/type/temporal data they're reviewing. Useful in making decisions on where to start a forensic analysis."
	USAGE_EXAMPLE "$(basename "$0") /dev/rdisk8 \"EVIDENCE_ID_2\" ~/<case data>/triage/"
fi

LOG="$OUTPUTDIR/$NAME.log"
START "$0" "$LOG" "$*"

if [ ! -f "$DISK" ]; then
	INFO "-----------------------------------------------------------------------" "$LOG"
	INFO "Display forensic operating system disk information (system_profiler)..." "$LOG"
	INFO "-----------------------------------------------------------------------" "$LOG"
	INFO "$(system_profiler SPUSBDataType SPParallelATADataType SPCardReaderDataType SPFireWireDataType SPHardwareRAIDDataType SPNVMeDataType SPParallelSCSIDataType SPSASDataType SPSerialATADataType SPThunderboltDataType | grep -B 14 -A 4 "BSD Name: $(basename "$DISK" | $SEDCMD -r 's/^r//')$" | $SEDCMD -r 's/^[[:space:]]*//; /^$/d')" "$LOG" | tee "$OUTPUTDIR/$NAME-system_profiler.txt"
	INFO "" "$LOG"

	INFO "-----------------------------------------------------------------------" "$LOG"
	INFO "Display forensic operating system disk information (diskutil)..." "$LOG"
	INFO "-----------------------------------------------------------------------" "$LOG"
	INFO "$(diskutil info "$DISK")" "$LOG" | tee "$OUTPUTDIR/$NAME-diskutil.txt"
	INFO "" "$LOG"
	INFO "$(diskutil list "$DISK")" "$LOG" | tee -a "$OUTPUTDIR/$NAME-diskutil.txt"
	INFO "" "$LOG"
	# TODO - diskutil apfs list/listUsers...; diskutil corestorage list/info...
else
	INFO "-----------------------------------------------------------------------" "$LOG"
	INFO "Show meta data stored in EWF files (ewfinfo)..." "$LOG"
	INFO "-----------------------------------------------------------------------" "$LOG"
	LOG_VERSION "ewfinfo" "$(ewfinfo -V)" "$LOG"
	INFO "$(ewfinfo "$DISK")" "$LOG" | tee "$OUTPUTDIR/$NAME-ewfinfo.txt"
	INFO "" "$LOG"
fi

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

INFO "-----------------------------------------------------------------------" "$LOG"
INFO "Collect MAC times from a disk image into a body file (tsk_gettimes)..." "$LOG"
INFO "-----------------------------------------------------------------------" "$LOG"
LOG_VERSION "tsk_gettimes" "$(tsk_gettimes -V)" "$LOG"
LOG_VERSION "datatime" "$(datatime --version)" "$LOG"
tsk_gettimes "$DISK" > "$OUTPUTDIR/$NAME.mct.tmp"
"${BASH_SOURCE%/*}/tsk-fix-mct.sh" "$OUTPUTDIR/$NAME.mct.tmp" "$NAME" | tee "$OUTPUTDIR/$NAME.mct" | datatime > "$OUTPUTDIR/$NAME-mct.txt"
if [ -e "$OUTPUTDIR/$NAME.mct" ]; then
	# Only delete the .mct.tmp file if the reprocessing was successful.
	rm "$OUTPUTDIR/$NAME.mct.tmp"
fi
head-tail.sh "$OUTPUTDIR/$NAME-mct.txt" 50
INFO "" "$LOG"

NOTIFY "Finished triage for $NAME ($DISK)!" "$0"
END "$0" "$LOG"

