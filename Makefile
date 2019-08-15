SHELL=bash

all: clean init cross-compiler system rootfs

cross-compiler: linux-headers-cc binutils-cc gcc-static-cc glibc-cc gcc-cc

system: busybox linux clfs-embedded-bootscripts zlib

init:
	@${SHELL} scripts/initial_setup.sh

clean:
	@${SHELL} scripts/clean.sh

clean-all:
	@${SHELL} scripts/clean.sh all

rootfs:
	@${SHELL} scripts/rootfs.sh

linux-headers-cc:
	@${SHELL} scripts/build.sh linux-headers-cc

binutils-cc:
	@${SHELL} scripts/build.sh binutils-cc

gcc-static-cc:
	@${SHELL} scripts/build.sh gcc-static-cc

glibc-cc:
	@${SHELL} scripts/build.sh glibc-cc

gcc-cc:
	@${SHELL} scripts/build.sh gcc-cc

busybox:
	@${SHELL} scripts/build.sh busybox

linux:
	@${SHELL} scripts/build.sh linux

clfs-embedded-bootscripts:
	@${SHELL} scripts/build.sh clfs-embedded-bootscripts

zlib:
	@${SHELL} scripts/build.sh zlib
