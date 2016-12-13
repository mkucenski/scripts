#!/bin/bash

VMDK="$1"
RAW="$2"

qemu-img convert -f vmdk "$VMDK" -O raw "$RAW"

