#!/bin/bash
STATUS=$(warp-cli status 2>/dev/null)
if echo "$STATUS" | grep -q "Connected"; then
    echo '{"text": "󰒄", "tooltip": "WARP: Connected\nClick to disconnect", "class": "active"}'
else
    echo '{"text": "󰒃", "tooltip": "WARP: Disconnected\nClick to connect", "class": ""}'
fi
