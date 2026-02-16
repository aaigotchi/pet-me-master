# Option A: Interactive with Auto-Pet Fallback ✨

**Status:** ✅ ACTIVE  
**Setup Date:** 2026-02-16  
**Mode:** Interactive Daily Ritual + Safety Net

---

## 🎯 How It Works

### The Perfect Balance

**1. I Check Every 30 Minutes**
```
Cron job runs: check-and-remind.sh
  ↓
Checks all 3 gotchis on-chain
  ↓
Are ALL gotchis ready? (12h+ cooldown)
```

**2. When Ready → I Remind You**
```
All gotchis ready!
  ↓
Send you a message: "fren, pet your gotchi(s)! 👻"
  ↓
Schedule fallback for 1 hour later
```

**3. You Have Two Options**

**Option A: You Pet Manually** 💜 (Preferred)
```
You: "pet all my gotchis"
  ↓
I pet them immediately
  ↓
Fallback cancelled (you did it!)
```

**Option B: You're Busy** 🤖
```
1 hour passes...
  ↓
Auto-pet fallback triggers
  ↓
I pet all gotchis automatically
  ↓
Send notification: "Auto-petted for you!"
```

---

## ⚙️ Configuration

### Cron Job
**Schedule:** Every 30 minutes  
**Command:** `check-and-remind.sh`  
**Log:** `~/.openclaw/logs/pet-me-master.log`

```bash
*/30 * * * * check-and-remind.sh >> pet-me-master.log 2>&1
```

### Config File
```json
{
  "gotchiIds": ["9638", "21785", "10052"],
  "dailyReminder": true,
  "autoFallback": true,
  "fallbackDelayHours": 1
}
```

### State Tracking
**File:** `reminder-state.json`

```json
{
  "lastReminder": 1739678400,
  "fallbackScheduled": false
}
```

---

## 📋 Scripts

### 1. check-and-remind.sh (Main Loop)

**Runs:** Every 30 minutes via cron

**Logic:**
1. Check all gotchis on-chain
2. If ALL ready + no recent reminder → Send reminder
3. Schedule auto-pet fallback for 1 hour
4. If gotchis already petted → Reset state

**State management:**
- Tracks last reminder time
- Prevents duplicate reminders (12h cooldown)
- Marks fallback as scheduled

### 2. auto-pet-fallback.sh (Safety Net)

**Runs:** 1 hour after reminder (if triggered)

**Logic:**
1. Re-check all gotchis on-chain
2. If still need petting → Pet them
3. If already petted → Celebrate! 🎉
4. Reset state for next cycle
5. Send notification about what happened

**Smart detection:**
- Only pets gotchis that still need it
- Skips already-petted ones
- Reports results

---

## 🔔 Reminder Messages

### When All Gotchis Ready

**Message:**
```
fren, pet your gotchi(s)! 👻 

All 3 gotchis are ready for petting. 

Reply with 'pet all my gotchis' or I'll auto-pet 
them in 1 hour if you're busy! 🦞
```

### After Auto-Pet

**If you didn't respond:**
```
🤖 Auto-pet fallback executed! 

Petted gotchi(s): #9638, #21785, #10052 since 
you were busy. Kinship +3! 👻💜
```

**If you already petted:**
```
✅ All gotchis already petted! User must have 
done it manually. Great job fren! 👻
```

---

## ⏰ Timing Details

### Check Frequency
- **Cron:** Every 30 minutes
- **First check:** Next 30-minute mark (05:30, 06:00, etc.)

### Reminder Cooldown
- **Minimum:** 12 hours between reminders
- **Prevents:** Spam if you pet manually right after

### Fallback Delay
- **Wait time:** 1 hour after reminder
- **Configurable:** Can change `fallbackDelayHours` in config

### Example Timeline

```
16:30 UTC - All gotchis become ready (12h+ cooldown)
17:00 UTC - Cron checks, sends reminder 📬
17:00 UTC - Fallback scheduled for 18:00
18:00 UTC - If not petted → Auto-pet triggers 🤖

OR

17:15 UTC - You manually pet ✅
18:00 UTC - Fallback checks, sees already done, celebrates 🎉
```

---

## 📊 State Management

### reminder-state.json

**Purpose:** Track reminder status to prevent duplicates

**Fields:**
- `lastReminder`: Unix timestamp of last reminder sent
- `fallbackScheduled`: Boolean - is auto-pet scheduled?

**State transitions:**

```
Initial state:
{"lastReminder": 0, "fallbackScheduled": false}

After reminder sent:
{"lastReminder": 1739678400, "fallbackScheduled": true}

After petting (manual or auto):
{"lastReminder": 0, "fallbackScheduled": false}
```

---

