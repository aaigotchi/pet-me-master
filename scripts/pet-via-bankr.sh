#!/bin/bash
set -e

CONFIG_FILE="$HOME/.openclaw/workspace/skills/pet-me-master/config.json"
AAVEGOTCHI_SCRIPT="$HOME/.openclaw/workspace/skills/aavegotchi/scripts/pet.sh"

# Load config
GOTCHI_ID="${1:-$(jq -r ".gotchiIds[0]" "$CONFIG_FILE")}"

if [ -z "$GOTCHI_ID" ] || [ "$GOTCHI_ID" = "null" ]; then
  echo "Error: No gotchi ID provided"
  exit 1
fi

# Use the proven working method (Foundry cast with private key)
# Bankr integration is currently unreliable for Aavegotchi contract calls
if [ -f "$AAVEGOTCHI_SCRIPT" ]; then
  bash "$AAVEGOTCHI_SCRIPT" "$GOTCHI_ID"
  exit $?
fi

echo "Error: aavegotchi pet script not found at $AAVEGOTCHI_SCRIPT"
echo "Please ensure aavegotchi skill is installed"
exit 1
