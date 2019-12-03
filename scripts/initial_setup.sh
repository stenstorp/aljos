#!/bin/bash
source variables/variables.common

mkdir -p ${LJOS}

mkdir -p ${LJOS}/{bin,boot/grub,dev,{etc/,}opt,home,lib/{firmware,modules},mnt}
mkdir -p ${LJOS}/{proc,media/{floppy,cdrom},sbin,srv,sys}
mkdir -p ${LJOS}/var/{lock,log,mail,run,spool}
mkdir -p ${LJOS}/var/{opt,cache,lib/{misc,locate},local}
install -d -m 0750 ${LJOS}/root
install -d -m 1777 ${LJOS}{/var,}/tmp
install -d ${LJOS}/etc/init.d
mkdir -p ${LJOS}/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -p ${LJOS}/usr/{,local/}share/{doc,info,locale,man}
mkdir -p ${LJOS}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -p ${LJOS}/usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}

if [ "${LJOS_BITS}" == "64" ]; then
	ln -s lib ${LJOS}/lib64
	ln -s lib ${LJOS}/usr/lib64
fi

for dir in ${LJOS}/usr{,/local}; do
  ln -s share/{man,doc,info} ${dir}
done

install -d ${LJOS}/cross-tools{,/bin}
ln -sf ../proc/mounts ${LJOS}/etc/mtab

cp files/generic/passwd ${LJOS}/etc/passwd
cp files/generic/group ${LJOS}/etc/group
cp files/generic/fstab ${LJOS}/etc/fstab
cp files/generic/profile ${LJOS}/etc/profile
cp files/generic/HOSTNAME ${LJOS}/etc/HOSTNAME
cp files/generic/issue ${LJOS}/etc/issue
cp files/generic/inittab ${LJOS}/etc/inittab
cp files/generic/mdev.conf ${LJOS}/etc/mdev.conf

if [ "${LJOS_ARCH}" == "arm" ]; then
	cp files/arm/cmdline.txt ${LJOS}/boot
	cp files/arm/config.txt ${LJOS}/boot
fi

touch ${LJOS}/var/run/utmp ${LJOS}/var/log/{btmp,lastlog,wtmp}
chmod 664 ${LJOS}/var/run/utmp ${LJOS}/var/log/lastlog
