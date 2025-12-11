package app.revanced.patches.tiktok.shared

import app.revanced.patcher.fingerprint
import com.android.tools.smali.dexlib2.AccessFlags
import com.android.tools.smali.dexlib2.Opcode

internal val getEnterFromFingerprint = fingerprint {
    returns("Ljava/lang/String;")
    accessFlags(AccessFlags.PUBLIC, AccessFlags.FINAL)
    parameters("Z")
    custom { methodDef, _ ->
        // In TikTok 43.0.2, this method is obfuscated as "K5"
        methodDef.definingClass.endsWith("/BaseListFragmentPanel;") &&
            methodDef.name == "K5"
    }
}

internal val onRenderFirstFrameFingerprint = fingerprint {
    strings("method_enable_viewpager_preload_duration")
    custom { _, classDef ->
        classDef.endsWith("/BaseListFragmentPanel;")
    }
}
