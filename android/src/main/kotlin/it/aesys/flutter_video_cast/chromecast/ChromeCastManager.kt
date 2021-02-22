package it.aesys.flutter_video_cast.chromecast

import android.content.Context
import android.net.Uri
import android.util.Log
import com.google.android.gms.cast.*
import com.google.android.gms.cast.MediaStatus
import com.google.android.gms.cast.framework.CastContext
import com.google.android.gms.cast.framework.Session
import com.google.android.gms.cast.framework.SessionManager
import com.google.android.gms.cast.framework.SessionManagerListener
import com.google.android.gms.cast.framework.media.RemoteMediaClient
import com.google.android.gms.common.api.ResultCallbacks
import com.google.android.gms.common.api.Status
import com.google.android.gms.common.images.WebImage
import org.json.JSONObject


class ChromeCastManager(private val context: Context) {
    companion object {
        const val TAG = "ChromeCastManager"

        /**
         * Special constant representing an unset or unknown time or duration. Suitable for use in any
         * time base.
         */
        const val TIME_UNSET = Long.MIN_VALUE + 1
    }

    private var mSessionManager: SessionManager? = null

    // observers
    private var mSessionStatusListener: SessionStatusListener? = null
    private var mRequestResultListener: RequestResultListener? = null
    private var mMediaStatusListener: MediaStatusListener? = null

    // inner listeners
    private val mCastSessionManagerListener = CastSessionManagerListener()
    private val mCastResultResponse = CastResultResponse()
    private val mRemoteMediaClientStatusListener = RemoteMediaClientStatusListener()
    private val mProgressListener = ProgressListener()

    private var mMediaInfo: MediaInfo? = null
    private var mMediaPlayerState: Int = MediaStatus.PLAYER_STATE_UNKNOWN

    fun initialise() {
        if (mSessionManager == null) {
            mSessionManager = CastContext.getSharedInstance()?.sessionManager
            if (mSessionManager?.currentCastSession != null) {
                val remoteMediaClient = mSessionManager?.currentCastSession?.remoteMediaClient
                        ?: return
                remoteMediaClient.unregisterCallback(mRemoteMediaClientStatusListener)
                remoteMediaClient.registerCallback(mRemoteMediaClientStatusListener)

                mSessionStatusListener?.onChange(CastSessionStatus.Resumed)
                Log.w(TAG, "onSessionResumed from initializer")
            }
        }
        mSessionManager?.addSessionManagerListener(mCastSessionManagerListener)
    }

    fun getAvailableDevices() {
        TODO("Not yet implemented")
    }

    fun getMediaInfo(): MediaInfo? {
        return mMediaInfo
    }

    fun setMediaInfo(mediaInfo: MediaInfo?) {
        this.mMediaInfo = mediaInfo
    }

    fun isConnected(): Boolean {
        return mSessionManager?.currentCastSession?.isConnected ?: false
    }

    fun getRemoteMediaClient(): RemoteMediaClient {
        return mSessionManager?.currentCastSession?.remoteMediaClient
                ?: throw FlutterVideoCastException("session is not started")
    }

    // MARK: - Build Meta

    fun buildMediaInformation(contentURL: String, title: String, description: String, studio: String, duration: Long?, streamType: Int, thumbnailUrl: String?, customData: JSONObject?): MediaInfo {
        val metadata = buildMetadata(title = title, description = description, studio = studio, thumbnailUrl = thumbnailUrl)

        mMediaInfo = MediaInfo.Builder(contentURL).apply {
            setContentUrl(contentURL)
            setStreamType(streamType)
            setMetadata(metadata)
            if (duration != null) {
                setStreamDuration(duration)
            }
            if (customData != null) {
                setCustomData(customData)
            }
        }.build()

        return mMediaInfo!!
    }

    private fun buildMetadata(title: String, description: String, studio: String, thumbnailUrl: String?): MediaMetadata {
        val metadata = MediaMetadata(MediaMetadata.MEDIA_TYPE_MOVIE)
        metadata.putString(MediaMetadata.KEY_TITLE, title)
        metadata.putString("description", description)
        val deviceName = mSessionManager?.currentCastSession?.castDevice?.friendlyName ?: studio
        metadata.putString(MediaMetadata.KEY_STUDIO, deviceName)

        if (thumbnailUrl != null) {
            metadata.addImage(WebImage((Uri.parse(thumbnailUrl))))
        }

        return metadata
    }

    // MARK: - Start

