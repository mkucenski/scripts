#!/bin/bash

find "$1" -type f -exec md5 {} \; | gsed -r 's/MD5 \((.+)\) = (.+)/\2,\1/' | sort | tee $TMPDIR/find_duplicates-all_files.txt | cut -f 1 -d , | uniq -d > $TMPDIR/find_duplicates-unique_hashes.txt; grep -i -f $TMPDIR/find_duplicates-unique_hashes.txt $TMPDIR/find_duplicates-all_files.txt

