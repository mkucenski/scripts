#!/bin/bash

SRC="$1"
DST="$2"

dd if="$SRC" of="$DST" bs=1m

