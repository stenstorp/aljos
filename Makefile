SHELL=bash

all: clean init cross-compiler system rootfs

cross-compiler:
	@${SHELL} scripts/cross-compiler.sh

system:
	@${SHELL} scripts/system.sh

init:
	@${SHELL} scripts/initial_setup.sh

clean:
	@${SHELL} scripts/clean.sh

clean-all:
	@${SHELL} scripts/clean.sh all

rootfs:
	@${SHELL} scripts/rootfs.sh
