#!/bin/bash
THELITTLEONE_IP="192.168.254.161"
NESTLECRUNCH_IP="192.168.254.84"
ALFRED1_IP="192.168.254.200"
ALFRED2_IP="192.168.254.210"
ALFRED3_IP="192.168.254.220"
ALFRED4_IP="192.168.254.230"

ping -c1 -W1 "$THELITTLEONE_IP" &>/dev/null
THELITTLEONE_OK=$?

ping -c1 -W1 "$NESTLECRUNCH_IP" &>/dev/null
NESTLECRUNCH_OK=$?

ping -c1 -W1 "$ALFRED1_IP" &>/dev/null
ALFRED1_OK=$?

ping -c1 -W1 "$ALFRED2_IP" &>/dev/null
ALFRED2_OK=$?

ping -c1 -W1 "$ALFRED3_IP" &>/dev/null
ALFRED3_OK=$?

ping -c1 -W1 "$ALFRED4_IP" &>/dev/null
ALFRED4_OK=$?

THELITTLEONE_STATUS=$([[ $THELITTLEONE_OK -eq 0 ]] && echo "✓" || echo "✗")
NESTLECRUNCH_STATUS=$([[ $NESTLECRUNCH_OK -eq 0 ]] && echo "✓" || echo "✗")
ALFRED1_STATUS=$([[ $ALFRED1_OK -eq 0 ]] && echo "✓" || echo "✗")
ALFRED2_STATUS=$([[ $ALFRED2_OK -eq 0 ]] && echo "✓" || echo "✗")
ALFRED3_STATUS=$([[ $ALFRED3_OK -eq 0 ]] && echo "✓" || echo "✗")
ALFRED4_STATUS=$([[ $ALFRED4_OK -eq 0 ]] && echo "✓" || echo "✗")

TOOLTIP="thelittleone: ${THELITTLEONE_STATUS}\\nnestlecrunch: ${NESTLECRUNCH_STATUS}\\nalfred1: ${ALFRED1_STATUS}\\nalfred2: ${ALFRED2_STATUS}\\nalfred3: ${ALFRED3_STATUS}\\nalfred4: ${ALFRED4_STATUS}"

if [[ $THELITTLEONE_OK -eq 0 ]] || [[ $NESTLECRUNCH_OK -eq 0 ]] || [[ $ALFRED1_OK -eq 0 ]] || [[ $ALFRED2_OK -eq 0 ]] || [[ $ALFRED3_OK -eq 0 ]] || [[ $ALFRED4_OK -eq 0 ]]; then
    echo "{\"text\": \"󰋘\", \"tooltip\": \"${TOOLTIP}\", \"class\": \"active\"}"
else
    echo "{\"text\": \"󰅙\", \"tooltip\": \"${TOOLTIP}\", \"class\": \"\"}"
fi
