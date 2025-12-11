package app.revanced.patches.tiktok.interaction.downloads

import app.revanced.patcher.fingerprint
import com.android.tools.smali.dexlib2.AccessFlags

/**
 * Fingerprints for ACLCommonShare class methods.
 * These methods control download restrictions.
 * 
 * Analysis (v43.0.2):
 * - Class: Lcom/ss/android/ugc/aweme/feed/model/ACLCommonShare;
 * - Simple getter methods returning int values
 * - Used to check download permissions/restrictions
 */
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

/**
 * Fingerprint for download URI method.
 * This method constructs the file path for downloaded videos.
 * 
 * Analysis (v43.0.2):
 * - Class: LX/0Hc6; (obfuscated)
 * - Method: LIZIZ(Context, String, String, Boolean)Landroid/net/Uri;
 * - Line 134: Method signature
 * - Lines 189, 214, 379, 404: Uses DIRECTORY_DCIM
 * - Pattern: 
 *   1. sget-object DIRECTORY_DCIM → v0
 *   2. invoke-virtual StringBuilder.append(v0)
 *   3. invoke-virtual StringBuilder.append("/Camera") or "/Camera/"
 *   4. Creates Uri for MediaStore
 * 
 * Key strings for identification:
 * - "/" (path separator)
 * - "/Camera" (directory name) 
 * - "/Camera/" (directory with trailing slash)
 * - "video/mp4" (MIME type)
 * 
 * The patch will replace the DIRECTORY_DCIM + "/Camera/" pattern
 * with a custom path from extension settings.
 */
internal val downloadUriFingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.STATIC)
    returns("Landroid/net/Uri;")
    parameters(
        "Landroid/content/Context;",
        "Ljava/lang/String;",
        "Ljava/lang/String;",
        "Ljava/lang/Boolean;" // New parameter added in version 43.0.2 for some flag
    )
    strings(
        "/",
        "/Camera",
        "/Camera/",
        "video/mp4"
    )
}
