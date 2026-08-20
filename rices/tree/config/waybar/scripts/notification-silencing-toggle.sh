#!/bin/bash

omarchy-toggle-notification-silencing "$@"
status=$?
pkill -RTMIN+10 -x waybar 2>/dev/null || true
exit "$status"
