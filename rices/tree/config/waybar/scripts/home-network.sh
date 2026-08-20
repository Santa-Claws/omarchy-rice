#!/bin/bash
THELITTLEONE_IP="192.168.254.161"
NESTLECRUNCH_IP="192.168.254.84"

ping -c1 -W1 "$THELITTLEONE_IP" &>/dev/null
THELITTLEONE_OK=$?

ping -c1 -W1 "$NESTLECRUNCH_IP" &>/dev/null
NESTLECRUNCH_OK=$?

THELITTLEONE_STATUS=$([[ $THELITTLEONE_OK -eq 0 ]] && echo "✓" || echo "✗")
NESTLECRUNCH_STATUS=$([[ $NESTLECRUNCH_OK -eq 0 ]] && echo "✓" || echo "✗")

TOOLTIP="thelittleone: ${THELITTLEONE_STATUS}\\nnestlecrunch: ${NESTLECRUNCH_STATUS}"

if [[ $THELITTLEONE_OK -eq 0 ]] || [[ $NESTLECRUNCH_OK -eq 0 ]]; then
    echo "{\"text\": \"󰋘\", \"tooltip\": \"${TOOLTIP}\", \"class\": \"active\"}"
else
    echo "{\"text\": \"󰅙\", \"tooltip\": \"${TOOLTIP}\", \"class\": \"\"}"
fi
