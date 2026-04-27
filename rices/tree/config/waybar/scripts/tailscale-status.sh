#!/bin/bash
STATUS=$(tailscale status --json 2>/dev/null | jq -r '.BackendState // "Stopped"')
if [[ "$STATUS" == "Running" ]]; then
    IP=$(tailscale ip -4 2>/dev/null | head -1)
    echo "{\"text\": \"󱔨\", \"tooltip\": \"Tailscale: Connected\\n${IP}\", \"class\": \"active\"}"
else
    echo '{"text": "󱔨", "tooltip": "Tailscale: Disconnected\nClick to connect", "class": ""}'
fi
