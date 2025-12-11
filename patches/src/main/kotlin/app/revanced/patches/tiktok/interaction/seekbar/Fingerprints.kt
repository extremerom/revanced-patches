package app.revanced.patches.tiktok.interaction.seekbar

import app.revanced.patcher.fingerprint

internal val setSeekBarShowTypeFingerprint = fingerprint {
    // Use string matching as primary identifier to avoid relying on obfuscated class names
    strings("seekbar show type change, change to:")
}

internal val shouldShowSeekBarFingerprint = fingerprint {
    // Use string matching as primary identifier to avoid relying on obfuscated class names
    strings("can not show seekbar, state: 1, not in resume")
}
