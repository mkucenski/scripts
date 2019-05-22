#!/usr/bin/env bash

psearch -o "$1" | gsed -r 's/^([^ ]+) .*/\1/' | fgrep -v "`~/Scripts/listInstalledPorts.sh`"

