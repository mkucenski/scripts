#!/bin/bash

OUTPUTFILE=`basename "$2"`
PSFILE="/tmp/$OUTPUTFILE.ps"

enscript -p "$PSFILE" "$1"
ps2pdf "$PSFILE" "$2"

rm "$PSFILE"

