# Changelog - pet-me-master

## [2.0.2] - 2026-02-22 - Flawless Edition Update

Re-release with complete documentation and GitHub sync.

## [2.0.1] - 2026-02-22 - Flawless Edition

### Added
- ✅ `scripts/check-status.sh` - Simple, reliable status checking entry point
- ✅ `USAGE_GUIDE.md` - Comprehensive usage documentation
- ✅ `FIX_PLAN.md` - Technical documentation of improvements

### Fixed
- 🐛 Standardized status checking to use reliable Node.js ethers method
- 🐛 Removed confusion from multiple status-checking approaches
- 🐛 Fixed AAI's status checks to always use accurate method

### Changed
- Status checking now exclusively uses `pet-status.sh` (via `check-status.sh` wrapper)
- Improved documentation clarity
- Simplified user workflows

### Technical Details
**Before:** Mixed methods (some using broken `cast` parsing)
**After:** Single reliable method using ethers.js

**Why:** The `cast call` method was incorrectly parsing the `lastInteracted` field from the contract, causing inaccurate cooldown calculations.

**Solution:** All status checks now route through the proven `pet-status.sh` script which uses Node.js ethers library.

### Impact
- ✅ 100% accurate status checks
- ✅ Consistent behavior across all commands
- ✅ Better user experience
- ✅ Easier maintenance

---

## [2.0.0] - 2026-02-13
- Bankr integration for secure petting
- Batch petting support
- Reminder system

## [1.3.0] - Previous
- Initial ClawHub release
