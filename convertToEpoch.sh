#!/bin/sh

date -j -f "%a %b %d %T %Y" "$1" "+%s"

