#!/bin/bash

FILE="$1"

$(dirname "$0")/convert2ascii.sh "$FILE" | cut -d '"' -f 4 | sort | uniq | sed '/MD5/d'

