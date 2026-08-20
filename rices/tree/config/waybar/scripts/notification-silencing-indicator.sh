#!/bin/bash

if [[ $(omarchy-shell notifications isDnd 2>/dev/null) == "on" ]]; then
  echo '{"text": "󰂛", "tooltip": "Notifications silenced", "class": "active"}'
else
  echo '{"text": ""}'
fi
