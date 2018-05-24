#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DISK="$1"
if [ $# -eq 0 ]; then
	USAGE "DISK" && exit 1
fi

system_profiler SPUSBDataType SPParallelATADataType SPCardReaderDataType SPFireWireDataType SPHardwareRAIDDataType SPNVMeDataType SPParallelSCSIDataType SPSASDataType SPSerialATADataType SPThunderboltDataType | grep -B 14 -A 4 "BSD Name: $(basename "$DISK" | $SEDCMD -r 's/^r//')" | $SEDCMD -r 's/^[[:space:]]*//; /^$/d'

