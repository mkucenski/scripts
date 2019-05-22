#!/bin/bash

FILE="$1"
MIME="$2"
EXT="$3"
DST="$4"

mkdir -p "$DST"/"$MIME"
ln "$FILE" "$DST"/"$MIME/$(basename "$FILE").$EXT"

