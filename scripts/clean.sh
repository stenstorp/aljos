#!/bin/bash
source variables

rm -rf ${LJOS}

if [ "$1" == "all" ]; then
	rm -rf ${BUILD_DIR}
	rm -rf ${SOURCE_DIR}
fi
