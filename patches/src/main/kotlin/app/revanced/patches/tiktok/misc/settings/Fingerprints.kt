package app.revanced.patches.tiktok.misc.settings

import app.revanced.patcher.fingerprint

// NOTE: In v43.0.2, TikTok settings have been completely redesigned with Jetpack Compose
// The addSettingsEntryFingerprint is kept for future use but not currently utilized
internal val addSettingsEntryFingerprint = fingerprint {
    custom { method, classDef ->
        // Placeholder for future implementation of settings entry injection
        // Current Compose-based settings require a different approach
        classDef.type.contains("/SettingsComposeRvmpFragment;") &&
        method.name == "onViewCreated"
    }
}

internal val adPersonalizationActivityOnCreateFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("/AdPersonalizationActivity;") &&
            method.name == "onCreate"
    }
}

// These fingerprints are kept for potential future use
internal val settingsEntryFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.type == "LX/0RxF;"
    }
}

internal val settingsEntryInfoFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.type == "LX/0uSw;"
    }
}

internal val settingsStatusLoadFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("Lapp/revanced/extension/tiktok/settings/SettingsStatus;") &&
            method.name == "load"
    }
}
