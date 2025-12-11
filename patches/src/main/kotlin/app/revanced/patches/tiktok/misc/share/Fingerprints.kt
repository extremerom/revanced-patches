package app.revanced.patches.tiktok.misc.share

import app.revanced.patcher.fingerprint
import com.android.tools.smali.dexlib2.AccessFlags
import com.android.tools.smali.dexlib2.Opcode

internal val urlShorteningFingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.STATIC)
    returns("LX/")
    // Method signature changed in v43.0.2 from (I,String,String,String) to (String,String,String,I,I)
    // and method name changed from LIZLLL to LIZ
    parameters(
        "Ljava/lang/String;",
        "Ljava/lang/String;",
        "Ljava/lang/String;",
        "I",
        "I"
    )
    opcodes(Opcode.RETURN_OBJECT)

    // Same Kotlin intrinsics literal on both variants, but truncated in newer version
    strings("getShortShareUrlObservable(...)")

    custom { method, _ ->
        // Method name changed from LIZLLL to LIZ in v43.0.2
        method.name == "LIZ"
    }
}
