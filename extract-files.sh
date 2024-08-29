#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/etc/camera/pureView_parameter.xml)
            sed -i 's/=\([0-9]\+\)>/="\1">/g' "${2}"
            ;;
        vendor/etc/camera/unicorn_enhance_motiontuning.xml|vendor/etc/camera/unicorn_motiontuning.xml)
            sed -i 's/xml=version/xml version/g' "${2}"
            ;;
        vendor/lib64/hw/audio.primary.taro-unicorn.so)
            "${PATCHELF_0_17_2}" --set-soname "audio.primary.taro-unicorn.so" "${2}"
            ;;
        vendor/lib64/hw/fingerprint.goodix_fod.default.so)
            "${PATCHELF_0_17_2}" --set-soname "fingerprint.goodix_fod.default.so" "${2}"
            ;;
        vendor/lib64/hw/fingerprint.goodix_fod6.default.so)
            "${PATCHELF_0_17_2}" --set-soname "fingerprint.goodix_fod6.default.so" "${2}"
            ;;
        vendor/lib64/libcamximageformatutils.so)
            "${PATCHELF_0_17_2}" --replace-needed "vendor.qti.hardware.display.config-V2-ndk_platform.so" "vendor.qti.hardware.display.config-V2-ndk.so" "${2}"
            ;;
        vendor/lib64/libkaraokepal.so)
            "${PATCHELF_0_17_2}" --replace-needed "audio.primary.taro.so" "audio.primary.taro-unicorn.so" "${2}"
            ;;
        vendor/lib64/libmialgo_basic.so)
            "${PATCHELF_0_17_2}" --set-soname "libmialgo_basic.so" "${2}"
            ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=unicorn
export DEVICE_COMMON=sm8450-common
export VENDOR=xiaomi

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
