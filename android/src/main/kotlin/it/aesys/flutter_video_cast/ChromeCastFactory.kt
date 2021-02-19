package it.aesys.flutter_video_cast

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView

class ChromeCastFactory() : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    var activity: Activity? = null

    override fun create(
            context: Context?,
            viewId: Int,
            args: Any?
    ): PlatformView = ChromeCastButton(
            context = activity
    )
}
