package app.revanced.patches.tiktok.misc.settings

import app.revanced.patcher.fingerprint

// Note: In TikTok 43.0.2+, the settings architecture changed from Fragment-based
// to Jetpack Compose Page/Cell-based system. These fingerprints may not resolve
// in newer versions but the main functionality (hijacking AdPersonalizationActivity)
// still works.

internal val addSettingsEntryFingerprint = fingerprint {
    custom { method, classDef ->
        // This fingerprint is deprecated in version 43.0.2+
        // The Fragment-based settings system was replaced with Compose-based Pages
        classDef.endsWith("/SettingNewVersionFragment;") &&
            method.name == "initUnitManger"
    }
}

internal val adPersonalizationActivityOnCreateFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("/AdPersonalizationActivity;") &&
            method.name == "onCreate"
    }
}

internal val settingsEntryFingerprint = fingerprint {
    strings("pls pass item or extends the EventUnit")
}

internal val settingsEntryInfoFingerprint = fingerprint {
    strings(
        "ExposeItem(title=",
        ", icon=",
    )
}

internal val settingsStatusLoadFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("Lapp/revanced/extension/tiktok/settings/SettingsStatus;") &&
            method.name == "load"
    }
}