    fun startSelectedItemRemotely(mediaInfo: MediaInfo, time: Long, autoplay: Boolean) {
        val remoteMediaClient = getRemoteMediaClient()
        remoteMediaClient.load(MediaLoadRequestData.Builder()
                .setMediaInfo(mediaInfo)
                .setAutoplay(autoplay)
                .setCurrentTime(time).build())
                .setResultCallback(mCastResultResponse)

        // todo: need register progress listener on queue too
        remoteMediaClient.removeProgressListener(mProgressListener)
        remoteMediaClient.addProgressListener(mProgressListener, 1000)

        mSessionStatusListener?.onChange(CastSessionStatus.AlreadyConnected)
    }

    // MARK: - Play/Resume

    fun playSelectedItemRemotely() {
        val remoteMediaClient = getRemoteMediaClient()
        remoteMediaClient.play().setResultCallback(mCastResultResponse)
    }

    // MARK: - Pause

    fun pauseSelectedItemRemotely() {
        val remoteMediaClient = getRemoteMediaClient()
        remoteMediaClient.pause().setResultCallback(mCastResultResponse)
    }

    // MARK: - Stop

    fun stopSelectedItemRemotely() {
        val remoteMediaClient = getRemoteMediaClient()
        remoteMediaClient.stop().setResultCallback(mCastResultResponse)
    }

    // MARK: - Seek

    fun seekSelectedItemRemotely(time: Double, relative: Boolean) {
        val remoteMediaClient = getRemoteMediaClient()
        var interval = time * 1000L
        if (relative) {
            interval += remoteMediaClient.mediaStatus?.streamPosition ?: 0L
        }
        val options = MediaSeekOptions.Builder()
                .setPosition(interval.toLong())
                .setResumeState(MediaSeekOptions.RESUME_STATE_UNCHANGED)
                .build()
        remoteMediaClient.seek(options).setResultCallback(mCastResultResponse)
    }

    // MARK: - Get Current Time

    fun getCurrentPlaybackTime(): Long? {
        val remoteMediaClient = mSessionManager?.currentCastSession?.remoteMediaClient
        return remoteMediaClient?.approximateStreamPosition
    }

    // MARK: - Playing/Buffering status

    fun getMediaPlayerState(): Int {
        val status = mSessionManager?.currentCastSession?.remoteMediaClient?.mediaStatus
        if (status != null) {
            return status.playerState
        }

        return MediaStatus.PLAYER_STATE_UNKNOWN
    }

    // MARK: - Player Idle reason

    fun getMediaPlayerIdleReason(): Int {
        val status = mSessionManager?.currentCastSession?.remoteMediaClient?.mediaStatus
        if (status != null) {
            return status.idleReason
        }

        return MediaStatus.IDLE_REASON_NONE
    }

    fun getCurrentDevice(): CastDevice? {
        val session = mSessionManager?.currentCastSession
        if (session != null) {
            return session.castDevice
        }

        return null
    }

    /*
     * Listeners
     */
    fun addSessionStatusListener(listener: SessionStatusListener) {
        mSessionStatusListener = listener
    }

    fun addRequestResultListener(listener: RequestResultListener) {
        mRequestResultListener = listener
    }


    fun addMediaStatusListener(listener: MediaStatusListener) {
        mMediaStatusListener = listener
    }


    /*
     * Inner Classes
     */
    enum class CastSessionStatus {
        Started,
        Resumed,
        Ended,
        FailedToStart,
        AlreadyConnected,
        Connecting,
    }

    interface SessionStatusListener {
        fun onChange(status: CastSessionStatus)
    }

    interface RequestResultListener {
        fun onComplete()
        fun onError(error: String)
    }

    interface MediaStatusListener {
        fun onChange(client: RemoteMediaClient)
    }


