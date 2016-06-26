#!/bin/sh

hdiutil attach -readonly -nomount -imagekey diskimage-class=CRawDiskImage "$1"

