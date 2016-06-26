#!/bin/sh

perl -F"\t" -lane 'print join ",", map {s/"/""/g; /^[\d.]+$/ ? $_ : qq("$_")} @F '
