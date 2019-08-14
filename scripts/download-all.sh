#!/bin/bash
source variables

for f in ${COMPONENTS_DIR}/*; do
	unset name version source folder build filename

	source $f
	filename="${source##*/}"

	if [ ! -e ${SOURCE_DIR}/${filename} ]; then
		wget -P ${SOURCE_DIR} ${source}
	fi
done
