#!/usr/bin/env bash

tshark -n -r "$1" -q -z io,phs

