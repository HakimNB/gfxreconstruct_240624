#!/usr/bin/env bash

set -euo pipefail
set -x

adb root
adb remount
adb shell setenforce 0

: "${PACKAGE_NAME:?}"
: "${FRAMES:?}"

### Create API capture directory
adb shell mkdir -p "/data/apitrace/$PACKAGE_NAME"
adb shell chmod 777 "/data/apitrace/$PACKAGE_NAME"

### Setup capture layer
adb shell settings put global enable_gpu_debug_layers 1
adb shell settings put global gpu_debug_app "$PACKAGE_NAME"
adb shell settings put global gpu_debug_layers VK_LAYER_LUNARG_gfxreconstruct

adb shell setprop debug.gfxrecon.capture_file "/data/apitrace/$PACKAGE_NAME/capture.gfxr"
adb shell setprop debug.gfxrecon.capture_file_timestamp false
if [ "$FRAMES" -gt 0 ]; then
    adb shell setprop debug.gfxrecon.capture_android_trigger false
    adb shell setprop debug.gfxrecon.capture_trigger_frames "$FRAMES"
    # Needed for `capture_trigger_frames` to work correctly
    adb shell setprop debug.gfxrecon.capture_trigger dummy
fi
# Performance/data loss adjustments
adb shell setprop debug.gfxrecon.page_guard_persistent_memory true
adb shell setprop debug.gfxrecon.page_guard_align_buffer_sizes true
# Clean-up after setting up a trim
adb shell setprop debug.gfxrecon.capture_frames '""'

### Prompt for starting the trace
# shellcheck disable=2162
if [ "$FRAMES" -gt 0 ]; then
    read -p "Press Enter to start the trace"
    adb shell setprop debug.gfxrecon.capture_android_trigger true
fi
