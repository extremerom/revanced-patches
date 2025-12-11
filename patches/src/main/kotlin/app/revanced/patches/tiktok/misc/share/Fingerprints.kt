package app.revanced.patches.tiktok.misc.share

import app.revanced.patcher.fingerprint
import com.android.tools.smali.dexlib2.AccessFlags
import com.android.tools.smali.dexlib2.Opcode

internal val urlShorteningFingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.STATIC)
    returns("LX/")
    parameters(
        "Ljava/lang/String;",
        "Ljava/lang/String;",
        "Ljava/lang/String;",
        "I",
        "I"
    )
    opcodes(Opcode.RETURN_OBJECT)
    strings("getShortShareUrlObservable(...)")
    custom { method, _ ->
        method.name == "LIZ"
    }
}