    /**
     * Session Manager Listener responsible for switching the Playback instances
     * depending on whether it is connected to a remote player.
     */
    private inner class CastSessionManagerListener : SessionManagerListener<Session> {
        override fun onSessionStarting(session: Session) {
            mSessionStatusListener?.onChange(CastSessionStatus.Connecting)
        }

        override fun onSessionStarted(session: Session, sessionId: String) {
            val remoteMediaClient = mSessionManager?.currentCastSession?.remoteMediaClient
            remoteMediaClient?.unregisterCallback(mRemoteMediaClientStatusListener)
            remoteMediaClient?.registerCallback(mRemoteMediaClientStatusListener)

            mSessionStatusListener?.onChange(CastSessionStatus.Started)
            Log.w(TAG, "onSessionStarted")
        }

        override fun onSessionStartFailed(session: Session, error: Int) {
            val remoteMediaClient = mSessionManager?.currentCastSession?.remoteMediaClient
            remoteMediaClient?.unregisterCallback(mRemoteMediaClientStatusListener)

            mSessionStatusListener?.onChange(CastSessionStatus.FailedToStart)
            Log.w(TAG, "onSessionStartFailed")
        }

        override fun onSessionResuming(session: Session, sessionId: String) {
            mSessionStatusListener?.onChange(CastSessionStatus.Connecting)
        }

        override fun onSessionResumed(session: Session, wasSuspended: Boolean) {
            val remoteMediaClient = mSessionManager?.currentCastSession?.remoteMediaClient
            remoteMediaClient?.unregisterCallback(mRemoteMediaClientStatusListener)
            remoteMediaClient?.registerCallback(mRemoteMediaClientStatusListener)

            mSessionStatusListener?.onChange(CastSessionStatus.Resumed)
            Log.w(TAG, "onSessionResumed")
        }

        override fun onSessionResumeFailed(session: Session, error: Int) {
            val remoteMediaClient = mSessionManager?.currentCastSession?.remoteMediaClient ?: return
            remoteMediaClient.unregisterCallback(mRemoteMediaClientStatusListener)

            mSessionStatusListener?.onChange(CastSessionStatus.FailedToStart)
            Log.w(TAG, "onSessionResumeFailed")
        }

        override fun onSessionEnding(session: Session) {}
        override fun onSessionEnded(session: Session, error: Int) {
            val remoteMediaClient = mSessionManager?.currentCastSession?.remoteMediaClient
            remoteMediaClient?.unregisterCallback(mRemoteMediaClientStatusListener)

            mSessionStatusListener?.onChange(CastSessionStatus.Ended)
            Log.w(TAG, "onSessionEnded")
        }

        override fun onSessionSuspended(session: Session, reason: Int) {
            mSessionStatusListener?.onChange(CastSessionStatus.Ended)
        }
    }

    /**
     * CastResultResponse responsible for getting results from requests.
     */
    private inner class CastResultResponse : ResultCallbacks<RemoteMediaClient.MediaChannelResult>() {
        override fun onSuccess(p0: RemoteMediaClient.MediaChannelResult) {
            Log.d("CastResultResponse", "on Success")
            mRequestResultListener?.onComplete()
        }

        override fun onFailure(status: Status) {
            Log.d("CastResultResponse", "on Failure")
            mRequestResultListener?.onError(status.toString())
        }
    }

    /**
     * ProgressListener
     */
    private inner class ProgressListener : RemoteMediaClient.ProgressListener {
        override fun onProgressUpdated(progressMs: Long, unusedDurationMs: Long) {
            Log.d("ProgressListener", "progress $progressMs, duration $unusedDurationMs")
        }
    }

    /**
     * RemoteMediaClientStatusListener
     */
    private inner class RemoteMediaClientStatusListener : RemoteMediaClient.Callback() {
        override fun onStatusUpdated() {
            super.onStatusUpdated()
            val remoteMediaClient = mSessionManager?.currentCastSession?.remoteMediaClient ?: return
            val curPlayerState = remoteMediaClient.playerState
            if (mMediaPlayerState != curPlayerState) {
                when (curPlayerState) {
                    MediaStatus.PLAYER_STATE_UNKNOWN -> {
                        mProgressListener.onProgressUpdated(0, 0)
                    }
                    MediaStatus.PLAYER_STATE_IDLE -> {
                        mProgressListener.onProgressUpdated(0, 0)
                    }
                }
                mMediaStatusListener?.onChange(client = remoteMediaClient)
                mMediaPlayerState = curPlayerState
            }
        }
    }
}

fun Int?.playerStateToString(): String {
    return when (this) {
        MediaStatus.PLAYER_STATE_PLAYING -> "playing"
        MediaStatus.PLAYER_STATE_BUFFERING -> "buffering"
        MediaStatus.PLAYER_STATE_IDLE -> "idle"
        MediaStatus.PLAYER_STATE_LOADING -> "loading"
        MediaStatus.PLAYER_STATE_PAUSED -> "paused"
        else -> "unknown"
    }
}

fun Int?.idleReasonToString(): String {
    return when (this) {
        MediaStatus.IDLE_REASON_CANCELED -> "cancelled"
        MediaStatus.IDLE_REASON_ERROR -> "error"
        MediaStatus.IDLE_REASON_FINISHED -> "finished"
        MediaStatus.IDLE_REASON_INTERRUPTED -> "interrupted"
        else -> "none"
    }
}
