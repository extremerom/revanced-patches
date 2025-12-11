package app.revanced.patches.tiktok.misc.settings

import app.revanced.patcher.extensions.InstructionExtensions.addInstructionsWithLabels
import app.revanced.patcher.extensions.InstructionExtensions.getInstruction
import app.revanced.patcher.patch.bytecodePatch
import app.revanced.patcher.util.smali.ExternalLabel
import app.revanced.patches.shared.layout.branding.addBrandLicensePatch
import app.revanced.patches.tiktok.misc.extension.sharedExtensionPatch
import com.android.tools.smali.dexlib2.Opcode
import com.android.tools.smali.dexlib2.iface.instruction.formats.Instruction35c

private const val EXTENSION_CLASS_DESCRIPTOR =
    "Lapp/revanced/extension/tiktok/settings/TikTokActivityHook;"

val settingsPatch = bytecodePatch(
    name = "Settings",
    description = "Adds ReVanced settings to TikTok. Access via Settings > Privacy and settings > About > Ad personalization.",
) {
    dependsOn(sharedExtensionPatch, addBrandLicensePatch)

    compatibleWith(
        "com.ss.android.ugc.trill"("43.0.2"),
        "com.zhiliaoapp.musically"("43.0.2"),
    )

    execute {
        val initializeSettingsMethodDescriptor =
            "$EXTENSION_CLASS_DESCRIPTOR->initialize(" +
                "Lcom/bytedance/ies/ugc/aweme/commercialize/compliance/personalization/AdPersonalizationActivity;" +
                ")Z"

        // TikTok v43.0.2 architecture change:
        // Instead of injecting into a settings list (Fragment-based architecture removed),
        // we intercept AdPersonalizationActivity to show ReVanced Settings.
        // Users access it via: Settings > Privacy and settings > About > Ad personalization
        
        adPersonalizationActivityOnCreateFingerprint.method.apply {
            val initializeSettingsIndex = implementation!!.instructions.indexOfFirst {
                it.opcode == Opcode.INVOKE_SUPER
            } + 1

            val thisRegister = getInstruction<Instruction35c>(initializeSettingsIndex - 1).registerC
            val usableRegister = implementation!!.registerCount - parameters.size - 2

            addInstructionsWithLabels(
                initializeSettingsIndex,
                """
                    # Try to initialize ReVanced Settings instead of Ad Personalization
                    invoke-static {v$thisRegister}, $initializeSettingsMethodDescriptor
                    move-result v$usableRegister
                    if-eqz v$usableRegister, :show_original_activity
                    # If ReVanced Settings was shown, return early
                    return-void
                    # Otherwise, continue with original Ad Personalization activity
                    :show_original_activity
                    nop
                """,
                ExternalLabel("show_original_activity", getInstruction(initializeSettingsIndex)),
            )
        }
    }
}
