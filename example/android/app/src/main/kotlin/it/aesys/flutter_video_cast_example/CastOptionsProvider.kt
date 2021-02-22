package it.aesys.flutter_video_cast_example

import android.content.Context
import com.google.android.gms.cast.CastMediaControlIntent
import com.google.android.gms.cast.LaunchOptions
import com.google.android.gms.cast.MediaMetadata
import com.google.android.gms.cast.framework.CastOptions
import com.google.android.gms.cast.framework.OptionsProvider
import com.google.android.gms.cast.framework.SessionProvider
import com.google.android.gms.cast.framework.media.*
import com.google.android.gms.common.images.WebImage
import java.util.*

class CastOptionsProvider : OptionsProvider {
    companion object {
        private const val CUSTOM_NAMESPACE = "urn:x-cast:custom_namespace"
    }

    override fun getCastOptions(context: Context): CastOptions? {
        val notificationOptions = NotificationOptions.Builder()
                .setActions(
                        Arrays.asList(
//                                MediaIntentReceiver.ACTION_SKIP_NEXT,
                                MediaIntentReceiver.ACTION_TOGGLE_PLAYBACK,
                                MediaIntentReceiver.ACTION_STOP_CASTING
                        ), intArrayOf(1, 2)
                )
                //.setTargetActivityClassName(ExpandedControlsActivity::class.java.getName())
                .build()
        val mediaOptions = CastMediaOptions.Builder()
                .setImagePicker(ImagePickerImpl())
                .setNotificationOptions(notificationOptions)
                //.setExpandedControllerActivityClassName(ExpandedControlsActivity::class.java.getName())
                .build()

        /** Following lines enable Cast Connect  */
        val launchOptions = LaunchOptions.Builder()
                .build()

        return CastOptions.Builder()
                .setLaunchOptions(launchOptions)
                .setReceiverApplicationId(CastMediaControlIntent.DEFAULT_MEDIA_RECEIVER_APPLICATION_ID)
                .setCastMediaOptions(mediaOptions)
                .build()
    }

    override fun getAdditionalSessionProviders(appContext: Context?): List<SessionProvider?>? {
        return null
    }

    inner class ImagePickerImpl : ImagePicker() {
        override fun onPickImage(mediaMetadata: MediaMetadata?, hints: ImageHints): WebImage? {
            val type = hints.type
            if (mediaMetadata == null || !mediaMetadata.hasImages()) {
                return null
            }
            val images = mediaMetadata.images
            return if (images.size == 1) {
                images[0]
            } else {
                if (type == IMAGE_TYPE_MEDIA_ROUTE_CONTROLLER_DIALOG_BACKGROUND) {
                    images[0]
                } else {
                    images[1]
                }
            }
        }
    }
}