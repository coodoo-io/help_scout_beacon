package de.coodoo.help_scout_beacon

import HSBeaconRoute
import HSBeaconSettings
import HSBeaconUser
import HelpScoutBeaconApi
import android.net.Uri
import com.helpscout.beacon.model.PreFilledForm
import android.content.Context
import com.helpscout.beacon.Beacon
import com.helpscout.beacon.model.BeaconConfigOverrides
import com.helpscout.beacon.model.BeaconScreens
import com.helpscout.beacon.model.FocusMode
import com.helpscout.beacon.ui.BeaconActivity
import com.helpscout.beacon.model.ContactFormConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** HelpScoutBeaconPlugin */
class HelpScoutBeaconPlugin : FlutterPlugin, HelpScoutBeaconApi {
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        HelpScoutBeaconApi.setUp(flutterPluginBinding.binaryMessenger, this)
        context = flutterPluginBinding.applicationContext
    }

    //
    // Implementation
    //
    /**
     * Initialize the beacon with a beaconId and optional settings
     */
    override fun setup(settings: HSBeaconSettings) {
        Beacon.Builder().withBeaconId(settings.beaconId).withLogsEnabled(settings.debugLogging).build()
    }

    /**
     * Signs in with a Beacon user. This gives Beacon access to the user’s name, email address, and
     * signature.
     */
    override fun identify(beaconUser: HSBeaconUser) {
        Beacon.identify(
            beaconUser.email, beaconUser.name, beaconUser.company, beaconUser.jobTitle, beaconUser.avatar
        )

        beaconUser.attributes?.forEach { (key, value) ->
            Beacon.addAttributeWithKey(key, value)
        }
    }

    /**
     * Opens the Beacon SDK from a specific view controller. The Beacon view controller will be
     * presented as a modal.
     */
    override fun open(settings: HSBeaconSettings, route: HSBeaconRoute, parameter: String?) {
        val parameters = arrayListOf<String>()
        if (parameter != null) {
            parameters.add(parameter)
        }

        val focusMode: FocusMode? = when (settings.focusMode) {
            HSBeaconFocusMode.NEUTRAL -> FocusMode.NEUTRAL
            HSBeaconFocusMode.SELF_SERVICE -> FocusMode.SELF_SERVICE
            HSBeaconFocusMode.ASK_FIRST -> FocusMode.ASK_FIRST
            else -> null
        }


        // Settings
        val configOverrides = BeaconConfigOverrides(
            docsEnabled = settings.docsEnabled,
            messagingEnabled = settings.messagingEnabled,
            chatEnabled = settings.chatEnabled,
            focusMode = focusMode,
            enablePreviousMessages = settings.enablePreviousMessages,
            // The cast picks an overload: a bare null is ambiguous here.
            contactForm = null as ContactFormConfig?
        )
        Beacon.setConfigOverrides(configOverrides)

        // Navigation
        when (route) {
            HSBeaconRoute.ASK -> BeaconActivity.open(context, BeaconScreens.ASK, arrayListOf())
            HSBeaconRoute.CHAT -> BeaconActivity.open(context, BeaconScreens.CHAT, arrayListOf())
            HSBeaconRoute.DOCS -> {
                if (parameters.isEmpty()) {
                    BeaconActivity.open(context, BeaconScreens.DEFAULT, arrayListOf())
                } else {
                    BeaconActivity.open(context, BeaconScreens.SEARCH_SCREEN, parameters)
                }
            }

            HSBeaconRoute.ARTICLE -> BeaconActivity.open(context, BeaconScreens.ARTICLE_SCREEN, parameters)

            HSBeaconRoute.CONTACT_FORM -> BeaconActivity.open(
                context, BeaconScreens.CONTACT_FORM_SCREEN, arrayListOf()
            )

            HSBeaconRoute.PREVIOUS_MESSAGES -> BeaconActivity.open(
                context, BeaconScreens.PREVIOUS_MESSAGES, arrayListOf()
            )

            else -> BeaconActivity.open(context, BeaconScreens.DEFAULT, arrayListOf())
        }
    }

    /** Logs the current Beacon user out and clears out their information from local storage. */
    override fun clear() {
        Beacon.logout()
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        HelpScoutBeaconApi.setUp(binding.binaryMessenger, null)
    }

    override fun prefillContactForm(subject: String?, message: String?, attachments: List<String>?) {
        // Prefilled forms are ignored while a draft exists, so drop any stale
        // draft first — otherwise this call silently does nothing.
        Beacon.contactFormReset()

        val attachmentUris = attachments?.map { Uri.parse(it).toString() } ?: emptyList()

        // Create the PreFilledForm object with the prepared data.
        val form = PreFilledForm(
            "", subject ?: "", message ?: "", emptyMap<Int, String>(), attachmentUris, ""
        )
        Beacon.addPreFilledForm(form) // Add all data to contact form
    }
}
