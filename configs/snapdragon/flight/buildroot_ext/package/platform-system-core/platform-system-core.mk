################################################################################
#
# platform-system-core
#
################################################################################

PLATFORM_SYSTEM_CORE_LICENSE = MIT
PLATFORM_SYSTEM_CORE_VERSION = snapdragon/flight
PLATFORM_SYSTEM_CORE_SITE = https://github.com/paralin/platform_system_core/archive/$(PLATFORM_SYSTEM_CORE_VERSION)
PLATFORM_SYSTEM_CORE_SOURCE = qcom-platform-system-core.tar.gz

define HOST_PLATFORM_SYSTEM_CORE_BUILD_CMDS
	$(HOSTCC) $(HOST_CFLAGS) \
		-o $(@D)/dtbtool/dtbtool \
		$(@D)/dtbtool/dtbtool.c
	$(HOSTCC) $(HOST_CFLAGS) \
		-I$(@D)/include \
		-I$(@D)/mkbootimg \
		-o $(@D)/mkbootimg/mkbootimg \
		$(@D)/mkbootimg/mkbootimg.c \
		$(@D)/libmincrypt/rsa.c \
		$(@D)/libmincrypt/sha256.c \
		$(@D)/libmincrypt/sha.c
endef

define HOST_PLATFORM_SYSTEM_CORE_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/dtbtool/dtbtool $(HOST_DIR)/usr/bin/dtbtool
	$(INSTALL) -m 0755 -D $(@D)/mkbootimg/mkbootimg $(HOST_DIR)/usr/bin/mkbootimg
endef

$(eval $(host-generic-package))
