#!/bin/bash

# $1 = source directory of files
# $2 = destination root directory

find "$1" -type f | xargs -L 1 file --mime --separator \; | gsed -r 's/^([^;]+); ([^;]+); [^;]+$/\1 \2/' | xargs -L 1 -J {} $(dirname "$0")/sort-copy-by-mime-type_copy.sh {} "$2"

