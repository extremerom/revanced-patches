package app.revanced.patches.tiktok.misc.share

import app.revanced.patcher.fingerprint
import com.android.tools.smali.dexlib2.AccessFlags
import com.android.tools.smali.dexlib2.Opcode

internal val urlShorteningFingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.STATIC, AccessFlags.FINAL)
    returns("LX/")
    parameters(
        "Ljava/lang/String;",
        "Ljava/lang/String;",
        "Ljava/lang/String;",
        "I",
        "I"
    )
    opcodes(Opcode.RETURN_OBJECT)

    // Same Kotlin intrinsics literal on both variants.
    strings("getShortShareUrlObservable(...)")

    custom { method, _ ->
        // LIZ is obfuscated by ProGuard/R8, but stable across both TikTok and Musically.
        // Method name changed from LIZLLL to LIZ in version 43.0.2
        method.name == "LIZ"
    }
}
