#!/bin/bash

export LC_CTYPE=C
tr -cd '\11\12\15\40-\176' < "$1"

