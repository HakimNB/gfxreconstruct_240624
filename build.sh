#!/usr/bin/env bash

set -euo pipefail
set -x

cd android && ./gradlew assembleDebug
