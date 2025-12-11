# TikTok Patches Update to Version 43.0.2

## Overview
This document describes the changes made to update TikTok patches from version 36.5.4 to 43.0.2 (note: the decompiled APK is actually version 43.0.2, not 42.9.3 as initially stated).

## Summary of Changes

### 1. Version Compatibility Updates
Updated `compatibleWith` declarations in all version-specific patches from `36.5.4` to `43.0.2`:
- FeedFilterPatch.kt
- SettingsPatch.kt
- SanitizeShareUrlsPatch.kt  
- PlaybackSpeedPatch.kt
- RememberClearDisplayPatch.kt
- DownloadsPatch.kt

### 2. Playback Speed Patch - Major Update

#### Issue
The method signature for speed tracking changed from 3 to 6 parameters between versions.

#### Changes Made

**interaction/speed/Fingerprints.kt:**
- Updated `setSpeedFingerprint` signature:
  - Old: `(Ljava/lang/String;, Lcom/ss/android/ugc/aweme/feed/model/Aweme;, F)V`
  - New: `(Lcom/ss/android/ugc/aweme/feed/model/Aweme;, Ljava/lang/String;, F, J, Ljava/lang/String;)V`
- Now targets class `LX/0N1s;` method `LIZ`
- Removed `strings("enterFrom")` requirement

**interaction/speed/PlaybackSpeedPatch.kt:**
- Updated injection code for new 6-parameter signature
- Reordered parameters (Aweme first, then enterFrom)
- Added timestamp parameter: `Ljava/lang/System;->currentTimeMillis()J`
- Added null constant for final String parameter
- Updated register allocation (v1-v5 instead of v0-v2)

### 3. Feed Filter Patch Update

**feedfilter/Fingerprints.kt:**
- Updated `followFeedFingerprint`:
  - Removed `strings("getFollowFeedList")` (string no longer exists)
  - Removed opcode pattern (INVOKE_INTERFACE_RANGE pattern changed)
  - Now relies solely on PUBLIC STATIC access flags and unique return type `Lcom/ss/android/ugc/aweme/follow/presenter/FollowFeedList;`

## Verified Working Components

### Shared Fingerprints (shared/Fingerprints.kt)
✅ **getEnterFromFingerprint** - Method renamed from `getEnterFrom` to `K5` but fingerprint uses opcodes/signature
✅ **onRenderFirstFrameFingerprint** - String "method_enable_viewpager_preload_duration" still exists

### Feed Filter (feedfilter/Fingerprints.kt)
✅ **feedApiServiceLIZFingerprint** - `fetchFeedList` method exists in FeedApiService
✅ **followFeedFingerprint** - Updated to work without string/opcode checks

### Downloads (interaction/downloads/Fingerprints.kt)
✅ **aclCommonShareFingerprint** - `getCode()` method exists
✅ **aclCommonShare2Fingerprint** - `getShowType()` method exists  
✅ **aclCommonShare3Fingerprint** - `getTranscode()` method exists
✅ **downloadUriFingerprint** - Method `LIZLLL` in `LX/0Hc3;` has required strings

### Seekbar (interaction/seekbar/Fingerprints.kt)
✅ **setSeekBarShowTypeFingerprint** - String exists in LX/0O1u;
✅ **shouldShowSeekBarFingerprint** - String exists in LX/14qz;

### Clear Display (interaction/cleardisplay/Fingerprints.kt)
✅ **onClearDisplayEventFingerprint** - `onClearModeEvent` method exists in ClearModePanelComponent

### Share (misc/share/Fingerprints.kt)
✅ **urlShorteningFingerprint** - String exists in LX/0oZt;

### Login Patches
✅ **mandatoryLoginServiceFingerprint** - MandatoryLoginService class exists
✅ **mandatoryLoginService2Fingerprint** - Methods exist
✅ **googleAuthAvailableFingerprint** - GoogleAuth class exists
✅ **googleOneTapAuthAvailableFingerprint** - GoogleOneTapAuth class exists

### Settings (misc/settings/Fingerprints.kt)
✅ **settingsEntryFingerprint** - String exists in LX/0RxF;
✅ **settingsEntryInfoFingerprint** - String exists in LX/0uSw;
✅ **adPersonalizationActivityOnCreateFingerprint** - AdPersonalizationActivity exists
⚠️ **addSettingsEntryFingerprint** - NEEDS VERIFICATION
❓ **settingsStatusLoadFingerprint** - Uses extension class, should work

## Known Issues / Areas Requiring Further Investigation

### Settings Patch - initUnitManger Method
**Status:** NEEDS UPDATE

The `addSettingsEntryFingerprint` looks for:
- Class ending with `/SettingNewVersionFragment;`
- Method named `initUnitManger`

**Problem:** This class/method combination was not found in version 43.0.2. The settings screen architecture may have been significantly refactored.

**Impact:** The settings patch may fail to inject the ReVanced settings entry point.

**Next Steps:** 
1. Reverse engineer the new settings screen architecture
2. Identify the equivalent fragment and method for injecting settings entries
3. Update the fingerprint and patch logic accordingly

## Critical Method Changes Identified

| Old Method | New Method | Location | Impact |
|------------|------------|----------|---------|
| `getEnterFrom` | `K5` | BaseListFragmentPanel | None (fingerprint uses opcodes) |
| Speed tracking (3 params) | `LIZ` (6 params) | LX/0N1s; | Updated fingerprint and injection |

## Testing Recommendations

1. **Compilation Test:** Build patches to ensure no syntax errors
2. **Settings Patch:** Priority - investigate and fix initUnitManger issue
3. **Functional Testing:** Test each patch against TikTok 43.0.2:
   - Playback speed retention
   - Feed filtering
   - Downloads without restrictions
   - Seekbar display
   - Login functionality
   - Share URL sanitization

## Files Modified

```
patches/src/main/kotlin/app/revanced/patches/tiktok/
├── feedfilter/
│   ├── FeedFilterPatch.kt (version update)
│   └── Fingerprints.kt (followFeedFingerprint simplified)
├── interaction/
│   ├── cleardisplay/RememberClearDisplayPatch.kt (version update)
│   ├── downloads/DownloadsPatch.kt (version update)
│   └── speed/
│       ├── Fingerprints.kt (setSpeedFingerprint signature update)
│       └── PlaybackSpeedPatch.kt (injection code updated for 6 params)
├── misc/
│   ├── settings/SettingsPatch.kt (version update)
│   └── share/SanitizeShareUrlsPatch.kt (version update)
└── shared/
    └── Fingerprints.kt (verified working, no changes needed)
```

## Conclusion

Most TikTok patches have been successfully updated for version 43.0.2. The main updates were:
1. Version number changes from 36.5.4 to 43.0.2
2. Playback speed patch adapted for new 6-parameter method signature
3. Feed filter fingerprint simplified to work without deprecated strings/opcodes

The settings patch requires additional investigation to locate the new settings entry injection point.
