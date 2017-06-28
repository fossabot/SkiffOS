#!/bin/bash
set -eo pipefail

BUILD_DIR="${SKIFF_BUILDROOT_DIR}/output/build/"
OUTPUT_DIR="${SKIFF_BUILDROOT_DIR}/output"
IMAGES_DIR="${OUTPUT_DIR}/images"
LINUX_DIR="${BUILD_DIR}/linux-custom"
RESOURCES_DIR="${SKIFF_CURRENT_CONF_DIR}/resources"
LINUX_CMDLINE="$(cat ${RESOURCES_DIR}/boot/cmdline)"

echo "Building dtb images..."
dtbtool -v \
	-o ${IMAGES_DIR}/dtb_master.bin \
	-p ${LINUX_DIR}/scripts/dtc/ \
  ${IMAGES_DIR}/

echo "Building boot image..."
set -x
mkbootimg --kernel ${IMAGES_DIR}/zImage \
					--cmdline "${LINUX_CMDLINE}" \
					--base 0x80200000 \
					--pagesize 2048 \
					--dt ${IMAGES_DIR}/dtb_master.bin \
					--output ${IMAGES_DIR}/boot.img
					--ramdisk_offset 0x02D00000 \
          --ramdisk ${IMAGES_DIR}/uInitrd
          # --ramdisk ${IMAGES_DIR}/rootfs.cpio
