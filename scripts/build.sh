#!/bin/bash
source variables

mkdir -p ${BUILD_DIR}
unset name version source folder build filename

source ${COMPONENTS_DIR}/$1
filename="${source##*/}"

if [ ! -e ${SOURCE_DIR}/${filename} ]; then
	wget -P ${SOURCE_DIR} ${source}
fi

tar -C ${BUILD_DIR} -xf ${SOURCE_DIR}/${filename}

if [ -z "${folder}" ]; then
	folder=${name}-${version}
fi

cd ${BUILD_DIR}/${folder}

build

if [ -z "$2" ] || [ "$2" != "noclean" ]; then
	rm -rf ${BUILD_DIR}/${folder}
fi
