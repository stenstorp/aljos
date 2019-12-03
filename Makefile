SHELL=bash

all: init cross-compiler system rootfs

download-all:
	@${SHELL} scripts/download-all.sh

cross-compiler:
	@${SHELL} scripts/cross-compiler.sh

system:
	@${SHELL} scripts/system.sh

init: clean download-all
	@${SHELL} scripts/initial_setup.sh

clean:
	@${SHELL} scripts/clean.sh

clean-all:
	@${SHELL} scripts/clean.sh all

rootfs:
	@${SHELL} scripts/rootfs.sh
