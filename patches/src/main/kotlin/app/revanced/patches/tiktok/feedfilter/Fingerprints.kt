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
    // Match the LIZ method in X/0SIV that takes scene and redDotState parameters
    custom { method, _ ->
        method.parameterTypes.size == 2 &&
        method.returnType == "Lcom/ss/android/ugc/aweme/follow/presenter/FollowFeedList;"
    }
}