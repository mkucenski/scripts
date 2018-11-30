#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Wrapper to consistently run photorec for carving files

IMAGE="$(FULL_PATH "$1")"
DEST="$(FULL_PATH "$2")"
LOGFILE="$DEST/photorec.log"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "DEST" && exit 1
fi

# TODO The locations on this script need to be tweaked:
# 			The TAR will end up in the current directory, not the DEST
# 			However, the TAR can't go to the DEST directory or it will try to archive itself

# TODO TAR is also storing too much of the directory path--it's getting the full path instead of just the local, photorec output.

if [ ! -e "$DEST" ]; then
	mkdir -p "$DEST"
fi

START "$0" "$LOGFILE" "$*"

pushd "$DEST"

INFO "Starting photorec ($IMAGE)..." "$LOGFILE"
LOG_VERSION "photorec" "$(photorec /version)" "$LOGFILE"
CMD="photorec /log /d \"$DEST/\" \"$IMAGE\""
EXEC_CMD "$CMD" "$LOGFILE"
mkdir ./recup_dirs
mv recup_dir.* recup_dirs/

INFO "Starting hashing on all files..." "$LOGFILE"
${BASH_SOURCE%/*}/fciv_recursive.sh ./ 0 > "photorec.md5"

popd

# Copy/store the configuration file used
cp ~/.photorec.cfg "$DEST"/photorec.cfg

INFO "Archiving and hashing all files..." "$LOGFILE"
TAR="$(basename "$DEST").tgz"
tar czf "$TAR" "$DEST"
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
