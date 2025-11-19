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
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** HelpScoutBeaconPlugin */
class HelpScoutBeaconPlugin : FlutterPlugin, HelpScoutBeaconApi {
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    HelpScoutBeaconApi.setUp(flutterPluginBinding.binaryMessenger, this)
    context = flutterPluginBinding.applicationContext;
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
        beaconUser.email,
        beaconUser.name,
        beaconUser.company,
        beaconUser.jobTitle,
        beaconUser.avatar
    )

    beaconUser.attributes?.forEach { (key, value) ->
        Beacon.addAttributeWithKey(key.toString(), value?.toString()?:"");
    }
  }

  /**
   * Opens the Beacon SDK from a specific view controller. The Beacon view controller will be
   * presented as a modal.
   */
  override fun open(settings: HSBeaconSettings, route: HSBeaconRoute, parameter: String?) {
      var parameters = arrayListOf<String>()
      if (parameter != null) {
        parameters.add(parameter)
      }

      val focusMode: FocusMode? = when(settings.focusMode) {
        HSBeaconFocusMode.NEUTRAL -> FocusMode.NEUTRAL
        HSBeaconFocusMode.SELF_SERVICE -> FocusMode.SELF_SERVICE
        HSBeaconFocusMode.ASK_FIRST -> FocusMode.ASK_FIRST
        else -> null
      }


      // Settings
      var configOverrides = BeaconConfigOverrides(settings.docsEnabled, settings.messagingEnabled, settings.chatEnabled,null,null, focusMode, settings.enablePreviousMessages);
      Beacon.setConfigOverrides(configOverrides);

      // Navigation
      when (route) {
        HSBeaconRoute.ASK -> BeaconActivity.open(context, BeaconScreens.ASK, arrayListOf<String>())
        HSBeaconRoute.CHAT -> BeaconActivity.open(context, BeaconScreens.CHAT, arrayListOf<String>())
        HSBeaconRoute.DOCS -> {
          if(parameters.isNullOrEmpty()) {
            return BeaconActivity.open(context, BeaconScreens.DEFAULT, arrayListOf<String>())
          } else {
            return BeaconActivity.open(context, BeaconScreens.SEARCH_SCREEN, parameters)
          }
        }
        HSBeaconRoute.ARTICLE ->
            BeaconActivity.open(context, BeaconScreens.ARTICLE_SCREEN, parameters)
        HSBeaconRoute.CONTACT_FORM ->
            BeaconActivity.open(context, BeaconScreens.CONTACT_FORM_SCREEN, arrayListOf<String>())
        HSBeaconRoute.PREVIOUS_MESSAGES ->
            BeaconActivity.open(context, BeaconScreens.PREVIOUS_MESSAGES, arrayListOf<String>())
        else -> BeaconActivity.open(context, BeaconScreens.DEFAULT, arrayListOf<String>())
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
    val attachmentUris = attachments?.map { Uri.parse(it).toString() } ?: emptyList()

    val form = PreFilledForm(
        "",
        subject ?: "",
        message ?: "",
        emptyMap<Int, String>(),
        attachmentUris,
        ""
    )
    Beacon.addPreFilledForm(form)
 }
}
