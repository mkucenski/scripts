#!/bin/sh

date -j -f "%Y%m%d %H:%M:%S %Z" "$1" "+%s"

