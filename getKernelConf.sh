#!/usr/bin/env bash

strings -n 3 "$1" | sed -n 's/^___//p'
