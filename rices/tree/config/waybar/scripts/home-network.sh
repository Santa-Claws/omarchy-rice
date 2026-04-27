#!/bin/bash
# Replace these with your own machine IPs
MACHINE1_IP="192.168.1.100"
MACHINE2_IP="192.168.1.101"
MACHINE1_NAME="machine1"
MACHINE2_NAME="machine2"

ping -c1 -W1 "$MACHINE1_IP" &>/dev/null
MACHINE1_OK=$?

ping -c1 -W1 "$MACHINE2_IP" &>/dev/null
MACHINE2_OK=$?

MACHINE1_STATUS=$([[ $MACHINE1_OK -eq 0 ]] && echo "✓" || echo "✗")
MACHINE2_STATUS=$([[ $MACHINE2_OK -eq 0 ]] && echo "✓" || echo "✗")

TOOLTIP="${MACHINE1_NAME}: ${MACHINE1_STATUS}\\n${MACHINE2_NAME}: ${MACHINE2_STATUS}"

if [[ $MACHINE1_OK -eq 0 ]] || [[ $MACHINE2_OK -eq 0 ]]; then
    echo "{\"text\": \"󰋘\", \"tooltip\": \"${TOOLTIP}\", \"class\": \"active\"}"
else
    echo "{\"text\": \"󰅙\", \"tooltip\": \"${TOOLTIP}\", \"class\": \"\"}"
fi
