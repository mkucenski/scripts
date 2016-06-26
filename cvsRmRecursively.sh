#!/bin/sh

find "$1" -type f ! -path "*CVS*" -exec ~/Scripts/cvsRm.sh {} \;

