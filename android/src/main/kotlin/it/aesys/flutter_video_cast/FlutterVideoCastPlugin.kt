package it.aesys.flutter_video_cast

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** FlutterVideoCastPlugin */
class FlutterVideoCastPlugin : FlutterPlugin, ActivityAware {
    private var videoCastCallHandler: FlutterVideoCastCallHandler? = null
    private lateinit var chromeCastFactory: ChromeCastFactory

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // register button factory
        chromeCastFactory = ChromeCastFactory()
        binding
                .platformViewRegistry
                .registerViewFactory(
                        "ChromeCastButton",
                        chromeCastFactory
                )

        // video cast handler
        if (videoCastCallHandler == null) {
            videoCastCallHandler = FlutterVideoCastCallHandler(context = binding.applicationContext)
        }
        videoCastCallHandler?.startListening(binding.binaryMessenger)
        Messages.VideoCastApi.setup(binding.binaryMessenger, videoCastCallHandler)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        videoCastCallHandler?.stopListening()
        Messages.VideoCastApi.setup(binding.binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        chromeCastFactory.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
    }
}
