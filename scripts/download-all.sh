#!/bin/bash
source config/variables.common

for f in ${COMPONENTS_DIR}/*; do
	unset name version source folder build filename

	source $f/build
	filename="${source##*/}"

	if [ ! -e ${SOURCE_DIR}/${filename} ]; then
		wget -c -P ${SOURCE_DIR} ${source}
	fi
done
