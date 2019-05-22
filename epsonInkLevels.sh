#!/usr/bin/env bash

escputil -i -u -r /dev/lpt0 | egrep "(Ink|Black|Cyan|Magenta|Yellow)"

