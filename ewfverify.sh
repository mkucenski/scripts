#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

IMAGE="$1"
LOGFILE="$2"
if [ -z "$LOGFILE" ]; then
	LOGFILE="$(basename "$IMAGE")-ewfverify.log"
fi
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "LOGFILE (optional - defaults to \$IMAGE-ewfverify.log)" && exit 0
fi

ERR=-1
START "$0" "$LOGFILE"

FULL_IMAGE_PATH="$(cd $(dirname "$IMAGE"); pwd)/$(basename "$IMAGE")"
INFO "Image: $FULL_IMAGE_PATH" "$LOGFILE"

INFO "Executing ewfinfo ($IMAGE)..."
INFO "$(ewfinfo "$IMAGE" 2>&1)" "$LOGFILE"

INFO "Executing ewfverify ($IMAGE)..."
RESULT=$(ewfverify -l "$LOGFILE" -q "$IMAGE" 2>&1)
INFO "$RESULT" "$LOGFILE"

VERIFY=$(echo "$RESULT" | egrep "ewfverify: (SUCCESS|FAILURE)" | $SEDCMD -r 's/ewfverify: (.+)/\1/')
if [ "$VERIFY" == "SUCCESS" ]; then
	INFO "Successfully Verified!" "$LOGFILE"
	ERR=0
elif [ "$VERIFY" == "FAILURE" ]; then
	ERROR "Failure Verifying Image!" "$0" "$LOGFILE"
else
	ERROR "Unknown Error Verifying Image!" "$0" "$LOGFILE"
fi

END "$0" "$LOGFILE"

exit $ERR

# ewfverify 20140608
# 
# Use ewfverify to verify data stored in the EWF format (Expert Witness
# Compression Format).
# 
# Usage: ewfverify [ -A codepage ] [ -d digest_type ] [ -f format ]
#                  [ -l log_filename ] [ -p process_buffer_size ]
#                  [ -hqvVwx ] ewf_files
# 
# 	ewf_files: the first or the entire set of EWF segment files
# 
# 	-A:        codepage of header section, options: ascii (default),
# 	           windows-874, windows-932, windows-936, windows-949,
# 	           windows-950, windows-1250, windows-1251, windows-1252,
# 	           windows-1253, windows-1254, windows-1255, windows-1256,
# 	           windows-1257 or windows-1258
# 	-d:        calculate additional digest (hash) types besides md5,
# 	           options: sha1, sha256
# 	-f:        specify the input format, options: raw (default),
# 	           files (restricted to logical volume files)
# 	-h:        shows this help
# 	-l:        logs verification errors and the digest (hash) to the
# 	           log_filename
# 	-p:        specify the process buffer size (default is the chunk size)
# 	-q:        quiet shows minimal status information
# 	-v:        verbose output to stderr
# 	-V:        print version
# 	-w:        zero sectors on checksum error (mimic EnCase like behavior)
# 	-x:        use the chunk data instead of the buffered read and write
# 	           functions.

# ewfinfo 20140608
# 
# Use ewfinfo to determine information about the EWF format (Expert Witness
# Compression Format).
# 
# Usage: ewfinfo [ -A codepage ] [ -d date_format ] [ -f format ]
#                [ -ehimvVx ] ewf_files
# 
# 	ewf_files: the first or the entire set of EWF segment files
# 
# 	-A:        codepage of header section, options: ascii (default),
# 	           windows-874, windows-932, windows-936, windows-949,
# 	           windows-950, windows-1250, windows-1251, windows-1252,
# 	           windows-1253, windows-1254, windows-1255, windows-1256,
# 	           windows-1257 or windows-1258
# 	-d:        specify the date format, options: ctime (default),
# 	           dm (day/month), md (month/day), iso8601
# 	-e:        only show EWF read error information
# 	-f:        specify the output format, options: text (default),
# 	           dfxml
# 	-h:        shows this help
# 	-i:        only show EWF acquiry information
# 	-m:        only show EWF media information
# 	-v:        verbose output to stderr
# 	-V:        print version
