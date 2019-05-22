#!/usr/bin/env bash

PREFIX=`echo ~`/Development/opt

./bootstrap \
	&& ./configure --prefix="$PREFIX" \
	&& make-wrapper.sh clean \
	&& make-wrapper.sh

