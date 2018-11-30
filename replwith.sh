#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SRCFILE="$1"
REPL=$2
WITH=$3
if [ $# -eq 0 ]; then
	USAGE "SRCFILE" "REPL" "WITH" && exit 1
fi

BACKUP="$SRCFILE-$(DATE)$(TIME).bak"
if [ -e "$SRCFILE" ]; then
	if [ ! -e "$BACKUP" ]; then
		cp "$SRCFILE" "$BACKUP"
		cat "$BACKUP" | "$SEDCMD" -r "s/$REPL/$WITH/g" > "$SRCFILE"
		diff "$BACKUP" "$SRCFILE"
	else
		ERROR "Backup file ($BACKUP) already exists!" "$0"
	fi
else
	ERROR "Unable to find source file ($SRCFILE)!" "$0"
fi
