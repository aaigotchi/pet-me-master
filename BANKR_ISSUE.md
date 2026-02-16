# Bankr Integration Issue & Fix

**Date:** 2026-02-16  
**Status:** ⚠️ Workaround Implemented  
**Issue:** Bankr API not executing Aavegotchi contract calls

---

## 🐛 The Problem

When using `pet-via-bankr.sh` to pet Aavegotchis, the Bankr API:

1. ✅ Accepts the transaction request
2. ✅ Returns `"status": "completed"`
3. ❌ **But doesn't actually execute the transaction on-chain**

**Bankr Response:**
```json
{
  "success": true,
  "status": "completed",
  "response": "I don't have enough verified information to answer that question accurately."
}
```

### What We Tried

**Attempt 1: Raw transaction data**
```bash
PROMPT="Execute this transaction now (do not ask for confirmation): {\"to\": \"${CONTRACT}\", \"data\": \"${CALLDATA}\", \"value\": \"0\", \"chainId\": ${CHAIN_ID}}"
```
❌ Result: "I don't have enough verified information"

**Attempt 2: Descriptive prompt**
```bash
PROMPT="Send a transaction on Base chain to pet Aavegotchi #21785..."
```
❌ Result: Same error, transaction not executed

**Attempt 3: Multiple retries**
- Tried 5+ times for gotchi #21785
- Tried 5+ times for gotchi #10052
❌ Result: All "completed" but never executed on-chain

### What Actually Works

Using Foundry's `cast` directly with a private key:

```bash
cast send "$CONTRACT" \
  "interact(uint256[])" \
  "[$GOTCHI_ID]" \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY"
```

✅ Result: Transaction executes immediately and confirms on-chain

---

## ✅ The Fix

Updated `pet-via-bankr.sh` to **automatically use the working method**:

```bash
#!/bin/bash
set -e

CONFIG_FILE="$HOME/.openclaw/workspace/skills/pet-me-master/config.json"
AAVEGOTCHI_SCRIPT="$HOME/.openclaw/workspace/skills/aavegotchi/scripts/pet.sh"

# Load config
GOTCHI_ID="${1:-$(jq -r ".gotchiIds[0]" "$CONFIG_FILE")}"

# Use the proven working method (Foundry cast with private key)
if [ -f "$AAVEGOTCHI_SCRIPT" ]; then
  bash "$AAVEGOTCHI_SCRIPT" "$GOTCHI_ID"
  exit $?
fi

echo "Error: aavegotchi pet script not found"
exit 1
```

---

## 🔍 Root Cause Analysis

**Hypothesis:** Bankr's agent doesn't recognize the Aavegotchi contract or `interact()` function.

**Evidence:**
1. Bankr works fine for standard ERC-20 transfers
2. Bankr fails on custom contract functions
3. Response: "I don't have enough verified information" = Bankr doesn't know how to execute this

**Possible reasons:**
- Aavegotchi Diamond proxy contract is complex
- `interact(uint256[])` function not in Bankr's ABI database
- Base chain contract verification issues
- Bankr needs contract to be "registered" somehow

---

## 📋 Verification Test

**Test case:** Pet gotchi #9638, #21785, #10052

| Gotchi | Method | Result | Tx Hash | Notes |
|--------|--------|--------|---------|-------|
| #9638 | aavegotchi/pet.sh | ✅ Success | 0x56b897... | Worked immediately |
| #21785 | pet-via-bankr.sh | ❌ Failed | N/A | Bankr: "not enough info" |
| #21785 | aavegotchi/pet.sh | ✅ Success | 0xabdcab... | Worked immediately |
| #10052 | pet-via-bankr.sh | ❌ Failed | N/A | Bankr: "not enough info" |
| #10052 | aavegotchi/pet.sh | ✅ Success | 0xdad051... | Worked immediately |

**Conclusion:** Foundry method = 100% success rate, Bankr method = 0% success rate

---

## 🔄 Future Fix

**To properly fix Bankr integration:**

1. **Contact Bankr support** - Report the issue with Aavegotchi contract calls
2. **Provide contract details:**
   - Contract: `0xA99c4B08201F2913Db8D28e71d020c4298F29dBF` (Base mainnet)
   - Function: `interact(uint256[])` 
   - Selector: `0xbafa9107`
   - Use case: Petting Aavegotchi NFTs

3. **Alternative:** Use Bankr's raw transaction submission if they add support for:
   ```json
   {
     "to": "0xA99c4B...",
     "data": "0xbafa9107...",
     "value": "0",
     "chainId": 8453
   }
   ```

4. **Test again** once Bankr confirms support

---

## 📚 Related Files

- `scripts/pet-via-bankr.sh` - Fixed version (uses aavegotchi fallback)
- `scripts/pet-via-bankr-fixed.sh` - Experimental version with better prompts
- `SKILL.md` - Updated documentation explaining the issue
- `../aavegotchi/scripts/pet.sh` - The working method we now use

---

## 💡 Lessons Learned

1. **Always verify on-chain** - Don't trust API "success" responses
2. **Have fallbacks** - If integration fails, use proven methods
3. **Test thoroughly** - One success != reliable integration
4. **Document issues** - Help future debugging and Bankr support tickets

---

**Status:** ✅ **RESOLVED** (via workaround)  
**Next Steps:** Monitor Bankr updates, re-test integration quarterly

**LFGOTCHi!** 🦞💜
