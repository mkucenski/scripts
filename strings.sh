#!/bin/bash

FILENAME=`basename "$1"`

gstrings -f -t x "$1" > "$TMPDIR/$FILENAME.txt"
gstrings -f -t x -e l "$1" >> "$TMPDIR/$FILENAME.txt"
gsort -n "$TMPDIR/$FILENAME.txt"
rm "$TMPDIR/$FILENAME.txt"

