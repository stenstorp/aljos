#!/bin/bash
source variables/variables.common

rm -rf ${LJOS}
rm -rf ${BUILD_DIR}
rm -rf ${LOG_DIR}

if [ "$1" == "all" ]; then
	rm -rf ${SOURCE_DIR}
fi
