#!/usr/bin/env bash

#Advanced Format (4k) sector size--most new drives should support
SSZ=4096

#Legacy standard sector size--Mac OS X seems to incorrectly probe as such
#SSZ=512
BUFSZ=$((4096 * $SSZ))

dc3dd if="$1" hofs="$2.000" log="$2.log" hlog="$2.hash" ofsz=4G verb=on hash=md5 hash=sha1 b10=on ssz=$SSZ bufsz=$BUFSZ

