#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

PST="$1"
DESTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "PST" "DESTDIR" && exit 1
fi

DEST="$DESTDIR/$(STRIP_EXTENSION "$(basename "$PST")")"
LOGFILE="$DEST.log"
START "$0" "$LOGFILE" "$*"

CMD="pffinfo \"$PST\" | tee \"$DEST.txt\""
EXEC_CMD "$CMD" "$LOGFILE"

CMD="pffexport -l \"$DEST.log\" -q -t \"$DEST\" \"$PST\""
EXEC_CMD "$CMD" "$LOGFILE"

FILELIST=$(MKTEMP "$0")
if [ -e "$FILELIST" ]; then
	find "$DEST.export" -type f > "$FILELIST"
	MSGCOUNT="$(grep "Message\.txt" "$FILELIST" | cat -n | tail -n 1 | "$SEDCMD" -r 's/[[:space:]]*([[:digit:]]+)[[:space:]]*.*/\1/')"
	APPTCOUNT="$(grep "Appointment\.txt" "$FILELIST" | cat -n | tail -n 1 | "$SEDCMD" -r 's/[[:space:]]*([[:digit:]]+)[[:space:]]*.*/\1/')"
	INFO "Message.txt Count: $MSGCOUNT" "$DEST.txt"
	INFO "Appointment.txt Count: $APPTCOUNT" "$DEST.txt"
	rm "$FILELIST"
else 
	ERROR "Unable to build file list!" "$0" "$LOGFILE"
fi

END "$0" "$LOGFILE"
mv "$LOGFILE" "$DEST.export"
mv "$DEST.txt" "$DEST.export"

# pffexport 20170115
# 
# Use pffexport to export items stored in a Personal Folder File (OST, PAB
# and PST).
# 
# Usage: pffexport [ -c codepage ] [ -f format ] [ -l logfile ] [ -m mode ]
#                  [ -t target ] [ -dhqvV ] source
# 
# 	source: the source file
# 
# 	-c:     codepage of ASCII strings, options: ascii, windows-874,
# 	        windows-932, windows-936, windows-949, windows-950,
# 	        windows-1250, windows-1251, windows-1252 (default),
# 	        windows-1253, windows-1254, windows-1255, windows-1256
# 	        windows-1257 or windows-1258
# 	-d:     dumps the item values in a separate file: ItemValues.txt
# 	-f:     preferred output format, options: all, html, rtf,
# 	        text (default)
# 	-h:     shows this help
# 	-l:     logs information about the exported items
# 	-m:     export mode, option: all, debug, items (default), recovered.
# 	        'all' exports the (allocated) items, orphan and recovered
# 	        items. 'debug' exports all the (allocated) items, also those
# 	        outside the the root folder. 'items' exports the (allocated)
# 	        items. 'recovered' exports the orphan and recovered items.
# 	-q:     quiet shows minimal status information
# 	-t:     specify the basename of the target directory to export to
# 	        (default is the source filename) pffexport will add the
# 	        following suffixes to the basename: .export, .orphans,
# 	        .recovered
# 	-v:     verbose output to stderr
# 	-V:     print version

# pffinfo 20170115
# 
# Use pffinfo to determine information about a Personal Folder File (OST, PAB
# and PST).
# 
# Usage: pffinfo [ -c codepage ] [ -ahvV ] source
# 
# 	source: the source file
# 
# 	-a:     shows allocation information
# 	-c:     codepage of ASCII strings, options: ascii, windows-874,
# 	        windows-932, windows-936, windows-949, windows-950,
# 	        windows-1250, windows-1251, windows-1252 (default),
# 	        windows-1253, windows-1254, windows-1255, windows-1256
# 	        windows-1257 or windows-1258
# 	-h:     shows this help
# 	-v:     verbose output to stderr
# 	-V:     print version
