package app.revanced.patches.tiktok.feedfilter

import app.revanced.patcher.PatchException
import app.revanced.patcher.extensions.InstructionExtensions.addInstruction
import app.revanced.patcher.extensions.InstructionExtensions.instructions
import app.revanced.patcher.patch.bytecodePatch
import app.revanced.patches.tiktok.misc.extension.sharedExtensionPatch
import app.revanced.patches.tiktok.misc.settings.settingsPatch
import app.revanced.patches.tiktok.misc.settings.settingsStatusLoadFingerprint
import com.android.tools.smali.dexlib2.Opcode
import com.android.tools.smali.dexlib2.iface.instruction.OneRegisterInstruction

private const val EXTENSION_CLASS_DESCRIPTOR = "Lapp/revanced/extension/tiktok/feedfilter/FeedItemsFilter;"

@Suppress("unused")
val feedFilterPatch = bytecodePatch(
    name = "Feed filter",
    description = "Removes ads, livestreams, stories, image videos " +
        "and videos with a specific amount of views or likes from the feed.",
) {
    dependsOn(
        sharedExtensionPatch,
        settingsPatch,
    )

    compatibleWith(
        "com.ss.android.ugc.trill"("43.0.2"),
        "com.zhiliaoapp.musically"("43.0.2"),
    )

    execute {
        /**
         * Strategy for Feed Filter:
         * 1. Find the return-object instruction in both methods
         * 2. Inject our filter call just before the return
         * 3. The filter will modify the list in-place before it's returned
         * 
         * For fetchFeedList: returns FeedItemList in register v0 at line 169
         * For followFeed: returns FollowFeedList in register v9 at line 355 (main path)
         */
        arrayOf(
            feedApiServiceLIZFingerprint.method to "$EXTENSION_CLASS_DESCRIPTOR->filter(Lcom/ss/android/ugc/aweme/feed/model/FeedItemList;)V",
            followFeedFingerprint.method to "$EXTENSION_CLASS_DESCRIPTOR->filter(Lcom/ss/android/ugc/aweme/follow/presenter/FollowFeedList;)V"
        ).forEach { (method, filterSignature) ->
            // Find ALL return-object instructions (there may be multiple due to error handling)
            val returnInstructions = method.instructions.filter { it.opcode == Opcode.RETURN_OBJECT }
            
            if (returnInstructions.isEmpty()) {
                throw PatchException("No return-object instruction found in method ${method.name}")
            }
            
            // Inject before each return point to ensure we filter in all code paths
            returnInstructions.forEach { returnInstruction ->
                val register = (returnInstruction as OneRegisterInstruction).registerA
                val index = returnInstruction.location.index
                
                // Insert the filter call just before the return
                // This modifies the object in the register before it's returned
                method.addInstruction(
                    index,
                    "invoke-static { v$register }, $filterSignature"
                )
            }
        }

        // Enable the feed filter setting in the extension
        settingsStatusLoadFingerprint.method.addInstruction(
            0,
            "invoke-static {}, Lapp/revanced/extension/tiktok/settings/SettingsStatus;->enableFeedFilter()V",
        )
    }

}
