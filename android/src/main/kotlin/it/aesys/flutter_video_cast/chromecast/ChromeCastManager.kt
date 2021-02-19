package it.aesys.flutter_video_cast.chromecast

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.util.Log
import android.view.ContextThemeWrapper
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import androidx.mediarouter.app.MediaRouteButton
import androidx.mediarouter.app.MediaRouteChooserDialogFragment
import androidx.mediarouter.app.MediaRouteControllerDialogFragment
import androidx.mediarouter.app.MediaRouteDialogFactory
import androidx.mediarouter.media.MediaControlIntent
import androidx.mediarouter.media.MediaRouteSelector
import androidx.mediarouter.media.MediaRouter
import com.google.android.gms.cast.framework.*
import com.google.android.gms.common.api.PendingResult
import com.google.android.gms.common.api.Status
import it.aesys.flutter_video_cast.R


class ChromeCastManager(private val context: Context) {
    companion object {
        const val TAG = "ChromeCastManager"
    }

    private var sessionManager: SessionManager? = null
    private var sessionStatusListener: SessionStatusListener? = null
    private val castSessionManagerListener = CastSessionManagerListener()

    fun initialise() {
        initialiseContext()
        initialiseDiscovery()
        createSessionManager()
        setupCastLogging()
    }

    fun initialiseContext() {

    }

    fun initialiseDiscovery() {}

    fun createSessionManager() {

    }

    fun setupCastLogging() {}

    /*
     * Listeners
     */
    fun addSessionStatusListener(listener: SessionStatusListener) {
        sessionStatusListener = listener
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

    /**
     * Session Manager Listener responsible for switching the Playback instances
     * depending on whether it is connected to a remote player.
     */
    private inner class CastSessionManagerListener : SessionManagerListener<Session> {
        override fun onSessionStarting(session: Session) {
            sessionStatusListener?.onChange(CastSessionStatus.Connecting)
        }

        override fun onSessionStarted(session: Session, sessionId: String) {
            sessionStatusListener?.onChange(CastSessionStatus.Started)
            Log.w(TAG, "onSessionStarted")
        }

        override fun onSessionStartFailed(session: Session, error: Int) {
            sessionStatusListener?.onChange(CastSessionStatus.FailedToStart)
        }

        override fun onSessionResuming(session: Session, sessionId: String) {
            sessionStatusListener?.onChange(CastSessionStatus.Connecting)
        }

        override fun onSessionResumed(session: Session, wasSuspended: Boolean) {
            sessionStatusListener?.onChange(CastSessionStatus.Resumed)
        }

        override fun onSessionResumeFailed(session: Session, error: Int) {
            sessionStatusListener?.onChange(CastSessionStatus.FailedToStart)
        }

        override fun onSessionEnding(session: Session) {}
        override fun onSessionEnded(session: Session, error: Int) {
            sessionStatusListener?.onChange(CastSessionStatus.Ended)
            Log.w(TAG, "onSessionEnded")
        }

        override fun onSessionSuspended(session: Session, reason: Int) {
            sessionStatusListener?.onChange(CastSessionStatus.Ended)
        }
    }

    /**
     * CastResultResponse responsible for getting results from requests.
     */
    private inner class CastResultResponse : PendingResult.StatusListener {
        override fun onComplete(status: Status?) {
            if (status?.isSuccess == true) {

            }
        }
    }
}