#!/bin/sh

tshark -n -r "$1" -q -z io,phs

