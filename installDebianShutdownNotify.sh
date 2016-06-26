#!/bin/sh

cp debianShutdownNotify.sh /etc/init.d/

pushd /etc/rc0.d/
ln -s ../init.d/debianShutdownNotify.sh ./S00debianShutdownNotify.sh
popd

pushd /etc/rc6.d/
ln -s ../init.d/debianShutdownNotify.sh ./S00debianShutdownNotify.sh
popd

