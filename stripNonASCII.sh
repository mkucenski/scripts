#!/bin/sh

for ARG in "$@"; do
	cat "$ARG" | LC_CTYPE=C tr -cd '\11\12\15\40-\176' 
done
