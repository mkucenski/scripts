#!/bin/sh

find "$1" -type f | xargs -L 1 -I {} backupLinksHelper.sh {} "$2"
