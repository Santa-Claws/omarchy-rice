#!/bin/bash
if pgrep -x hypridle >/dev/null; then
    echo '{"text": "󰒳", "tooltip": "Idle: On (screen will sleep)\nClick to disable", "class": ""}'
else
    echo '{"text": "󱫖", "tooltip": "Idle: Off (screen stays awake)\nClick to enable", "class": "active"}'
fi
