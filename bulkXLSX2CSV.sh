#!/usr/bin/env bash

for ARG in "$@"; do
	xlsx2csv -a "$ARG" "$ARG.csv"
done
