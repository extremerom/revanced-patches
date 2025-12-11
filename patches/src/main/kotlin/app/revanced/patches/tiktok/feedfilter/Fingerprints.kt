package app.revanced.patches.tiktok.feedfilter

import app.revanced.patcher.fingerprint
import com.android.tools.smali.dexlib2.AccessFlags
import com.android.tools.smali.dexlib2.Opcode

/**
 * Fingerprint for FeedApiService.fetchFeedList() method.
 * This method fetches the main video feed list and returns FeedItemList.
 * 
 * Analysis (v43.0.2):
 * - Class: Lcom/ss/android/ugc/aweme/feed/FeedApiService;
 * - Method: fetchFeedList(LX/0SHE;)Lcom/ss/android/ugc/aweme/feed/model/FeedItemList;
 * - Returns at line 169 with register v0
 */
internal val feedApiServiceLIZFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("/FeedApiService;") && method.name == "fetchFeedList"
    }
}

/**
 * Fingerprint for Follow Feed method that creates FollowFeedList.
 * This method is responsible for fetching the feed of followed users.
 * 
 * Analysis (v43.0.2):
 * - Class: LX/0SIV; (obfuscated)
 * - Method: LIZ(LX/0SH4;LX/0SH6;)Lcom/ss/android/ugc/aweme/follow/presenter/FollowFeedList;
 * - Key characteristics:
 *   - PUBLIC STATIC method
 *   - Returns FollowFeedList
 *   - Has exactly 2 parameters (both start with LX/)
 *   - Contains call to LX/0SIW;->LIZ which creates the FollowFeedList
 *   - Result stored in v9, then checks items and returns v9
 * 
 * Strategy: Match on return type, parameters, and PUBLIC STATIC flags
 */
internal val followFeedFingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.STATIC)
    returns("Lcom/ss/android/ugc/aweme/follow/presenter/FollowFeedList;")
    parameters("LX/", "LX/") // Both parameters are obfuscated types starting with LX/
    
    // This method has multiple return points but all return the same type
    // We'll look for the pattern where it calls another method to create FollowFeedList
    opcodes(
        Opcode.INVOKE_VIRTUAL, // Call to LX/0SIW;->LIZ to create FollowFeedList
        Opcode.MOVE_RESULT_OBJECT, // Store result
        Opcode.INVOKE_VIRTUAL // Call getItems() on the result
    )
}