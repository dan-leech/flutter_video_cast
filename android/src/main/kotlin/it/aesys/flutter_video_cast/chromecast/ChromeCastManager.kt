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


class ChromeCastManager(private val context: Context, private val activity: Activity) {
    companion object {
        const val TAG = "ChromeCastManager"
        private const val CHOOSER_FRAGMENT_TAG = "android.support.v7.mediarouter:MediaRouteChooserDialogFragment"
        private const val CONTROLLER_FRAGMENT_TAG = "android.support.v7.mediarouter:MediaRouteControllerDialogFragment"
    }

    private var sessionManager: SessionManager? = null
    private var sessionStatusListener: SessionStatusListener? = null
    private val castSessionManagerListener = CastSessionManagerListener()
    private lateinit var mSelector: MediaRouteSelector
    private lateinit var mRouter: MediaRouter
    private lateinit var mDialogFactory: MediaRouteDialogFactory

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

    private fun getFragmentManager(): FragmentManager? {
        return if (activity is FragmentActivity) {
            (activity as FragmentActivity?)!!.supportFragmentManager
        } else null
    }

    fun openCastDialog() {
        mSelector = MediaRouteSelector.Builder()
                // These are the framework-supported intents
                .addControlCategory("com.google.android.gms.cast.CATEGORY_CAST/CC1AD845///ALLOW_IPV6")
                .addControlCategory(MediaControlIntent.CATEGORY_REMOTE_PLAYBACK)
                .build()

        mRouter = MediaRouter.getInstance(activity)
        mDialogFactory = MediaRouteDialogFactory.getDefault()

        val chromeCastButton = MediaRouteButton(ContextThemeWrapper(activity, R.style.Theme_AppCompat_NoActionBar))
        CastButtonFactory.setUpMediaRouteButton(activity, chromeCastButton)
//
//        val vParams: ViewGroup.LayoutParams = ViewGroup.LayoutParams(
//                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT
//        )
//        val id = 0x123456
//        val container = FrameLayout(context)
//        container.layoutParams = vParams
//        container.id = id
//
//        activity.addContentView(chromeCastButton, vParams)
//
//
//
//        val nativeFragment = Fragment()
//        nativeFragment.activity?.addContentView(MediaRouteButton(ContextThemeWrapper(context, R.style.Theme_AppCompat_NoActionBar)), vParams)
//
        val fm: FragmentManager = getFragmentManager()
                ?: throw IllegalStateException("The activity must be a subclass of FragmentActivity")
//
//        fm.beginTransaction()
//                .replace(id, nativeFragment)
//                .commitAllowingStateLoss()
//
//        val handler = Handler()
//        handler.postDelayed({
//            chromeCastButton.performClick()
//        }, 5000)

        val route: MediaRouter.RouteInfo = mRouter.selectedRoute
        if (route.isDefault || !route.matchesSelector(mSelector)) {
            if (fm.findFragmentByTag(CHOOSER_FRAGMENT_TAG) != null) {
                Log.w(TAG, "showDialog(): Route chooser dialog already showing!")
                return
            }
            val f: MediaRouteChooserDialogFragment = mDialogFactory.onCreateChooserDialogFragment()
            f.routeSelector = mSelector
            f.show(fm, CHOOSER_FRAGMENT_TAG)
        } else {
            if (fm.findFragmentByTag(CONTROLLER_FRAGMENT_TAG) != null) {
                Log.w(TAG, "showDialog(): Route controller dialog already showing!")
                return
            }
            val f: MediaRouteControllerDialogFragment = mDialogFactory.onCreateControllerDialogFragment()
            f.show(fm, CONTROLLER_FRAGMENT_TAG)
        }

        if (sessionManager == null) {
            sessionManager = CastContext.getSharedInstance()?.sessionManager
        }
        sessionManager?.addSessionManagerListener(castSessionManagerListener)
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

    inner class frg: Fragment() {

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