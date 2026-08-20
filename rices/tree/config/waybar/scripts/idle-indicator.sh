#!/bin/bash

if [[ -f "$HOME/.local/state/omarchy/indicators/stay-awake" ]]; then
  echo '{"text": "󱫖", "tooltip": "Idle lock disabled", "class": "active"}'
else
  echo '{"text": ""}'
fi
