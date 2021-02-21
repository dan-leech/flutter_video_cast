package it.aesys.flutter_video_cast

import android.content.Context
import android.util.Log
import com.google.android.gms.cast.CastDevice
import com.google.android.gms.cast.MediaInfo
import com.google.android.gms.cast.MediaStatus
import com.google.android.gms.cast.framework.media.RemoteMediaClient
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import it.aesys.flutter_video_cast.chromecast.ChromeCastManager
import it.aesys.flutter_video_cast.chromecast.idleReasonToString
import it.aesys.flutter_video_cast.chromecast.playerStateToString

private fun MethodChannel.Result.success() = success(null)

class FlutterVideoCastCallHandler(private val context: Context) : Messages.VideoCastApi {
    companion object {
        private const val TAG = "FlutterVideoCastCallHdl"
        private const val EVENT_CHANNEL = "flutter_video_cast/chromeCastEvent"
    }

    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var castManager: ChromeCastManager? = null

    private val mSessionStatusListener = SessionStatusListener()
    private val mMediaStatusListener = MediaStatusListener()
    private val mRequestResultListener = RequestResultListener()

    fun startListening(messenger: BinaryMessenger?) {
        eventChannel = EventChannel(messenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, _eventSink: EventChannel.EventSink) {
                eventSink = _eventSink
            }

            override fun onCancel(o: Any) {
                eventSink = null
            }
        })
    }

    /**
     * Clears this instance from listening to method calls.
     *
     *
     * Does nothing if [.startListening] hasn't been called, or if we're already stopped.
     */
    fun stopListening() {
        eventChannel.setStreamHandler(null)
        eventSink = null
    }

    override fun initialize() {
        if (castManager == null) {
            castManager = ChromeCastManager(context)
        }
        // resume event can be emitted on initialize
        castManager?.addSessionStatusListener(mSessionStatusListener)
        castManager?.addRequestResultListener(mRequestResultListener)
        castManager?.addMediaStatusListener(mMediaStatusListener)

        castManager?.initialise()
    }

    override fun startDeviceDiscovery() {
//        TODO("Not yet implemented")
    }

    override fun discoverDevices(): Messages.DevicesMessage {
//        TODO("Not yet implemented")
        return Messages.DevicesMessage()
    }

    override fun getCurrentDevice(): Messages.DevicesMessage {
        val device = castManager?.getCurrentDevice()

        val res = Messages.DevicesMessage()
        if (device != null) {
            res.devicesData = convertDevicesToJson(devices = arrayOf(device))
        }

        return res
    }

    override fun connect(arg: Messages.ConnectMessage?) {
        TODO("Not yet implemented")
    }

    override fun disconnect() {
        TODO("Not yet implemented")
    }

    override fun isConnected(): Messages.IsConnectedMessage {
        val res = Messages.IsConnectedMessage()
        res.isConnected = if (castManager?.isConnected() == true) 1 else 0

        return res
    }

    override fun loadMedia(arg: Messages.LoadMediaMessage?) {
        val mediaUrl = arg?.url ?: {
            Log.e(TAG, "Invalid url: ${arg?.url}")
        }

        val mediaInformation = castManager?.buildMediaInformation(contentURL = mediaUrl as String,
                title = arg?.title ?: "", description = arg?.descr ?: "",
                studio = arg?.studio ?: "", duration = null,
                streamType = MediaInfo.STREAM_TYPE_BUFFERED, thumbnailUrl = arg?.thumbnailUrl,
                customData = null)

        castManager?.startSelectedItemRemotely(mediaInformation!!, time = arg?.position
                ?: 0, autoplay = arg?.autoPlay ?: true)
    }

    override fun play() {
        castManager?.playSelectedItemRemotely()
    }

    override fun pause() {
        castManager?.pauseSelectedItemRemotely()
    }

    override fun stop() {
        castManager?.stopSelectedItemRemotely()
    }

    override fun seek(arg: Messages.SeekMessage?) {
        castManager?.seekSelectedItemRemotely(time = arg?.interval ?: 0.0, relative = arg?.relative
                ?: false)
    }

    override fun isPlaying(): Messages.IsPlayingMessage {
        val state = castManager?.getMediaPlayerState()

        val res = Messages.IsPlayingMessage()
        res.isPlaying = if (state == MediaStatus.PLAYER_STATE_PLAYING) 1 else 0

        return res
    }

    override fun getPosition(): Messages.PositionMessage {
        val pos = castManager?.getCurrentPlaybackTime()

        val res = Messages.PositionMessage()
        res.position = (pos ?: 0L).toDouble() / 1000.0

        return res
    }

    private fun convertDevicesToJson(devices: Array<CastDevice>): String? {
        val devicesData: MutableList<Map<String, String>> = mutableListOf()
        for (device in devices) {
            val item: MutableMap<String, String> = HashMap()
            item["id"] = device.deviceId
            item["name"] = device.friendlyName

            devicesData.add(item.toMap())
        }
        return Gson().toJson(devicesData)
    }

    /**
     * SessionStatusListener
     */
    private inner class SessionStatusListener : ChromeCastManager.SessionStatusListener {
        override fun onChange(status: ChromeCastManager.CastSessionStatus) {
            val event: MutableMap<String, Any> = HashMap()
            event["event"] = when (status) {
                ChromeCastManager.CastSessionStatus.Started -> "didStartSession"
                ChromeCastManager.CastSessionStatus.Resumed -> "resumedSession"
                ChromeCastManager.CastSessionStatus.Connecting -> "connectingSession"
                ChromeCastManager.CastSessionStatus.Ended -> "didEndSession"
                ChromeCastManager.CastSessionStatus.AlreadyConnected -> "alreadyConnectedSession"
                ChromeCastManager.CastSessionStatus.FailedToStart -> "failedToStartSession"
            }

            eventSink?.success(event)
        }
    }

    /**
     * RequestResultListener
     */
    private inner class RequestResultListener : ChromeCastManager.RequestResultListener {
        override fun onComplete() {
            val event: MutableMap<String, Any> = HashMap()
            event["event"] = "requestDidComplete"

            eventSink?.success(event)
        }

        override fun onError(error: String) {
            val event: MutableMap<String, Any> = HashMap()
            event["event"] = "requestDidFail"
            event["error"] = error

            eventSink?.success(event)
        }
    }

    /**
     * MediaStatusListener
     */
    private inner class MediaStatusListener : ChromeCastManager.MediaStatusListener {
        override fun onChange(client: RemoteMediaClient) {
            val duration = client.mediaInfo?.streamDuration
            val position = client.approximateStreamPosition

            val event: MutableMap<String, Any> = HashMap()
            event["event"] = "didUpdatePlayback"

            if (duration != null && duration != ChromeCastManager.TIME_UNSET) {
                event["duration"] = duration as Any
            }

            if (position != ChromeCastManager.TIME_UNSET) {
                event["position"] = position as Any
            }

            event["state"] = client.mediaStatus?.playerState.playerStateToString()
            event["idleReason"] = client.mediaStatus?.idleReason.idleReasonToString()

            eventSink?.success(event)
        }
    }
}