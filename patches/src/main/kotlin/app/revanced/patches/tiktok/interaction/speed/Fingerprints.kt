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
    parameters("Lcom/ss/android/ugc/aweme/feed/model/Aweme;", "Ljava/lang/String;", "F", "J", "Ljava/lang/String;")
    custom { method, classDef ->
        // Method that logs/tracks speed changes
        classDef.type == "LX/0N1s;" && method.name == "LIZ"
    }
}
