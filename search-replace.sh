#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SEARCH="$1"
REPLACE="$2"
BACKUPDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "CMD_TEMPLATE ('{}' will be substituted by each text file line)" "(stdin) TEXT_FILE"
	USAGE_DESCRIPTION "This script is meant to function similar to 'xargs -I {}'. It will replace every instance of '{}' in the command template with a line of text via STDIN, execute the resulting command, and repeat the process for each line."
	USAGE_EXAMPLE "cat file_list.txt | exec-per-line.sh \"copy-as-hash.sh {} dest_directory/\""
	exit 1
fi
INFO "SEARCH=$SEARCH"
INFO "REPLACE=$REPLACE"

if [ -e "$BACKUPDIR" ]; then
	while read -r FILE; do 
		INFO "Copying <$FILE> to <$BACKUPDIR>..."
		cp "$FILE" "$BACKUPDIR/"
		cat "$BACKUPDIR/$FILE" | $SEDCMD -r "s/$SEARCH/$REPLACE/g" > "$FILE"
	done < /dev/stdin
else
	ERROR "Backup directory does not exist!" "$0" && exit 1
fi

