#!/bin/bash

omarchy-capture-screenrecording "$@"
status=$?
pkill -RTMIN+8 -x waybar 2>/dev/null || true
exit "$status"
