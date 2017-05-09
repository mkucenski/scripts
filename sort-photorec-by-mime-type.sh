#!/bin/bash

# photorec output directory
SRC="$1"
DST="$2"

ls -d "$SRC"/recup_dir.* | xargs -L 1 -I {} ${BASH_SOURCE%/*}/sort-copy-by-mime-type.sh {} "$DST"
find "$DST" -type f -name "report.xml" -exec rm {} \;

