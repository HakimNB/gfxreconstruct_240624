#!/usr/bin/env bash

set -euo pipefail
set -x

adb root
adb remount
adb shell setenforce 0

### Installing capture layer
adb shell mkdir -p /data/local/debug/vulkan
adb push \
    android/layer/build/intermediates/cmake/debug/obj/arm64-v8a/libVkLayer_gfxreconstruct.so \
    /data/local/debug/vulkan/libVkLayer_gfxreconstruct.so
adb shell chmod 777 -R /data/local/debug/vulkan
