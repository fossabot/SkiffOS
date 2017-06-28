################################################################################
#
# lk
#
################################################################################

LK_BOARD_NAME = $(call qstrip,$(BR2_TARGET_LK_BOARDNAME))
LK_LICENSE = Unrestricted
LK_LICENSE_FILES = LICENSE
LK_INSTALL_IMAGES = YES
LK_INSTALL_TARGET = NO

LK_TARBALL = $(call qstrip,$(BR2_TARGET_LK_TARBALL_LOCATION))
LK_SITE = $(patsubst %/,%,$(dir $(LK_TARBALL)))
LK_SOURCE = $(notdir $(LK_TARBALL))
BR_NO_CHECK_HASH_FOR += $(LK_SOURCE)

# The kernel calls AArch64 'arm64', but Lk calls it just 'arm', so
# we have to special case it. Similar for i386/x86_64 -> x86
ifeq ($(KERNEL_ARCH),arm64)
LK_ARCH = arm
else ifneq ($(filter $(KERNEL_ARCH),i386 x86_64),)
LK_ARCH = x86
else
LK_ARCH = $(KERNEL_ARCH)
endif

LK_MAKE_OPTS += \
	TOOLCHAIN_PREFIX="$(TARGET_CROSS)" \
	ARCH=$(LK_ARCH) \
	HOSTCC="$(HOSTCC) $(HOST_CFLAGS)" \
	HOSTLDFLAGS="$(HOST_LDFLAGS)" \
	EMMC_BOOT=1 \
	SIGNED_KERNEL=0 \
	ENABLE_THUMB=false

define LK_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) 	\
		$(MAKE) -C $(@D) $(LK_MAKE_OPTS)		\
		$(LK_BOARD_NAME)
endef

define LK_INSTALL_IMAGES_CMDS
	cp -dpf $(@D)/build-$(LK_BOARD_NAME)/*.mbn \
		$(@D)/build-$(LK_BOARD_NAME)/lk \
		$(BINARIES_DIR)/
endef

#
# Check Lk board name config options
#
ifeq ($(LK_BOARD_NAME),)
$(error No Lk board name set. Check your BR2_TARGET_LK_BOARDNAME setting)
endif # LK_BOARD_NAME

#
# Check custom tarball option
#
ifeq ($(call qstrip,$(BR2_TARGET_LK_TARBALL_LOCATION)),)
$(error No Lk tarball specified. Check your BR2_TARGET_LK_TARBALL_LOCATION setting)
endif # qstrip BR2_TARGET_LK_TARBALL_LOCATION

$(eval $(generic-package))
