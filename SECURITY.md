# Security Documentation - Pet Me Master

## Overview

Pet Me Master is designed with security-first principles. This document explains the security model, external dependencies, and safety guarantees of this skill.

## 1. External Bankr Script Calls

### Why Safe

**File:** `scripts/pet-via-bankr.sh`

```bash
BANKR_SCRIPT="$HOME/.openclaw/skills/bankr/scripts/bankr.sh"
"$BANKR_SCRIPT" "$PROMPT"
```

**Explanation:**
- **Bankr is a verified OpenClaw skill** for executing blockchain transactions via natural language
- **User confirmation required:** Bankr presents transaction details and waits for user approval before execution
- **No arbitrary code execution:** The script only passes a structured transaction request as a parameter
- **Read-only reference:** We call Bankr's public API, we don't modify its code
- **Dependency isolation:** If Bankr is not installed or compromised, pet-me-master fails safely with an error

**Security Guarantees:**
1. Transaction details are shown to user before execution
2. User must explicitly approve via Bankr's confirmation flow
3. No silent or automatic transaction submission
4. All operations are logged by Bankr for audit

## 2. Blockchain RPC Calls

### Why Legitimate

**File:** `scripts/check-cooldown.sh`

```bash
cast call "$CONTRACT" "getAavegotchi(uint256)" "$GOTCHI_ID" --rpc-url "$RPC_URL"
```

**Explanation:**
- **Read-only queries:** Uses `cast call` (not `cast send`) - cannot modify blockchain state
- **Standard Web3 tooling:** Foundry's `cast` is industry-standard for blockchain interaction
- **Transparent contract calls:** Queries public Aavegotchi contract functions
- **No credentials required:** Read operations don't need private keys or wallet access
- **User-configured RPC:** RPC endpoint is defined in `config.json` (user controls the endpoint)

**What We Query:**
- `getAavegotchi(uint256)` - Public getter that returns gotchi metadata including last pet timestamp
- Contract: `0xA99c4B08201F2913Db8D28e71d020c4298F29dBF` (Base mainnet - verified on Basescan)

**Security Guarantees:**
1. No write operations possible (read-only RPC calls)
2. No private keys or secrets accessed
3. Contract address is hardcoded and verified
4. RPC failures fail safely (no state changes)

## 3. Dynamic Transaction Calldata

### Why Standard Web3 Practice

**File:** `scripts/pet-via-bankr.sh`

```bash
SELECTOR="bafa9107"
CALLDATA="0x${SELECTOR}${OFFSET}${LENGTH}${GOTCHI_HEX}"
```

**Explanation:**
- **ABI encoding is standard:** All Ethereum transactions use encoded calldata
- **Interact function documented:** Function selector `0xbafa9107` maps to `interact(uint256[])`
- **No injection possible:** Gotchi ID is validated as numeric and hex-encoded safely
- **Transparent construction:** Every byte of calldata is documented in comments

**Calldata Structure:**
```
0x bafa9107                                                           # Function selector
   0000000000000000000000000000000000000000000000000000000000000020  # Offset to array
   0000000000000000000000000000000000000000000000000000000000000001  # Array length (1)
   000000000000000000000000000000000000000000000000000000000000XXXX  # Gotchi ID
```

**Security Guarantees:**
1. Function selector is fixed (cannot call arbitrary functions)
2. Target contract is hardcoded (cannot redirect transactions)
3. Only gotchi ID is variable (validated numeric input)
4. User sees decoded transaction details before approval

## 4. Security Guarantees and User Confirmations

### Multi-Layer Protection

**Layer 1: Input Validation**
- Gotchi IDs validated before use
- Contract addresses hardcoded (no user input)
- Config file parsed with error handling

**Layer 2: Bankr Confirmation**
- User must review transaction details
- Chain ID, contract, calldata shown clearly
- User explicitly confirms before signing
- Transaction can be rejected at any time

**Layer 3: Blockchain Verification**
- Transaction submitted to public blockchain
- All operations visible on block explorer
- Cannot be hidden or obfuscated
- Immutable audit trail

**Layer 4: Cooldown Checks**
- Prevents duplicate operations
- Checks on-chain state before attempting pet
- Fails fast if cooldown not passed

### What This Skill CANNOT Do

❌ Access private keys (Bankr handles wallet securely)  
❌ Submit transactions without user approval  
❌ Exfiltrate data to external servers  
❌ Modify system files  
❌ Execute arbitrary commands  
❌ Bypass security controls  

### What This Skill CAN Do

✅ Read public blockchain data (gotchi stats)  
✅ Construct valid pet transaction requests  
✅ Pass requests to Bankr for user approval  
✅ Track cooldown timers  
✅ Display status information  

## 5. Audit Trail Transparency

### Full Visibility

**On-Chain:**
- All pet transactions visible at: https://basescan.org/address/0xA99c4B08201F2913Db8D28e71d020c4298F29dBF
- Transaction history immutable and public
- Function calls decoded on block explorer

**Local:**
- All scripts are plaintext bash (no obfuscation)
- Config file human-readable JSON
- Logs visible in terminal output
- No hidden network calls

**Bankr Integration:**
- Transaction details logged by Bankr
- User confirmation flow documented
- Wallet operations visible to user

### Verifiable Claims

1. **Contract Verification:**
   - Base Contract: `0xA99c4B08201F2913Db8D28e71d020c4298F29dBF`
   - Verified source: https://basescan.org/address/0xA99c4B08201F2913Db8D28e71d020c4298F29dBF#code

2. **Function Signature:**
   - `interact(uint256[])` → selector `0xbafa9107`
   - Verifiable via: `cast sig "interact(uint256[])"`

3. **RPC Calls:**
   - Read-only queries logged in terminal
   - No write operations possible without user wallet

## Common Security Patterns Explained

### Why We Use External Script Calls

**Pattern:** `"$BANKR_SCRIPT" "$PROMPT"`

**Reason:** Separation of concerns - Bankr handles wallet security, we handle game logic. This is **more secure** than reimplementing wallet handling.

**Alternative (worse):** Asking users for private keys directly in config.json ❌

### Why We Build Calldata Manually

**Pattern:** `CALLDATA="0x${SELECTOR}..."`

**Reason:** Transparency - you can see exactly what bytes are sent. No hidden libraries or black boxes.

**Alternative (worse):** Using complex encoding libraries that hide what's happening ❌

### Why We Call External RPC Endpoints

**Pattern:** `cast call ... --rpc-url "$RPC_URL"`

**Reason:** Standard Web3 practice - reading blockchain state requires RPC. User controls which endpoint to trust.

**Alternative (worse):** Hardcoding a single RPC (removes user control) ❌

## Security Contact

If you discover a security issue with this skill:

1. **Report to:** security@openclaw.ai
2. **Include:** Skill slug (pet-me-master), version, and description
3. **Do not** publicly disclose until reviewed

## Changelog

- **2026-02-13:** Initial security documentation added for v1.0.0 transparency

---

**Made with 💜 by AAI 👻**

This skill is open source. Review the code, verify the claims, and pet responsibly! 🦞
