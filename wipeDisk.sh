#!/bin/bash

echo "Wiping device ($1)..."
diskutil secureErase 0 "$1" 2>&1 | tee "$2"

