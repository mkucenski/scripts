#!/usr/bin/env bash

hdiutil attach -readonly -nomount -imagekey diskimage-class=CRawDiskImage "$1"

