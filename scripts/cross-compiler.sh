#!/bin/bash
source config/variables.common
source config/${LJOS_ARCH}/components

for f in ${CROSS_COMPILER}; do
	scripts/build.sh $f cross-compiler
done
