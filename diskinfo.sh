#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEVICE="$1"
if [ $# -ne 1 ]; then
	USAGE "DEVICE" && exit 1
fi

OS=`uname`
if [ $OS = "Darwin" ]; then

	HWPROFILE="$(system_profiler SPUSBDataType SPParallelATADataType SPCardReaderDataType SPFireWireDataType SPHardwareRAIDDataType SPNVMeDataType SPParallelSCSIDataType SPSASDataType SPSerialATADataType SPThunderboltDataType | grep -B 14 -A 4 "BSD Name: $(basename "$DEVICE" | $SEDCMD -r 's/^r//')$" | $SEDCMD -r 's/^[[:space:]]*//; /^$/d')"
	VENDOR="$(echo "$HWPROFILE" | grep "Vendor ID:" | $SEDCMD -r 's/Vendor ID:[[:space:]]+0x[a-f0-9]+[[:space:]]+\((.+)\)/\1/')"
	SERIAL="$(echo "$HWPROFILE" | grep "Serial Number:" | $SEDCMD -r 's/Serial Number:[[:space:]]+(.+)/\1/')"
	INFO "macOS 'system_profiler' reported vendor: '$VENDOR', serial number: '$SERIAL'."

elif [$OS = "FreeBSD" ]; then

	HWPROFILE="$(camcontrol identify "$DEVICE")"
	MODEL="$(echo "$HWPROFILE" | grep 'device model' | $SEDCMD -r 's/^device model[[:space:]]+(.*)$/\1/')"
	SERIAL="$(echo "$HWPROFILE" | grep 'serial number' | $SEDCMD -r 's/^serial number[[:space:]]+(.*)$/\1/')"
	INFO "FreeBSD 'camcontrol' reported model: '$MODEL', serial number: '$SERIAL'..."

else

	INFO "No disk information available for this OS ($OS)..."

fi

