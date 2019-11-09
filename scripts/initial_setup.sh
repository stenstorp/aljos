#!/bin/bash
source config/variables.common

mkdir -pv ${LJOS}

mkdir -pv ${LJOS}/{bin,boot/grub,dev,{etc/,}opt,home,lib/{firmware,modules},mnt}
mkdir -pv ${LJOS}/{proc,media/{floppy,cdrom},sbin,srv,sys}
mkdir -pv ${LJOS}/var/{lock,log,mail,run,spool}
mkdir -pv ${LJOS}/var/{opt,cache,lib/{misc,locate},local}
install -dv -m 0750 ${LJOS}/root
install -dv -m 1777 ${LJOS}{/var,}/tmp
install -dv ${LJOS}/etc/init.d
mkdir -pv ${LJOS}/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv ${LJOS}/usr/{,local/}share/{doc,info,locale,man}
mkdir -pv ${LJOS}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv ${LJOS}/usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}

# FIXME - make conditional
if [ "${LJOS_BITS}" == "64" ]; then
	ln -sv lib ${LJOS}/lib64
	ln -sv lib ${LJOS}/usr/lib64
fi

for dir in ${LJOS}/usr{,/local}; do
  ln -sv share/{man,doc,info} ${dir}
done

install -dv ${LJOS}/cross-tools{,/bin}
ln -svf ../proc/mounts ${LJOS}/etc/mtab

cp files/generic/passwd ${LJOS}/etc/passwd
cp files/generic/group ${LJOS}/etc/group
cp files/generic/fstab ${LJOS}/etc/fstab
cp files/generic/profile ${LJOS}/etc/profile
cp files/generic/HOSTNAME ${LJOS}/etc/HOSTNAME
cp files/generic/issue ${LJOS}/etc/issue
cp files/generic/inittab ${LJOS}/etc/inittab
cp files/generic/mdev.conf ${LJOS}/etc/mdev.conf

touch ${LJOS}/var/run/utmp ${LJOS}/var/log/{btmp,lastlog,wtmp}
chmod -v 664 ${LJOS}/var/run/utmp ${LJOS}/var/log/lastlog
