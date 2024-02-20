package de.coodoo.help_scout_beacon

import HelpScoutApi
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
class HelpScoutBeaconPlugin: FlutterPlugin, HelpScoutApi, ActivityAware {
  private var currentActivity: android.app.Activity?=null;

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    HelpScoutApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun initialize(beaconId: String) {
    Beacon.Builder()
      .withBeaconId(beaconId)
      .withLogsEnabled(true)
      .build()
  }
  override fun open() {
    if(currentActivity!=null) {
      BeaconActivity.open(currentActivity!!)
    }
  }
  override fun logout() {
    Beacon.logout()
  }
  override fun clear() {
    Beacon.clear()
  }

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

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    HelpScoutApi.setUp(binding.binaryMessenger, null)
  }
}
