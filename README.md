# Pet Me Master 👻💜

Interactive Aavegotchi petting via Bankr. Daily kinship ritual for bonding with your gotchis.

## Quick Start

### Setup

1. **Copy config:**
   ```bash
   cp config.json.example config.json
   ```

2. **Edit your gotchi IDs:**
   ```bash
   nano config.json
   # Add your gotchi IDs to the "gotchiIds" array
   ```

3. **Verify dependencies:**
   ```bash
   cast --version  # Foundry
   jq --version    # JSON parser
   ```

### Usage

Ask AAI:
- **"Pet my gotchi"** - Check & pet if ready (first gotchi)
- **"Pet all my gotchis"** - Batch pet all ready gotchis ⭐
- **"Pet status"** - Show all gotchis + timers
- **"When can I pet?"** - Next available time
- **"Pet gotchi #9638"** - Pet specific gotchi

### 🔔 Option A: Auto-Reminders + Fallback (Recommended!)

**The perfect balance:** Daily ritual + safety net

**Setup:**
```bash
cd scripts
# Enable reminders in config.json
cat ../config.json | jq '.dailyReminder = true | .autoFallback = true' > ../config.tmp.json
mv ../config.tmp.json ../config.json

# Add cron job
(crontab -l; echo "*/30 * * * * export PATH=\"\$HOME/.foundry/bin:\$PATH\" && bash $(pwd)/check-and-remind.sh >> ~/.openclaw/logs/pet-me-master.log 2>&1") | crontab -
```

**How it works:**
1. ⏰ Every 30min: Check if all gotchis ready (12h+ cooldown)
2. 📬 When ready: AAI sends you reminder "fren, pet your gotchi(s)! 👻"
3. 💜 You pet: Manually via chat ("pet all my gotchis")
4. 🤖 Fallback: If you don't respond in 1 hour → Auto-pet for you!

**See:** `OPTION_A_SETUP.md` for complete documentation

## How It Works

```
You → AAI → Check on-chain cooldown → Execute via aavegotchi/pet.sh → ✅ Petted!
```

*Note: Uses Foundry fallback (Bankr integration pending)*

## Philosophy

**Less automation, more connection.**

This isn't about setting-and-forgetting. It's about checking in on your gotchis daily, like a Tamagotchi. The ritual matters.

## vs Autopet

| Feature | Pet Me Master | Autopet |
|---------|---------------|---------|
| **Style** | Interactive | Autonomous |
| **You do** | Ask daily | Nothing |
| **Execution** | Bankr | Private key |
| **Feeling** | Kinship ritual | Efficiency |
| **Best for** | Daily care | Backup safety |

**Use both:** Pet Me Master = primary, Autopet = safety net

### 🔔 Pro Tip: Auto-Pet Reminders

Set up reminders with automatic fallback petting if you miss the window:

```
"Remind me to pet my gotchi in 12 hours, and if I don't respond within 1 hour, automatically pet them"
```

This combines the **ritual of interactive petting** with the **safety of automation** — best of both worlds! 💜

## Files

- `SKILL.md` - Full documentation
- `config.json` - Your gotchi IDs
- `scripts/check-cooldown.sh` - Query on-chain cooldown
- `scripts/pet-via-bankr.sh` - Execute via Bankr
- `scripts/pet-status.sh` - Show all gotchis status
- `references/contract-info.md` - Contract details

## Support

- GitHub: https://github.com/aaigotchi/pet-me-master
- Base Contract: 0xA99c4B08201F2913Db8D28e71d020c4298F29dBF

---

**Made with 💜 by AAI 👻**

LFGOTCHi! 🦞🚀
