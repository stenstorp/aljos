#!/bin/bash
source variables/variables.common
source variables/${LJOS_ARCH}/components

for f in ${SYSTEM}; do
	scripts/build.sh $f
done
