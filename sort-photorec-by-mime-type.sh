#!/bin/bash

# $1 = photorec output directory

ls -d "$1"/recup_dir.* | xargs -L 1 -I {} $(dirname "$0")/sort-copy-by-mime-type.sh {} "$1"/sorted
find "$1"/sorted -type f -name "report.xml" -exec rm {} \;

