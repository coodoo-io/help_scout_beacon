// Autogenerated from Pigeon (v17.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon


import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/**
 * Beacon route/screen
 * * https://developer.helpscout.com/beacon-2/android-api/beacon/com.helpscout.beacon.model/-beacon-screens/index.html
 */
enum class HSBeaconRoute(val raw: Int) {
  /** Opens to the Home (Ask/Answers) screen (default value) */
  ASK(0),
  /** Chat screen */
  CHAT(1),
  /** Open docs with optional search parameter (requires docs enabled and optionally a search param) */
  DOCS(2),
  /** Article screen (requires an Article ID and docs enabled) */
  ARTICLE(3),
  /** Contact form (requires messaging enabled) */
  CONTACT_FORM(4),
  /** Previous Messages if any exist. */
  PREVIOUS_MESSAGES(5);

  companion object {
    fun ofRaw(raw: Int): HSBeaconRoute? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/**
 * HSBeaconFocusMode represents various configuration modes of Beacon. Allowing you to customize the experience your users have, from getting in contact right away, to a more self service approach.
 * * More info is available AT https://docs.helpscout.com/article/1296-work-with-beacon-modes
 */
enum class HSBeaconFocusMode(val raw: Int) {
  /** An option to see both help articles and contact options side by side */
  NEUTRAL(0),
  /** An option to see help articles first and contact options after interacting with content */
  SELF_SERVICE(1),
  /** An option to see contact options first and help articles second */
  ASK_FIRST(2);

  companion object {
    fun ofRaw(raw: Int): HSBeaconFocusMode? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/**
 * Beacon Settings overrides
 * * https://developer.helpscout.com/beacon-2/android-api/beacon/com.helpscout.beacon.model/-beacon-screens/index.html
 * * https://developer.helpscout.com/beacon-2/ios-api/Classes/HSBeaconSettings.html
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class HSBeaconSettings (
  /** The Beacon ID to use. */
  val beaconId: String,
  /** The title used in the main Beacon interface. This is Support by default. */
  val beaconTitle: String? = null,
  /**
   * Disable the Docs integration manually if it’s enabled in the Beacon config.
   * This will not enable Docs if it’s disabled in the config.
   */
  val docsEnabled: Boolean? = null,
  /**
   * Disable the contact options manually if it’s enabled in the Beacon config.
   * This will not enable the contact options if it’s disabled in the config.
   */
  val messagingEnabled: Boolean? = null,
  /**
   * Disable the Chat integration manually if it’s enabled in the Beacon config.
   * This will not enable Chat if it’s disabled in the config.
   */
  val chatEnabled: Boolean? = null,
  /** Disable previous messages manually if messaging is enabled in the Beacon config. */
  val enablePreviousMessages: Boolean,
  /** If your Beacon has Docs and Messaging (email or chat) enabled, this mode controls the user experience of the beacon */
  val focusMode: HSBeaconFocusMode? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): HSBeaconSettings {
      val beaconId = list[0] as String
      val beaconTitle = list[1] as String?
      val docsEnabled = list[2] as Boolean?
      val messagingEnabled = list[3] as Boolean?
      val chatEnabled = list[4] as Boolean?
      val enablePreviousMessages = list[5] as Boolean
      val focusMode: HSBeaconFocusMode? = (list[6] as Int?)?.let {
        HSBeaconFocusMode.ofRaw(it)
      }
      return HSBeaconSettings(beaconId, beaconTitle, docsEnabled, messagingEnabled, chatEnabled, enablePreviousMessages, focusMode)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      beaconId,
      beaconTitle,
      docsEnabled,
      messagingEnabled,
      chatEnabled,
      enablePreviousMessages,
      focusMode?.raw,
    )
  }
}

/**
 * Beacon user
 * * https://developer.helpscout.com/beacon-2/android-api/beacon/com.helpscout.beacon.model/-beacon-user/index.html
 * * https://developer.helpscout.com/beacon-2/ios-api/Classes/HSBeaconUser.html
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class HSBeaconUser (
  /** The email address for the current user. */
  val email: String,
  /** The name of the current user. */
  val name: String? = null,
  /** The company of the current user. The max length of this value is 60 and will be truncated to fit. */
  val company: String? = null,
  /** The job title of the current user. The max length of this value is 60 and will be truncated to fit. */
  val jobTitle: String? = null,
  /** The URL to the avatar of the current user. The max length of this value is 200 and will not be set if the absoluteString exceeds that length. */
  val avatar: String? = null,
  /** The attributes for the current user. These are arbitrary key/value pairs that will be sent to Help Scout to help identify the current user. You may add up to 30 different attributes. */
  val attributes: Map<Any, Any?>? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): HSBeaconUser {
      val email = list[0] as String
      val name = list[1] as String?
      val company = list[2] as String?
      val jobTitle = list[3] as String?
      val avatar = list[4] as String?
      val attributes = list[5] as Map<Any, Any?>?
      return HSBeaconUser(email, name, company, jobTitle, avatar, attributes)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      email,
      name,
      company,
      jobTitle,
      avatar,
      attributes,
    )
  }
}
@Suppress("UNCHECKED_CAST")
private object HelpScoutBeaconApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          HSBeaconSettings.fromList(it)
        }
      }
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          HSBeaconUser.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is HSBeaconSettings -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      is HSBeaconUser -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/**
 * Help Scout Beacon API
 *
 * Generated interface from Pigeon that represents a handler of messages from Flutter.
 */
interface HelpScoutBeaconApi {
  /** Signs in with a Beacon user. This gives Beacon access to the user’s name, email address, and signature. */
  fun identify(beaconUser: HSBeaconUser)
  /** Opens the Beacon SDK from a specific view controller. The Beacon view controller will be presented as a modal. */
  fun open(settings: HSBeaconSettings, route: HSBeaconRoute, parameter: String?)
  /** Logs the current Beacon user out and clears out their information from local storage. */
  fun clear()

  companion object {
    /** The codec used by HelpScoutBeaconApi. */
    val codec: MessageCodec<Any?> by lazy {
      HelpScoutBeaconApiCodec
    }
    /** Sets up an instance of `HelpScoutBeaconApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: HelpScoutBeaconApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.help_scout_beacon.HelpScoutBeaconApi.identify", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val beaconUserArg = args[0] as HSBeaconUser
            var wrapped: List<Any?>
            try {
              api.identify(beaconUserArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.help_scout_beacon.HelpScoutBeaconApi.open", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val settingsArg = args[0] as HSBeaconSettings
            val routeArg = HSBeaconRoute.ofRaw(args[1] as Int)!!
            val parameterArg = args[2] as String?
            var wrapped: List<Any?>
            try {
              api.open(settingsArg, routeArg, parameterArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.help_scout_beacon.HelpScoutBeaconApi.clear", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.clear()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
