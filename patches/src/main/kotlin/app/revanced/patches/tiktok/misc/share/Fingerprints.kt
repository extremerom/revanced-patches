package app.revanced.patches.tiktok.misc.share

import app.revanced.patcher.fingerprint
import com.android.tools.smali.dexlib2.AccessFlags
import com.android.tools.smali.dexlib2.Opcode

internal val urlShorteningFingerprint = fingerprint {
    accessFlags(AccessFlags.PUBLIC, AccessFlags.STATIC)
    returns("LX/")
    opcodes(Opcode.RETURN_OBJECT)

    // Updated for v43.0.2: method signature and name changed
    // Now looking for methods with getShortShareUrl string and returning Observable type
    strings("getShortShareUrl")
    
    custom { method, _ ->
        // Method should return an Observable type (LX/0XYH or similar)
        method.returnType.startsWith("LX/") &&
        // Should have multiple String parameters
        method.parameterTypes.count { it == "Ljava/lang/String;" } >= 2
    }
}
