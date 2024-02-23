package de.coodoo.help_scout_beacon

import HelpScoutBeaconApi
import HSBeaconUser
import HSBeaconRoute
import HSBeaconSettings
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.helpscout.beacon.Beacon
import com.helpscout.beacon.model.BeaconScreens
import com.helpscout.beacon.ui.BeaconActivity
import java.util.ArrayList

/** HelpScoutBeaconPlugin */
class HelpScoutBeaconPlugin: FlutterPlugin, HelpScoutBeaconApi, ActivityAware {
  private var currentActivity: android.app.Activity?=null;

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    HelpScoutBeaconApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  //
  // Implementation
  //
  /** Signs in with a Beacon user. This gives Beacon access to the user’s name, email address, and signature. */
  override fun identify(beaconUser: HSBeaconUser) {
    Beacon.identify(beaconUser.email, beaconUser.name, beaconUser.company, beaconUser.jobTitle, beaconUser.avatar)
  }

  /** Opens the Beacon SDK from a specific view controller. The Beacon view controller will be presented as a modal. */
  override fun open(settings: HSBeaconSettings, route: HSBeaconRoute, parameter: String?) {
    if(currentActivity!=null) {
      var parameters = ArrayList<String>();
      if(parameter!=null) {
        parameters.add(parameter);
      }
      Beacon.Builder()
      .withBeaconId(settings.beaconId)
      .withLogsEnabled(true)
      .build();
      when (route) {
        HSBeaconRoute.ASK -> BeaconActivity.open(currentActivity!!, BeaconScreens.ASK, parameters)
        HSBeaconRoute.CHAT -> BeaconActivity.open(currentActivity!!, BeaconScreens.CHAT, parameters)
        HSBeaconRoute.SEARCH -> BeaconActivity.open(currentActivity!!, BeaconScreens.SEARCH_SCREEN, parameters)
        HSBeaconRoute.ARTICLE -> BeaconActivity.open(currentActivity!!, BeaconScreens.ARTICLE_SCREEN, parameters)
        HSBeaconRoute.CONTACT_FORM -> BeaconActivity.open(currentActivity!!, BeaconScreens.CONTACT_FORM_SCREEN, parameters)
        HSBeaconRoute.PREVIOUS_MESSAGES -> BeaconActivity.open(currentActivity!!, BeaconScreens.PREVIOUS_MESSAGES, parameters)
        else -> BeaconActivity.open(currentActivity!!)
      }
    }
  }
  /** Logs the current Beacon user out and clears out their information from local storage. */
  override fun logout() {
    Beacon.logout()
  }
  
  //
  // Lifecycle and activity
  //
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    // Log.d("DART/NATIVE", "onAttachedToActivity")
    currentActivity = binding.activity
  }
  
  //Method called by ActivityAware plugins to fetch the activity on re-initialization
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
