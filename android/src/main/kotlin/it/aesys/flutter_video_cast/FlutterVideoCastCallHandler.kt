package it.aesys.flutter_video_cast

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import it.aesys.flutter_video_cast.chromecast.ChromeCastManager

private fun MethodChannel.Result.success() = success(null)

class FlutterVideoCastCallHandler(private val context: Context) : Messages.VideoCastApi {
    companion object {
        private const val EVENT_CHANNEL = "flutter_video_cast/chromeCastEvent"
        private var callbackHandle: Long = 0

        fun getCallBackHandler(): Long {
            return callbackHandle
        }
    }

    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var castManager: ChromeCastManager? = null

    fun startListening(messenger: BinaryMessenger?) {
        eventChannel = EventChannel(messenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, _eventSink: EventChannel.EventSink) {
                eventSink = _eventSink
//                    eventSink.error("SensorError", "Cannot detect sensors. Not enabled", null)
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
        if(castManager == null) {
            castManager = ChromeCastManager(context)
        }
        castManager?.initialise()
    }

    override fun startDeviceDiscovery() {
//        TODO("Not yet implemented")
    }

    override fun discoverDevices(): Messages.DevicesMessage {
//        TODO("Not yet implemented")
        return  Messages.DevicesMessage()
    }

    override fun getCurrentDevice(): Messages.DevicesMessage {
        TODO("Not yet implemented")
    }

    override fun connect(arg: Messages.ConnectMessage?) {
        TODO("Not yet implemented")
    }

    override fun disconnect() {
        TODO("Not yet implemented")
    }

    override fun isConnected(): Messages.IsConnectedMessage {
        TODO("Not yet implemented")
    }

    override fun loadMedia(arg: Messages.LoadMediaMessage?) {
        TODO("Not yet implemented")
    }

    override fun play() {
        TODO("Not yet implemented")
    }

    override fun pause() {
        TODO("Not yet implemented")
    }

    override fun stop() {
        TODO("Not yet implemented")
    }

    override fun seek(arg: Messages.SeekMessage?) {
        TODO("Not yet implemented")
    }

    override fun isPlaying(): Messages.IsPlayingMessage {
        TODO("Not yet implemented")
    }

    override fun getPosition(): Messages.PositionMessage {
        TODO("Not yet implemented")
    }

}