#!/bin/bash
set -e

CONFIG_FILE="$HOME/.openclaw/workspace/skills/pet-me-master/config.json"
BANKR_SCRIPT="$HOME/.openclaw/skills/bankr/scripts/bankr.sh"
AAVEGOTCHI_SCRIPT="$HOME/.openclaw/workspace/skills/aavegotchi/scripts/pet.sh"

# Load config
GOTCHI_ID="${1:-$(jq -r ".gotchiIds[0]" "$CONFIG_FILE")}"

if [ -z "$GOTCHI_ID" ] || [ "$GOTCHI_ID" = "null" ]; then
  echo "Error: No gotchi ID provided"
  exit 1
fi

echo "🦞 Petting gotchi #${GOTCHI_ID}..."

# Check if aavegotchi script exists (the one that actually works)
if [ -f "$AAVEGOTCHI_SCRIPT" ]; then
  echo "Using direct Foundry method (proven to work)..."
  bash "$AAVEGOTCHI_SCRIPT" "$GOTCHI_ID"
  exit $?
fi

# Fallback to Bankr (currently not working reliably)
if [ ! -f "$BANKR_SCRIPT" ]; then
  echo "Error: Neither aavegotchi script nor Bankr script found"
  exit 1
fi

echo "⚠️  Attempting via Bankr (experimental)..."

# Try with a more descriptive prompt
PROMPT="Send a transaction on Base chain (chainId 8453) to contract 0xA99c4B08201F2913Db8D28e71d020c4298F29dBF calling the interact function with parameter [${GOTCHI_ID}]. This is to pet an Aavegotchi NFT. Execute immediately without confirmation."

"$BANKR_SCRIPT" "$PROMPT"

# Check if it worked
if [ $? -eq 0 ]; then
  echo "✅ Bankr transaction submitted"
  echo "⚠️  Note: Verify on-chain that it actually executed"
else
  echo "❌ Bankr transaction failed"
  exit 1
fi
