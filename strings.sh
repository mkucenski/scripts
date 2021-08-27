#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

if [ $# -eq 0 ]; then
	USAGE "FILE1" "FILE2" "FILE3" "..." && exit 1
fi
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then 
        USAGE_DESCRIPTION "Extract all available strings from a series of files, including, and sorted by, the string location. Output will be stored in the current directory as <FILE>.txt. To extract individual files with output to stdout, use 'strings_worker.sh' instead."
        USAGE_EXAMPLE "$(basename "$0") file1.exe file2.dll file3.bin (Will result in file1.exe.txt, file2.dll.txt, and file3.bin.txt.)"
        exit 1
fi

ENABLE_DEBUG=0
IFS=$(echo -en "\n\b")

INFO "Extracting strings for:"
for arg in "$@"; do
	if [ -e "$arg" ]; then
		OUTPUT="$(basename "$arg/")-strings.txt"
		# if [ -e "$OUTPUT" ]; then
		# 	ERROR "Output file <$OUTPUT> already exists!" && exit 1
		# else
			INFO "$arg -> $OUTPUT"
			${BASH_SOURCE%/*}/strings_worker.sh "$arg" > "$OUTPUT"
		# fi
	else
		ERROR "File <$arg> does not exist!" && exit 1
	fi
done

