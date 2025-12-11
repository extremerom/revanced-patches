package app.revanced.patches.tiktok.interaction.speed

import app.revanced.patcher.fingerprint
import com.android.tools.smali.dexlib2.AccessFlags

/**
 * Fingerprint for onFeedSpeedSelectedEvent method.
 * This method is called when user changes playback speed from UI.
 * 
 * Analysis (v43.0.2):
 * - Class: Lcom/ss/android/ugc/aweme/feed/panel/BaseListFragmentPanel;
 * - Method: onFeedSpeedSelectedEvent(LX/0QpM;)V
 * - Line: 20956
 * - Calls: LX/0QwT;->LIZIZ to get current speed
 * - Calls: LX/0vd8;->LLLJL to get speed multiplier
 * - Purpose: Handle speed change event from user interaction
 */
internal val getSpeedFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("/BaseListFragmentPanel;") && method.name == "onFeedSpeedSelectedEvent"
    }
}

/**
 * Fingerprint for setSpeed method that persists playback speed.
 * This is the core method that sets and broadcasts speed changes.
 * 
 * Analysis (v43.0.2):
 * - Class: LX/0QwT; (obfuscated PlaybackSpeedUtil or similar)
 * - Method: LJFF(String, Aweme, Float, String)V
 * - Lines: Full method analysis
 * 
 * Method Parameters (detailed):
 * p0 (String): enterFrom - Source context ("home", "following", etc.)
 *              - Validated with checkNotNullParameter
 *              - String literal: "enterFrom"
 * 
 * p1 (Aweme): Current video model
 *             - Stored in static field LIZ
 * 
 * p2 (Float): Playback speed (1.0, 1.5, 2.0, etc.)
 *             - Stored in static fields LIZJ and LIZIZ
 *             - Used in callback Function2
 * 
 * p3 (String): Action trigger (NEW in v43.0.2)
 *              - Optional (can be null)
 *              - Known values:
 *                * "swipe_up_lock_persist" (hash 0x3ff6dadf) → saves to LJI
 *                * "click_share_button" (hash 0xe40ece9)
 *                * Unknown action (hash 0x-1378ff40)
 *              - Used for tracking/analytics
 * 
 * Method Flow:
 * 1. Validates enterFrom parameter
 * 2. Stores old speed in v2
 * 3. Updates static fields with new speed
 * 4. Invokes callback (LIZLLL Function2) if set
 * 5. Checks p3 action via switch on hashCode
 * 6. Creates and posts IEvent (LX/0QpM)
 * 7. Notifies all registered listeners in LJ list
 * 
 * Key String: "enterFrom" - Used for parameter validation
 */
internal val setSpeedFingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.STATIC)
    returns("V")
    parameters(
        "Ljava/lang/String;",        // p0: enterFrom
        "Lcom/ss/android/ugc/aweme/feed/model/Aweme;", // p1: aweme
        "F",                          // p2: speed
        "Ljava/lang/String;"          // p3: action (NEW in 43.0.2)
    )
    strings("enterFrom")
}
