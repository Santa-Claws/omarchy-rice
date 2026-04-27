#!/bin/bash
STATUS=$(warp-cli status 2>/dev/null)
if echo "$STATUS" | grep -q "Connected"; then
    warp-cli disconnect
else
    warp-cli connect
fi
pkill -RTMIN+12 waybar
