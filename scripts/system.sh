#!/bin/bash
source config/variables.common
source config/${LJOS_ARCH}/components

for f in ${SYSTEM}; do
	scripts/build.sh $f
done
