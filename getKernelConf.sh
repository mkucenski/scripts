#!/bin/sh

strings -n 3 "$1" | sed -n 's/^___//p'
