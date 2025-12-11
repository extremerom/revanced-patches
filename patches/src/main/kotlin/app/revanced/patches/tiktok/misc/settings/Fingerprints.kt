package app.revanced.patches.tiktok.misc.settings

import app.revanced.patcher.fingerprint

// TikTok v43.0.2: Intercept AdPersonalizationActivity to redirect to ReVanced Settings
internal val adPersonalizationActivityOnCreateFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("/AdPersonalizationActivity;") &&
            method.name == "onCreate"
    }
}

internal val settingsStatusLoadFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("Lapp/revanced/extension/tiktok/settings/SettingsStatus;") &&
            method.name == "load"
    }
}
