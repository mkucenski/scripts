#!/bin/sh

escputil -i -u -r /dev/lpt0 | egrep "(Ink|Black|Cyan|Magenta|Yellow)"