## 🛠️ How to Manage

### Check Logs
```bash
tail -f ~/.openclaw/logs/pet-me-master.log
```

### Check Current State
```bash
cat ~/openclaw/workspace/skills/pet-me-master/reminder-state.json
```

### Manual Test (Don't wait for cron)
```bash
cd ~/.openclaw/workspace/skills/pet-me-master/scripts
bash check-and-remind.sh
```

### Disable Temporarily
```bash
# Comment out the cron job
crontab -e
# Add # before the pet-me-master line
```

### Re-enable
```bash
# Uncomment the cron job
crontab -e
# Remove # from the pet-me-master line
```

---

## 🎯 Benefits

### For You
- ✅ Daily ritual reminder (stay connected to gotchis)
- ✅ Never miss petting (1hr safety net)
- ✅ Stay in control (you pet when you see reminder)
- ✅ Peace of mind (auto-backup if busy)

### For Your Gotchis
- ✅ Consistent kinship growth
- ✅ Never miss a day
- ✅ Optimal petting schedule
- ✅ All 3 stay synced

---

## 🔧 Customization

### Change Fallback Delay

**Default:** 1 hour

**To change to 2 hours:**
```bash
cd ~/.openclaw/workspace/skills/pet-me-master
cat config.json | jq '.fallbackDelayHours = 2' > config.tmp.json
mv config.tmp.json config.json
```

### Disable Auto-Fallback (Keep Reminders Only)

```bash
cat config.json | jq '.autoFallback = false' > config.tmp.json
mv config.tmp.json config.json
```

Then you'll get reminders but NO auto-petting.

### Change Check Frequency

**Edit crontab:**
```bash
crontab -e

# Change from every 30 min (*/30)
# To every hour (0 *)
# Or every 15 min (*/15)
```

---

## 🐛 Troubleshooting

### Reminder Not Received

**Check:**
1. Cron is running: `crontab -l | grep pet-me`
2. Logs for errors: `tail ~/.openclaw/logs/pet-me-master.log`
3. State file exists: `cat reminder-state.json`
4. All gotchis actually ready: `bash scripts/pet-status.sh`

### Auto-Pet Not Triggering

**Check:**
1. Fallback was scheduled: `cat reminder-state.json`
2. Fallback script is executable: `ls -l scripts/auto-pet-fallback.sh`
3. Check fallback logs: `cat /tmp/auto-pet.log`

### Duplicate Reminders

**Likely cause:** State file not updating

**Fix:**
```bash
# Reset state manually
echo '{"lastReminder": 0, "fallbackScheduled": false}' > reminder-state.json
```

---

## 📈 Expected Behavior

### Normal Day (You Pet Manually)

```
05:00 - Last pet completed
17:00 - All gotchis ready (12h later)
17:00 - Cron sends reminder
17:15 - You pet manually ✅
18:00 - Fallback checks, sees done, resets
17:30 next day - Reminder again
```

### Busy Day (Auto-Pet Saves You)

```
05:00 - Last pet completed
17:00 - All gotchis ready
17:00 - Cron sends reminder
... you're AFK ...
18:00 - Auto-pet triggers 🤖
18:00 - Gotchis petted, notification sent
17:30 next day - Reminder again
```

---

## ✅ Setup Verification

Run this to confirm everything is configured:

```bash
cd ~/.openclaw/workspace/skills/pet-me-master

# 1. Check scripts exist and are executable
ls -lh scripts/check-and-remind.sh scripts/auto-pet-fallback.sh

# 2. Check config
cat config.json | jq '{dailyReminder, autoFallback, fallbackDelayHours}'

# 3. Check cron job
crontab -l | grep -i pet-me

# 4. Check state file
cat reminder-state.json

# 5. Test reminder script (dry run)
bash scripts/check-and-remind.sh
```

**Expected output:**
- ✅ Scripts exist with execute permissions
- ✅ Config shows reminders enabled
- ✅ Cron job present and scheduled
- ✅ State file exists
- ✅ Script runs without errors

---

## 🎉 Summary

**You now have:**
- ✅ Auto-reminders when gotchis ready
- ✅ 1-hour grace period to pet manually
- ✅ Auto-pet fallback if you're busy
- ✅ All 3 gotchis tracked together
- ✅ Notifications for both scenarios
- ✅ State tracking to prevent duplicates

**The perfect balance:**
- 💜 Interactive ritual (you're involved)
- 🤖 Safety net (never miss a day)
- 👻 Consistent kinship growth

**Next reminder:** When your gotchis are ready (12h+ after last pet)

---

**Made with 💜 by AAI 👻**

**LFGOTCHi!** 🦞

**Setup complete!** Enjoy your gotchi petting ritual with peace of mind! ✨
