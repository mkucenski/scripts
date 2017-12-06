#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Wrapper to consistently run photorec for carving files

IMAGE="$(FULL_PATH "$1")"
DEST="$(FULL_PATH "$2")"
LOGFILE="$DEST/photorec.log"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "DEST" && exit 1
fi

ulimit -n 10240
if [ $? -ne 0 ]; then 
	ERROR "Unable to set increased ulimit value! Try execution as 'root'." "$0" "$LOGFILE" && exit 1
fi

if [ ! -e "$DEST" ]; then
	mkdir -p "$DEST"
fi

START "$0" "$LOGFILE" "$*"

pushd "$DEST"

INFO "Starting photorec..." "$LOGFILE"
photorec /version >> "$LOGFILE" 2>> "$LOGFILE"
photorec /log /d "$DEST/" "$IMAGE" 2>> "$LOGFILE"
mkdir ./recup_dirs
mv recup_dir.* recup_dirs/

INFO "Starting hashing on all files..." "$LOGFILE"
${BASH_SOURCE%/*}/fciv_recursive.sh ./ 0 > "$(basename "$DEST").md5"

popd

INFO "Archiving and hashing all files..." "$LOGFILE"
TAR="$(basename "$DEST").tgz"
tar czvf "$TAR" "$DEST"
TAR_MD5=$(openssl md5 "$TAR")
echo "$TAR_MD5" > "$TAR.md5"
INFO "$TAR_MD5" "$LOGFILE"

END "$0" "$LOGFILE"

# PhotoRec 6.14, Data Recovery Utility, July 2013
# Christophe GRENIER <grenier@cgsecurity.org>
# http://www.cgsecurity.org
# 
# Usage: photorec [/log] [/debug] [/d recup_dir] [file.dd|file.e01|device]
#        photorec /version
# 
# /log          : create a photorec.log file
# /debug        : add debug information
# 
# PhotoRec searches various file formats (JPEG, Office...), it stores them
# in recup_dir directory.
# 
# If you have problems with PhotoRec or bug reports, please contact me.
