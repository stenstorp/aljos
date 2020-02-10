#!/bin/bash
source variables/variables.common

COMPONENT=$1

unset name version source _prepare _configure _make _install
source ${COMPONENTS_DIR}/${COMPONENT}/info
source ${COMPONENTS_DIR}/${COMPONENT}/build
filename="${source##*/}"
if [ -z "${folder}" ]; then
        folder=${name}-${version}
fi

if [ ! -e ${COMPONENTS_DIR}/${COMPONENT} ]; then
	echo "Component \"${COMPONENT}\" not found"
	exit 1
fi

if [ -e ${LJOS}/build ]; then
	sudo rm -rf ${LJOS}/build
fi
mkdir ${LJOS}/build

if [ ! -e "${SOURCE_DIR}/${filename}" ]; then
        wget -P ${SOURCE_DIR} ${source}
fi

echo "$1: extracting..."
tar -C ${LJOS}/build -xf ${SOURCE_DIR}/${filename}

echo "export THREADS=${THREADS}" >> ${LJOS}/build/component-build_info
echo "export LJOS_HOST=${LJOS_HOST}" >> ${LJOS}/build/component-build_info
echo "export LJOS_TARGET=${LJOS_TARGET}" >> ${LJOS}/build/component-build_info
echo "export LJOS_CPU=${LJOS_CPU}" >> ${LJOS}/build/component-build_info
echo "export LJOS_ARCH=${LJOS_ARCH}" >> ${LJOS}/build/component-build_info
echo "export LJOS_ENDIAN=${LJOS_ENDIAN}" >> ${LJOS}/build/component-build_info
echo "export LJOS_BITS=${LJOS_BITS}" >> ${LJOS}/build/component-build_info
cat ${COMPONENTS_DIR}/${COMPONENT}/info >> ${LJOS}/build/component-build_info

mv ${LJOS}/build/${folder}/* ${LJOS}/build/
#mv ${LJOS}/build/${folder}/.* ${LJOS}/build/
rmdir ${LJOS}/build/${folder}

if [ "${LJOS_ARCH}" == "x86" ]; then
	COMPILE_ARCH=i686
else
	COMPILE_ARCH=${LJOS_ARCH}
fi

if [ "$(uname -m)" != "${COMPILE_ARCH}" ]; then
	if [ -e "$(which ${LJOS_QEMU})" ]; then
		cp `which ${LJOS_QEMU}` ${LJOS}/usr/bin/
	else
		echo "\"${LJOS_QEMU}\" not in path"
		exit 1
	fi
else
	LJOS_QEMU=""
fi

if [ "${LJOS_ARCH}" == "x86" ] && [ "$(uname -m)" == "x86_64" ]; then
	BITS="linux32"
else
	BITS=""
fi

if [ ! -e "${LOG_DIR}/${COMPONENT}" ]; then
	mkdir -p ${LOG_DIR}/${COMPONENT}
fi

if [ ! -z $(type -t _prepare) ]; then
	type _prepare | head --lines=-1 | tail --lines=+4 > ${LJOS}/build/component-build_prepare
        echo "$1: preparing..."
	sudo ${BITS} chroot ${LJOS} ${LJOS_QEMU} /bin/bash -c 'cd /build; source /build/component-build_info; source /build/component-build_prepare' &> ${LOG_DIR}/${COMPONENT}/${COMPONENT}-prepare.log || exit 1
fi

if [ ! -z $(type -t _configure) ]; then
	type _configure | head --lines=-1 | tail --lines=+4 > ${LJOS}/build/component-build_configure
        echo "$1: configuring..."
	sudo ${BITS} chroot ${LJOS} ${LJOS_QEMU} /bin/bash -c 'cd /build; source /build/component-build_info; source /build/component-build_configure' &> ${LOG_DIR}/${COMPONENT}/${COMPONENT}-configure.log || exit 1
fi

if [ ! -z $(type -t _make) ]; then
	type _make | head --lines=-1 | tail --lines=+4 > ${LJOS}/build/component-build_make
        echo "$1: building..."
	sudo ${BITS} chroot ${LJOS} ${LJOS_QEMU} /bin/bash -c 'cd /build; source /build/component-build_info; source /build/component-build_make' &> ${LOG_DIR}/${COMPONENT}/${COMPONENT}-make.log || exit 1
fi

if [ ! -z $(type -t _install) ]; then
	type _install | head --lines=-1 | tail --lines=+4 > ${LJOS}/build/component-build_install
        echo "$1: installing..."
	sudo ${BITS} chroot ${LJOS} ${LJOS_QEMU} /bin/bash -c 'cd /build; source /build/component-build_info; source /build/component-build_install' &> ${LOG_DIR}/${COMPONENT}/${COMPONENT}-install.log || exit 1
fi

if [ ! -z $(type -t _post) ]; then
	type _post | head --lines=-1 | tail --lines=+4 > ${LJOS}/build/component-build_post
        echo "$1: post tasks..."
	sudo ${BITS} chroot ${LJOS} ${LJOS_QEMU} /bin/bash -c 'cd /build; source /build/component-build_info; source /build/component-build_post' &> ${LOG_DIR}/${COMPONENT}/${COMPONENT}-post.log || exit 1
fi

sudo rm -rf ${LJOS}/build

if [ -e ${LJOS}/usr/bin/${LJOS_QEMU} ]; then
	sudo rm ${LJOS}/usr/bin/${LJOS_QEMU}
fi
