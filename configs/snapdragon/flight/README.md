# Snapdragon Flight

Support for the Snapdragon Flight or "eagle" or "msm8974" board in Skiff is provided by this package.

Relevant references:

 - https://github.com/ATLFlight/meta-qti-repackage
 - https://github.com/mcharleb/meta-eagle8074
 - http://events.linuxfoundation.org/sites/events/files/slides/Using%20Openembedded%20with%20Snapdragon%20Flight.pdf
 - https://github.com/ATLFlight/cross_toolchain/blob/master/installsdk.sh
 
 In particular, the code for everything can be checked out with:
 
 ```bash
export MANIFEST_URI=git://codeaurora.org/quic/le/le/manifest
repo init -u $(MANIFEST_URI) -b release -m LNX.LER.1.0-68046-8x74.0.xml
repo sync -c --no-tags
 ```
 
 Most of the source is available on CodeAurora. Buildroot packages for compiling certain components exist under the buildroot_ext tree.

## Misc Notes

The tools used in the below commands are built automatically as part of the build process.

Making the boot image is done with: 

```
${STAGING_BINDIR_NATIVE}/dtbtool -o master_dt_image -p ${kernel}/scripts/dtc/ -v ${kernel_outputdir}/
${STAGING_BINDIR_NATIVE}/mkbootimg --kernel ${kernel_image} \
  --dt master_dt_image \
  --base 0x80200000 \
  --ramdisk ${WORKDIR}/initrd.img \
  --ramdisk_offset 0x02D00000 \
  --cmdline "${cmd_line}" \
  --pagesize 2048 \
  --output ${DEPLOY_DIR_IMAGE}/boot-${MACHINE}.img
```

General device info:

```
DEFAULTTUNE ?= "cortexa8hf-neon"
include conf/machine/include/tune-cortexa8.inc

MACHINE_ARCH = "arm"
HOST_OS = "linux-gnueabihf"
DPKG_ARCH = "armhf"

SERIAL_CONSOLE = "115200 ttyHSL0"
LK_ROOT_DEV = "/dev/mmcblk0p13"
LK_CMDLINE_OPTIONS += "prim_display=hdmi_msm"

PREFERRED_PROVIDER_virtual/kernel ?= "linux-qr-eagle8074"
PREFERRED_PROVIDER_kernel-module-wlan ?= "kernel-module-wlan"
PREFERRED_PROVIDER_kernel-module-cfg80211 ?= "linux-qr-eagle8074"

QRLINUX_DTB = "apq8074pro-ab-eagle.dtb \
    apq8074pro-ab-eagle-p2.dtb"

PACKAGE_GROUP_eagle8074-kernelmods = "kernel-module-wlan kernel-module-cfg80211"
MULTISTRAP_SECTION_eagle8074-kernelmods = "Modules"

PACKAGE_GROUP_ethernet-eagle8074 = "ethernet-eagle8074"

IMAGE_FEATURES += "eagle8074-kernelmods ethernet-eagle8074"
```
