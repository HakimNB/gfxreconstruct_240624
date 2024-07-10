#!/usr/bin/env bash

set -euo pipefail
set -x

adb root
adb remount

### Disabling VK layers
adb shell settings delete global enable_gpu_debug_layers
adb shell settings delete global gpu_debug_app
adb shell settings delete global gpu_debug_layers

### Removing replay APK
adb uninstall com.lunarg.gfxreconstruct.replay || true

### Removing layer
adb shell rm -rf /data/local/debug/vulkan/libVkLayer_gfxreconstruct.so
