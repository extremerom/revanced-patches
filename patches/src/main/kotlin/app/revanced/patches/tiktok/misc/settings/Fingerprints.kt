package app.revanced.patches.tiktok.misc.settings

import app.revanced.patcher.fingerprint

internal val addSettingsEntryFingerprint = fingerprint {
    custom { method, classDef ->
        // Updated: Settings fragment structure has changed in v43.0.2
        // Looking for any settings-related fragment with initialization methods
        classDef.type.contains("/setting/") &&
            classDef.type.contains("Fragment") &&
            method.name.contains("init")
    }
}

internal val adPersonalizationActivityOnCreateFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("/AdPersonalizationActivity;") &&
            method.name == "onCreate"
    }
}

internal val settingsEntryFingerprint = fingerprint {
    custom { method, classDef ->
        // Updated: Found in LX/0RxF; in v43.0.2
        classDef.type == "LX/0RxF;" &&
        method.implementation?.instructions?.any {
            it.toString().contains("pls pass item or extends the EventUnit")
        } == true
    }
}

internal val settingsEntryInfoFingerprint = fingerprint {
    custom { method, classDef ->
        // Updated: Found in LX/0uSw; in v43.0.2
        classDef.type == "LX/0uSw;" &&
        method.implementation?.instructions?.any {
            val str = it.toString()
            str.contains("ExposeItem(title=") && str.contains(", icon=")
        } == true
    }
}

internal val settingsStatusLoadFingerprint = fingerprint {
    custom { method, classDef ->
        classDef.endsWith("Lapp/revanced/extension/tiktok/settings/SettingsStatus;") &&
            method.name == "load"
    }
}
