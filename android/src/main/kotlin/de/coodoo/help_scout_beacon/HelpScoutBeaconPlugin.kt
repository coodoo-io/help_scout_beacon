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
import com.helpscout.beacon.ui.BeaconActivity

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
      Beacon.Builder()
      .withBeaconId(settings.beaconId)
      .withLogsEnabled(true)
      .build();
      BeaconActivity.open(currentActivity!!)
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
