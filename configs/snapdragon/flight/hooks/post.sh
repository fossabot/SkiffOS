#!/bin/bash

set -eo pipefail

if echo ${SKIFF_CONFIG} | grep -q "snapdragon/flight_initrd" ; then
    echo "Initrd build detected, skipping building boot images.";
    exit 0
fi

echo "Building snapdragon flight boot images..."
${SKIFF_CURRENT_CONF_DIR}/scripts/build_boot_images.sh
