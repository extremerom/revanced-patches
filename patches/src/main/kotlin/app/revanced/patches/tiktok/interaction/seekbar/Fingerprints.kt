package app.revanced.patches.tiktok.interaction.seekbar

import app.revanced.patcher.fingerprint

internal val setSeekBarShowTypeFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.type == "LX/0O1u;" && 
        method.implementation?.instructions?.any { 
            it.toString().contains("seekbar show type change, change to:")
        } == true
    }
}

internal val shouldShowSeekBarFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.type == "LX/14qz;" &&
        method.name == "LJII" &&
        method.implementation?.instructions?.any {
            it.toString().contains("can not show seekbar, state: 1, not in resume")
        } == true
    }
}
