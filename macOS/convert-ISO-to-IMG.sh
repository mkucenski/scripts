#!/bin/bash

SRC="$1"
DST="$2"

hdiutil convert -format UDRW -o "$DST" "$SRC"
mv "$DST"{.dmg,}


