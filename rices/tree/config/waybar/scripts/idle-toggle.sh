#!/bin/bash

omarchy-toggle-idle "$@"
status=$?
pkill -RTMIN+9 -x waybar 2>/dev/null || true
exit "$status"
