#!/usr/bin/env bash

set -euo pipefail
set -x

adb root
adb remount
adb shell setenforce 0

: "${REPLAY_FILE:?}"

### Installing replay APK
python android/scripts/gfxrecon.py install-apk android/tools/replay/build/outputs/apk/debug/replay-debug.apk

### Make sure that the trace file is readable
adb shell chmod 0666 "$REPLAY_FILE"

### Write replay parameters
python android/scripts/gfxrecon.py replay "$REPLAY_FILE"
