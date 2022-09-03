#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEST="$1"
REGDIR="$2"

if [ $# -eq 0 ]; then
	USAGE "DEST" "ARG(S)"
	exit 1
fi
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	USAGE_DESCRIPTION "..."
	USAGE_EXAMPLE "$(basename "$0") ..."
	exit 1
fi

LOGFILE="$DEST/$(STRIP_EXTENSION "$(basename "$0")").log"
START "$0" "$LOGFILE" "$@"
LOG_VERSION "evtxexport" "$(evtxexport -V | grep "^evtxexport")" "$LOGFILE"

shift && shift
for EVTX in $@; do
	INFO "EVTX: $EVTX" "$LOGFILE"
	EVTX_NAME="$(STRIP_EXTENSION "$(basename "$EVTX")")"
	XML="$(MKTEMP $EVTX_NAME)"

	# evtxexport dumps individual XML documents for each record in the output file; 
	# wrapping it with '<Events>' makes the entire file a valid XML document for xq 
	# to process. 'tail +3' removes some extraneous junk at the beginning of the 
	# evtxexport output.
	echo "<Events>" > "$XML"
		CMD="evtxexport -f xml -l \"$LOGFILE\" -m all -r \"$REGDIR\" \"$EVTX\" | tail +3 >> \"$XML\""
		EXEC_CMD "$CMD" "$LOGFILE"
	echo "</Events>" >> "$XML"

	# xq converts to individual JSON records for a JSON-style log.
	JSON="$DEST/$EVTX_NAME.json"
	CMD="cat \"$XML\" | xq -c '.Events.Event[]' > \"$JSON\""
	EXEC_CMD "$CMD" "$LOGFILE"

	rm "$XML"
done

END "$0" "$LOGFILE"

# evtxexport 20220829
# 
# Use evtxexport to export items stored in a Windows XML Event Viewer
# Log (EVTX) file.
# 
# Usage: evtxexport [ -c codepage ] [ -f format ] [ -l log_file ]
#                   [ -m mode ] [ -p resource_files_path ]
#                   [ -r registy_files_path ] [ -s system_file ]
#                   [ -S software_file ] [ -t event_log_type ]
#                   [ -hTvV ] source
# 
# 	source: the source file
# 
# 	-c:     codepage of ASCII strings, options: ascii, windows-874,
# 	        windows-932, windows-936, windows-949, windows-950,
# 	        windows-1250, windows-1251, windows-1252 (default),
# 	        windows-1253, windows-1254, windows-1255, windows-1256
# 	        windows-1257 or windows-1258
# 	-f:     output format, options: xml, text (default)
# 	-h:     shows this help
# 	-l:     logs information about the exported items
# 	-m:     export mode, option: all, items (default), recovered
# 	        'all' exports the (allocated) items and recovered items,
# 	        'items' exports the (allocated) items and 'recovered' exports
# 	        the recovered items
# 	-p:     search PATH for the resource files
# 	-r:     name of the directory containing the SOFTWARE and SYSTEM
# 	        (Windows) Registry file
# 	-s:     filename of the SYSTEM (Windows) Registry file.
# 	        This option overrides the path provided by -r
# 	-S:     filename of the SOFTWARE (Windows) Registry file.
# 	        This option overrides the path provided by -r
# 	-t:     event log type, options: application, security, system
# 	        if not specified the event log type is determined based
# 	        on the filename.
# 	-T:     use event template definitions to parse the event record data
# 	-v:     verbose output to stderr
# 	-V:     print version
