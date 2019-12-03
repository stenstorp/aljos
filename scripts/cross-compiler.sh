#!/bin/bash
source variables/variables.common
source variables/${LJOS_ARCH}/components

for f in ${CROSS_COMPILER}; do
	scripts/build.sh $f cross-compiler
done
