#!/usr/bin/env bash

cd /usr/ports/$1
make fetch-required-list | fetch-to-wget.sh
