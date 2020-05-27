#!/bin/bash
source config
source variables/variables.common
source variables/${LJOS_ARCH}/components

for f in ${CROSS_COMPILER} ${SYSTEM} ${CROSS_SYSTEM}; do
	unset name version source folder build filename

	source ${COMPONENTS_DIR}/$f/info
	filename="${source##*/}"

	if [ ! -e ${SOURCE_DIR}/${filename} ]; then
		wget -c -P ${SOURCE_DIR} ${source}
	fi
done
