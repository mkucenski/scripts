#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
# ENABLE_DEBUG=1

PST="$(FULL_PATH "$1")"
DEST="$2"
PST_BASE_NAME="$(STRIP_EXTENSION "$(basename "$PST")")"
INFOFILE="$(FULL_PATH "$DEST/$PST_BASE_NAME.txt")"
LOGFILE="$(FULL_PATH "$DEST/$PST_BASE_NAME.log")"
if [ $# -eq 0 ]; then
	USAGE "PST" "DEST" && exit $COMMON_ERROR
fi
DEBUG "PST=$PST, DEST=$DEST, PST_BASE_NAME=$PST_BASE_NAME, INFOFILE=$INFOFILE, LOGFILE=$LOGFILE" "$0"

RV=$COMMON_SUCCESS
START "$0" "$LOGFILE" "$*"

if [ ! -e "$DEST" ]; then
	mkdir -p "$DEST"
fi

pushd "$DEST"
pffinfo "$PST" | tee "$INFOFILE"
pffexport -f text -m items -l "$LOGFILE" -q "$PST"
popd

END "$0" "$LOGFILE"
exit $RV

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
# Use pffinfo to determine information about a Personal Folder File (OST, PAB and PST).
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
