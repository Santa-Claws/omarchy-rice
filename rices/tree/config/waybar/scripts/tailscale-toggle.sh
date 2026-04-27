#!/bin/bash
STATUS=$(tailscale status --json 2>/dev/null | jq -r '.BackendState // "Stopped"')
if [[ "$STATUS" == "Running" ]]; then
    sudo tailscale down
else
    sudo tailscale up
fi
pkill -RTMIN+11 waybar
