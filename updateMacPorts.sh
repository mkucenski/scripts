#!/bin/sh

port -d selfupdate
#port -d sync
port fetch outdated
port -ucp upgrade outdated

