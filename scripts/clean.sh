#!/bin/bash
source config/variables.common

rm -rf ${LJOS}
rm -rf ${BUILD_DIR}

if [ "$1" == "all" ]; then
	rm -rf ${SOURCE_DIR}
fi
