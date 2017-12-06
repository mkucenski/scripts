#!/usr/bin/env bash

if [ -z "$1" ];
then
   ls -lA | gsed -r -f ~/Scripts/helpers/numericPermissions.sed
else
   ls -lA "$@" | gsed -r -f ~/Scripts/helpers/numericPermissions.sed
fi
