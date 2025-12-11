package app.revanced.patches.tiktok.interaction.downloads

import app.revanced.patcher.fingerprint
import com.android.tools.smali.dexlib2.AccessFlags

internal val aclCommonShareFingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.FINAL)
    returns("I")
    custom { method, classDef ->
        classDef.endsWith("/ACLCommonShare;") &&
                method.name == "getCode"
    }
}

internal val aclCommonShare2Fingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.FINAL)
    returns("I")
    custom { method, classDef ->
        classDef.endsWith("/ACLCommonShare;") &&
                method.name == "getShowType"
    }
}

internal val aclCommonShare3Fingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.FINAL)
    returns("I")
    custom { method, classDef ->
        classDef.endsWith("/ACLCommonShare;") &&
                method.name == "getTranscode"
    }
}

internal val downloadUriFingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.STATIC)
    returns("Landroid/net/Uri;")
    strings(
        "/",
        "/Camera",
        "/Camera/",
        "video/mp4"
    )
    // Updated for v43.0.2 - method now has 3 parameters instead of 2
    custom { method, _ ->
        method.parameterTypes.size >= 2 &&
        method.parameterTypes[0] == "Landroid/content/Context;" &&
        method.parameterTypes[1] == "Ljava/lang/String;"
    }
}
