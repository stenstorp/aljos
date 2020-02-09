#!/bin/bash
source variables/variables.common

COMPONENT=$1

if [ ! -e ${COMPONENTS_DIR}/${COMPONENT} ]; then
	echo "Component \"${COMPONENT}\" not found"
	exit 1
fi

if [ -e ${LJOS}/build ]; then
	sudo rm -rf ${LJOS}/build
fi

mkdir ${LJOS}/build

unset name version source _prepare _configure _make _install
source ${COMPONENTS_DIR}/${COMPONENT}/info
source ${COMPONENTS_DIR}/${COMPONENT}/build

filename="${source##*/}"
if [ ! -e "${SOURCE_DIR}/${filename}" ]; then
        wget -P ${SOURCE_DIR} ${source}
fi

tar -C ${LJOS}/build -xf ${SOURCE_DIR}/${filename}

cp ${COMPONENTS_DIR}/${COMPONENT}/build ${LJOS}/build/component-build
echo "THREADS=${THREADS}" >> ${LJOS}/build/component-build
cat ${COMPONENTS_DIR}/${COMPONENT}/info >> ${LJOS}/build/component-build

if [ -z "${folder}" ]; then
        folder=${name}-${version}
fi

mv ${LJOS}/build/${folder}/* ${LJOS}/build/
rmdir ${LJOS}/build/${folder}

if [ -e "$(which ${LJOS_QEMU})" ]; then
	cp `which ${LJOS_QEMU}` ${LJOS}/usr/bin/
else
	echo "\"${LJOS_QEMU}\" not in path"
fi

if [ ! -z $(type -t _prepare) ]; then
        echo "$1: preparing..."
	sudo chroot ${LJOS} ${LJOS_QEMU} /bin/bash -c 'cd /build; source /build/component-build && _prepare' &> ${LOG_DIR}/${COMPONENT}/${COMPONENT}-prepare.log || exit 1
fi

if [ ! -z $(type -t _configure) ]; then
        echo "$1: configuring..."
	sudo chroot ${LJOS} ${LJOS_QEMU} /bin/bash -c 'cd /build; source /build/component-build && _configure' &> ${LOG_DIR}/${COMPONENT}/${COMPONENT}-configure.log || exit 1
fi

if [ ! -z $(type -t _make) ]; then
        echo "$1: building..."
	sudo chroot ${LJOS} ${LJOS_QEMU} /bin/bash -c 'cd /build; source /build/component-build && _make' &> ${LOG_DIR}/${COMPONENT}/${COMPONENT}-make.log || exit 1
fi

if [ ! -z $(type -t _install) ]; then
        echo "$1: installing..."
	sudo chroot ${LJOS} ${LJOS_QEMU} /bin/bash -c 'cd /build; source /build/component-build && _install' &> ${LOG_DIR}/${COMPONENT}/${COMPONENT}-install.log || exit 1
fi

if [ ! -z $(type -t _post) ]; then
        echo "$1: post tasks..."
	sudo chroot ${LJOS} ${LJOS_QEMU} /bin/bash -c 'cd /build; source /build/component-build && _post' &> ${LOG_DIR}/${COMPONENT}/${COMPONENT}-post.log || exit 1
fi

sudo rm -rf ${LJOS}/build
