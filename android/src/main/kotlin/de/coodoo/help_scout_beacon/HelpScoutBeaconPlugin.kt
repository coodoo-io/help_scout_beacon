package de.coodoo.help_scout_beacon

import HSBeaconRoute
import HSBeaconSettings
import HSBeaconUser
import HelpScoutBeaconApi
import com.helpscout.beacon.Beacon
import com.helpscout.beacon.model.BeaconScreens
import com.helpscout.beacon.ui.BeaconActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.util.ArrayList
import kotlin.text.isNullOrEmpty

/** HelpScoutBeaconPlugin */
class HelpScoutBeaconPlugin : FlutterPlugin, HelpScoutBeaconApi, ActivityAware {
  private var currentActivity: android.app.Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    HelpScoutBeaconApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  //
  // Implementation
  //
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
  }

  /**
   * Opens the Beacon SDK from a specific view controller. The Beacon view controller will be
   * presented as a modal.
   */
  override fun open(settings: HSBeaconSettings, route: HSBeaconRoute, parameter: String?) {
    if (currentActivity != null) {
      var parameters = ArrayList<String>()
      if (parameter != null) {
        parameters.add(parameter)
      }
      Beacon.Builder().withBeaconId(settings.beaconId).build()
      when (route) {
        HSBeaconRoute.ASK -> BeaconActivity.open(currentActivity!!, BeaconScreens.ASK, parameters)
        HSBeaconRoute.CHAT -> BeaconActivity.open(currentActivity!!, BeaconScreens.CHAT, parameters)
        HSBeaconRoute.DOCS -> {
          if(parameters.isNullOrEmpty()) {
            return BeaconActivity.open(currentActivity!!, BeaconScreens.DEFAULT, parameters)
          } else {
            return BeaconActivity.open(currentActivity!!, BeaconScreens.SEARCH_SCREEN, parameters)
          }
        }
        HSBeaconRoute.ARTICLE ->
            BeaconActivity.open(currentActivity!!, BeaconScreens.ARTICLE_SCREEN, parameters)
        HSBeaconRoute.CONTACT_FORM ->
            BeaconActivity.open(currentActivity!!, BeaconScreens.CONTACT_FORM_SCREEN, parameters)
        HSBeaconRoute.PREVIOUS_MESSAGES ->
            BeaconActivity.open(currentActivity!!, BeaconScreens.PREVIOUS_MESSAGES, parameters)
        else -> BeaconActivity.open(currentActivity!!, BeaconScreens.DEFAULT, parameters)
      }
    }
  }
  /** Logs the current Beacon user out and clears out their information from local storage. */
  override fun clear() {
    Beacon.clear()
  }

  //
  // Lifecycle and activity
  //
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    // Log.d("DART/NATIVE", "onAttachedToActivity")
    currentActivity = binding.activity
  }

  // Method called by ActivityAware plugins to fetch the activity on re-initialization
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    // Log.d("DART/NATIVE", "onReattachedToActivityForConfigChanges")
    currentActivity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // Log.d("DART/NATIVE", "onDetachedFromActivityForConfigChanges")
    currentActivity = null
  }

  override fun onDetachedFromActivity() {
    currentActivity = null
  }
  // End

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    HelpScoutBeaconApi.setUp(binding.binaryMessenger, null)
  }
}
