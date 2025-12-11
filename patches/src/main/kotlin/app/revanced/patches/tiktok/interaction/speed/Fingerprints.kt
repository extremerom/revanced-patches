package app.revanced.patches.tiktok.interaction.speed

import app.revanced.patcher.fingerprint
import com.android.tools.smali.dexlib2.AccessFlags

internal val getSpeedFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("/BaseListFragmentPanel;") && method.name == "onFeedSpeedSelectedEvent"
    }
}

internal val setSpeedFingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.STATIC)
    returns("V")
    strings("enterFrom")
    // Updated for v43.0.2: method now has 4 parameters instead of 3
    custom { method, _ ->
        method.parameterTypes.size >= 3 &&
        method.parameterTypes[0] == "Ljava/lang/String;" &&
        method.parameterTypes[1] == "Lcom/ss/android/ugc/aweme/feed/model/Aweme;" &&
        method.parameterTypes[2] == "F"
    }
}
