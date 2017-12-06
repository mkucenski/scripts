#!/usr/bin/env bash

find "$1" -type d ! -name "CVS" -exec cvs add {} \;
find "$1" -type f ! -path "*CVS*" -exec cvs add {} \;

