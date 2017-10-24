#!/bin/bash

FILE="$1"
cat "$FILE" | gsed -r 's/<[^>]+>//g; /^[[:space:]]*$/d'

