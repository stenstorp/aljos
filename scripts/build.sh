#!/bin/bash
source variables/variables.common

mkdir -p ${BUILD_DIR}
unset name version source folder filename cross
unset _prepare _configure _make _install _post build

source ${COMPONENTS_DIR}/$1/info
filename="${source##*/}"

if [ "$2" != "cross-compiler" ]; then
	STAGE="build"
	source variables/cross-variables
else
	STAGE="cross-compiler"
fi

source ${COMPONENTS_DIR}/$1/${STAGE}

if [ ! -e "${SOURCE_DIR}/${filename}" ]; then
	wget -P ${SOURCE_DIR} ${source}
fi

echo "$1: extracting..."
tar -C ${BUILD_DIR} -xf ${SOURCE_DIR}/${filename}

if [ -z "${folder}" ]; then
	folder=${name}-${version}
fi

cd ${BUILD_DIR}/${folder}

if [ ! -e "${LOG_DIR}/$1" ]; then
	mkdir -p ${LOG_DIR}/$1
fi

if [ ! -z $(type -t _prepare) ]; then
	echo "$1: preparing..."
	_prepare &> ${LOG_DIR}/$1/$1-prepare.log || exit 1
fi

if [ ! -z $(type -t _configure) ]; then
	echo "$1: configuring..."
	_configure &> ${LOG_DIR}/$1/$1-configure.log || exit 1
fi

if [ ! -z $(type -t _make) ]; then
	echo "$1: making..."
	_make &> ${LOG_DIR}/$1/$1-make.log || exit 1
fi

if [ ! -z $(type -t _install) ]; then
	echo "$1: installing..."
	_install &> ${LOG_DIR}/$1/$1-install.log || exit 1
fi

if [ ! -z $(type -t _post) ]; then
	echo "$1: post scripts..."
	_post &> ${LOG_DIR}/$1/$1-post.log || exit 1
fi

cd ${BUILDROOT}
rm -rf ${BUILD_DIR}/${folder}
