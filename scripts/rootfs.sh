#!/bin/bash
source config/variables.common

cp -rf ${LJOS}/ ${LJOS}-copy
rm -rfv ${LJOS}-copy/cross-tools
rm -rfv ${LJOS}-copy/usr/src/*

# FIXME - make lib64 conditional
FILES="$(ls ${LJOS}-copy/usr/lib64/*.a)"
for file in $FILES; do
	rm -f $file
done

find ${LJOS}-copy/{,usr/}{bin,lib,sbin} -type f -exec sudo strip --strip-debug '{}' ';'
find ${LJOS}-copy/{,usr/}lib64 -type f -exec sudo strip --strip-debug '{}' ';'

sudo chown -R root:root ${LJOS}-copy
sudo chgrp 13 ${LJOS}-copy/var/run/utmp ${LJOS}-copy/var/log/lastlog
sudo mknod -m 0666 ${LJOS}-copy/dev/null c 1 3
sudo mknod -m 0600 ${LJOS}-copy/dev/console c 5 1
sudo chmod 4755 ${LJOS}-copy/bin/busybox

cd ${LJOS}-copy/

sudo tar cfJ ../aljos-$(date +%Y%m%d).tar.xz *

cd ..
sudo rm -rf ${LJOS}-copy
