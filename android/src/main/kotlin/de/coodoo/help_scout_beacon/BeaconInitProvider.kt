package de.coodoo.help_scout_beacon

import android.content.ContentProvider
import android.content.ContentValues
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import com.helpscout.beacon.Beacon

//pre-initialize Beacon at process start so Android process-death restoration of BeaconActivity
//doesn't crash with "Beacon not initialized". Reads default beaconId from the host app's
//AndroidManifest meta-data 'com.helpscout.beacon.BeaconId'. The locale-correct beaconId is
//re-applied later by the Flutter plugin's setup() call. ContentProvider.onCreate() is invoked
//by Android during process startup before any activity, so this runs even when no Flutter
//code has had a chance to execute yet.
class BeaconInitProvider : ContentProvider() {
    override fun onCreate(): Boolean {
        val ctx = context
        if (ctx != null) {
            try {
                val ai = ctx.packageManager.getApplicationInfo(ctx.packageName, PackageManager.GET_META_DATA)
                val beaconId = ai.metaData?.getString("com.helpscout.beacon.BeaconId")
                if (!beaconId.isNullOrEmpty()) {
                    Beacon.Builder().withBeaconId(beaconId).build()
                }
            } catch (_: Throwable) {
                //best-effort; don't crash process if SDK internals aren't ready or change shape
            }
        }
        return true
    }

    override fun query(uri: Uri, projection: Array<out String>?, selection: String?, selectionArgs: Array<out String>?, sortOrder: String?): Cursor? = null
    override fun getType(uri: Uri): String? = null
    override fun insert(uri: Uri, values: ContentValues?): Uri? = null
    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<out String>?): Int = 0
    override fun update(uri: Uri, values: ContentValues?, selection: String?, selectionArgs: Array<out String>?): Int = 0
}
