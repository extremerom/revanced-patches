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
    // Updated: More specific matching for v43.0.2
    // Looking for static methods in X/ obfuscated classes that return FollowFeedList
    // with specific parameter patterns to avoid false matches
    custom { method, classDef ->
        classDef.type.startsWith("LX/") &&
        method.returnType == "Lcom/ss/android/ugc/aweme/follow/presenter/FollowFeedList;" &&
        method.parameterTypes.size in 0..2 &&
        // Ensure it's a reasonable method by checking it has implementation
        method.implementation != null
    }
}