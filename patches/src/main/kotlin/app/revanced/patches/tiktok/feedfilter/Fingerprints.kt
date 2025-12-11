package app.revanced.patches.tiktok.feedfilter

import app.revanced.patcher.fingerprint
import com.android.tools.smali.dexlib2.AccessFlags
import com.android.tools.smali.dexlib2.Opcode

internal val feedApiServiceLIZFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("/FeedApiService;") && method.name == "fetchFeedList"
    }
}

internal val followFeedFingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.STATIC)
    returns("Lcom/ss/android/ugc/aweme/follow/presenter/FollowFeedList;")
    // String "getFollowFeedList" removed in version 43.0.2
    // Using parameter and return type matching instead
    parameters("LX/0SH4;", "LX/0SH6;")
    opcodes(
        Opcode.INVOKE_STATIC,
        Opcode.INVOKE_STATIC
    )
}