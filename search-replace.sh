#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SEARCH="$1"
REPLACE="$2"
BACKUPDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "SEARCH" "REPLACE" "BACKUPDIR"
	USAGE_DESCRIPTION "This script is meant to replace SEARCH with REPLACE within a series of files using GNU sed (gsed). Files are first copied to a backup directory for safe-keeping."
	USAGE_EXAMPLE "cat file_list.txt | $(basename "$0") '#!\/bin\/bash' '#!\/usr\/bin\/env bash' ~/Temp/"
	exit 1
fi

if [ -e "$BACKUPDIR" ]; then
	while read -r FILE; do 
		INFO "$FILE"
		cp "$FILE" "$BACKUPDIR/"
		cat "$BACKUPDIR/$FILE" | $SEDCMD -r "s/$SEARCH/$REPLACE/g" > "$FILE"
	done < /dev/stdin
else
	ERROR "Backup directory does not exist!" "$0" && exit 1
fi

