//
//  GoogleCastManager.swift
//  flutter_video_cast
//
//  Created by Daniil Kostin on 04.02.2021.
//

import Foundation
import GoogleCast
import AVFoundation
import MediaPlayer

enum CastSessionStatus {
    case started
    case resumed
    case ended
    case failedToStart
    case alreadyConnected
    case connecting
}

protocol CastManagerAvailableDeviceDelegate: class {
    func reloadAvailableDeviceData()
}

protocol CastManagerSeekLocalPlayerDelegate: class {
    func seekLocalPlayer(to time: TimeInterval)
}

protocol CastManagerDidUpdateMediaStatusDelegate: class {
    func gckDidUpdateMediaStatus(mediaInfo: GCKMediaInformation?)
}

protocol SessionStatusListener: class {
    func onChange(status: CastSessionStatus) -> Void
}

protocol RequestResultListener: class {
    func onComplete() -> Void
    func onError(error: String) -> Void
}

protocol DeviceDiscoveryListener: class {
    func onChange(devices: [GCKDevice]) -> Void
}

protocol GCKMediaInformationListener: class {
    func onChange(client: GCKRemoteMediaClient, mediaInfo: GCKMediaInformation?) -> Void
}

class GoogleCastManager: NSObject {
    
    static let instance = GoogleCastManager()
    
    weak var availableDeviceDelegate: CastManagerAvailableDeviceDelegate?
    weak var seekLocalPlayerDelegate: CastManagerSeekLocalPlayerDelegate?
    weak var didUpdateMediaStatusDelegate: CastManagerDidUpdateMediaStatusDelegate?
    
    private let kReceiverAppID = kGCKDefaultMediaReceiverApplicationID
    private let kDebugLoggingEnabled = true
    
    var sessionManager: GCKSessionManager!
    var hasConnectionEstablished: Bool {
        let castSession = sessionManager.currentCastSession
        if castSession != nil {
            return true
        } else {
            return false
        }
    }
    private var sessionStatusListener: SessionStatusListener?
    var sessionStatus: CastSessionStatus! {
        didSet {
            sessionStatusListener?.onChange(status: sessionStatus)
        }
    }
    private var requestResultListener: RequestResultListener?
    private var deviceDiscoveryListener: DeviceDiscoveryListener?
    private var gckMediaInformationListener: GCKMediaInformationListener?
    private var gckMediaInformation: GCKMediaInformation?
    
    var discoveryManager: GCKDiscoveryManager!
    private var availableDevices = [GCKDevice]()
    var deviceCategory = String()
    
    // MARK: - Init
    
    func initialise() {
        initialiseContext()
        initialiseDiscovery()
        createSessionManager()
        setupCastLogging()
        style()
        miniControllerStyle()
        styleConnectionController()
    }
    
    private func initialiseContext() {
        if GCKCastContext.isSharedInstanceInitialized() {
            return
        }
        
        let criteria = GCKDiscoveryCriteria(applicationID: kReceiverAppID)
        let options = GCKCastOptions(discoveryCriteria: criteria)
        options.suspendSessionsWhenBackgrounded = false
        options.physicalVolumeButtonsWillControlDeviceVolume = true
        GCKCastContext.setSharedInstanceWith(options)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
    }
    
    private func createSessionManager() {
        sessionManager = GCKCastContext.sharedInstance().sessionManager
        sessionManager.add(self)
    }
    
    private func initialiseDiscovery() {
        discoveryManager = GCKCastContext.sharedInstance().discoveryManager
        discoveryManager.add(self)
        discoveryManager.passiveScan = true
        discoveryManager.startDiscovery()
    }
    
    private func setupCastLogging() {
        let logFilter = GCKLoggerFilter()
        let classesToLog = ["GCKDeviceScanner", "GCKDeviceProvider", "GCKDiscoveryManager", "GCKCastChannel", "GCKMediaControlChannel", "GCKUICastButton", "GCKUIMediaController", "NSMutableDictionary"]
        logFilter.setLoggingLevel(.verbose, forClasses: classesToLog)
        GCKLogger.sharedInstance().filter = logFilter
        GCKLogger.sharedInstance().delegate = self
    }
    
    private func addRemoteMediaListerner() {
        guard let currSession = sessionManager.currentCastSession else {
            return
        }
        currSession.remoteMediaClient?.add(self)
    }
    
    private func removeRemoteMediaListener() {
        guard let currSession = sessionManager.currentCastSession else {
            return
        }
        currSession.remoteMediaClient?.remove(self)
    }
    
    func addSessionStatusListener(listener: SessionStatusListener) {
        self.sessionStatusListener = listener
    }
    
    func addRequestResultListenerListener(listener: RequestResultListener) {
        self.requestResultListener = listener
    }
    
    func addDeviceDiscoveryListener(listener: DeviceDiscoveryListener) {
        self.deviceDiscoveryListener = listener
    }
    
    func addGCKMediaInformationListenerlistener(listener: GCKMediaInformationListener) {
        self.gckMediaInformationListener = listener
    }
    
    //styling connection list view and expanded media control view
    private func style() {
        let castStyle = GCKUIStyle.sharedInstance()
        castStyle.castViews.backgroundColor = .black
        castStyle.castViews.bodyTextColor = .white
        castStyle.castViews.buttonTextColor = .white
        castStyle.castViews.headingTextColor = .white
        castStyle.castViews.captionTextColor = .white
        castStyle.castViews.iconTintColor = .white
        
        castStyle.apply()
    }
    
    private func styleConnectionController() {
        let castStyle = GCKUIStyle.sharedInstance()
        //castStyle.castViews.deviceControl.connectionController.buttonTextColor = .nodesColor
        castStyle.apply()
    }
    
    //Styling mini controller
    private func miniControllerStyle() {
        let castStyle = GCKUIStyle.sharedInstance()
        castStyle.castViews.mediaControl.miniController.backgroundColor = .darkGray
        castStyle.castViews.mediaControl.miniController.bodyTextColor = .white
        castStyle.castViews.mediaControl.miniController.buttonTextColor = .white
        castStyle.castViews.mediaControl.miniController.headingTextColor = .white
        castStyle.castViews.mediaControl.miniController.captionTextColor = .white
        castStyle.castViews.mediaControl.miniController.iconTintColor = .white
        
        castStyle.apply()
    }
    
    func getAvailableDevices() -> [GCKDevice] {
        return availableDevices
    }
    
    func getMediaInfo() -> GCKMediaInformation? {
        return gckMediaInformation
    }
    
    func setMediaInfo(with mediaInfo: GCKMediaInformation?) {
        self.gckMediaInformation = mediaInfo
    }
    
    // MARK: - Build Meta
    
    func buildMediaInformation(contentURL: URL, title: String, description: String, studio: String, duration: TimeInterval?, streamType: GCKMediaStreamType, thumbnailUrl: String?, customData: Any?) -> GCKMediaInformation {
        let metadata = buildMetadata(title: title, description: description, studio: studio, thumbnailUrl: thumbnailUrl)
        
        let mediaInfoBuilder = GCKMediaInformationBuilder()
        mediaInfoBuilder.contentURL = contentURL
        mediaInfoBuilder.streamType = streamType
        mediaInfoBuilder.contentType = ""
        mediaInfoBuilder.metadata = metadata
        mediaInfoBuilder.adBreaks = nil
        mediaInfoBuilder.adBreakClips = nil
        if duration != nil {
            mediaInfoBuilder.streamDuration = duration!
        }
        mediaInfoBuilder.mediaTracks = nil
        mediaInfoBuilder.textTrackStyle = nil
        mediaInfoBuilder.customData = nil
        let mediaInfo = mediaInfoBuilder.build()
        
        return mediaInfo
    }
    
    private func buildMetadata(title: String, description: String, studio: String, thumbnailUrl: String?) -> GCKMediaMetadata {
        let metadata = GCKMediaMetadata.init(metadataType: .movie)
        metadata.setString(title, forKey: kGCKMetadataKeyTitle)
        metadata.setString(description, forKey: "description")
        let deviceName = sessionManager.currentCastSession?.device.friendlyName ?? studio
        metadata.setString(deviceName, forKey: kGCKMetadataKeyStudio)
        
        if let thumbnailUrl = thumbnailUrl, let url = URL(string: thumbnailUrl) {
            metadata.addImage(GCKImage.init(url: url, width: 480, height: 360))
        }
        
        return metadata
    }
    
    // MARK: - Start
    
    func startSelectedItemRemotely(_ mediaInfo: GCKMediaInformation, at time: TimeInterval, autoplay: Bool, completion: (Bool) -> Void) {
        if let castSession = sessionManager.currentCastSession {
            let options = GCKMediaLoadOptions()
            options.playPosition = time
            options.autoplay = autoplay
            if let request = castSession.remoteMediaClient?.loadMedia(mediaInfo, with: options) {
                request.delegate = self
            }
            completion(true)
            
            sessionStatus = .alreadyConnected
        } else {
            completion(false)
        }
    }
    
    // MARK: - Play/Resume
    
    func playSelectedItemRemotely(completion: (Bool) -> Void) {
        if let castSession = sessionManager.currentCastSession,
           let remoteClient = castSession.remoteMediaClient {
            let request = remoteClient.play()
            request.delegate = self
            
            completion(true)
        } else {
            completion(false)
        }
    }
    
    // MARK: - Pause
    
    func pauseSelectedItemRemotely(completion: (Bool) -> Void) {
        if let castSession = sessionManager.currentCastSession,
           let remoteClient = castSession.remoteMediaClient {
            let request = remoteClient.pause()
            request.delegate = self
            
            completion(true)
        } else {
            completion(false)
        }
    }
    
    // MARK: - Stop
    
    func stopSelectedItemRemotely(completion: (Bool) -> Void) {
        if let castSession = sessionManager.currentCastSession,
           let remoteClient = castSession.remoteMediaClient {
            let request = remoteClient.stop()
            request.delegate = self
            
            completion(true)
        } else {
            completion(false)
        }
    }
    
    // MARK: - Seek
    
    func seekSelectedItemRemotely(at time: TimeInterval, relative: Bool, completion: (Bool) -> Void) {
        if let castSession = sessionManager.currentCastSession,
           let remoteClient = castSession.remoteMediaClient {
            let options = GCKMediaSeekOptions()
            options.interval = time
            options.relative = relative
            let request = remoteClient.seek(with: options)
            request.delegate = self
            
            completion(true)
        } else {
            completion(false)
        }
    }
    
    // MARK: - Get Current Time
    
    func getCurrentPlaybackTime() -> TimeInterval? {
        if let castSession = sessionManager.currentCastSession,
           let remoteClient = castSession.remoteMediaClient {
            return remoteClient.approximateStreamPosition()
        }
        return nil
    }
    
    // MARK: - Playing/Buffering status
    
    func getMediaPlayerState() -> GCKMediaPlayerState {
        if let castSession = sessionManager.currentCastSession,
           let remoteClient = castSession.remoteMediaClient,
           let mediaStatus = remoteClient.mediaStatus {
            return mediaStatus.playerState
        }
        
        return GCKMediaPlayerState.unknown
    }
    
    // MARK: - Player Idle reason
    
    func getMediaPlayerIdleReason() -> GCKMediaPlayerIdleReason {
        if let castSession = sessionManager.currentCastSession,
           let remoteClient = castSession.remoteMediaClient,
           let mediaStatus = remoteClient.mediaStatus {
            return mediaStatus.idleReason
        }
        
        return GCKMediaPlayerIdleReason.none
    }
}

// MARK: - GCKDiscoveryManagerListener
extension GoogleCastManager: GCKDiscoveryManagerListener {
    func didStartDiscovery(forDeviceCategory deviceCategory: String) {
        self.deviceCategory = deviceCategory
    }
    
    func didUpdateDeviceList() {
        print("\(discoveryManager.deviceCount) device(s) has been discovered")
        deviceDiscoveryListener?.onChange(devices: getAvailableDevices())
    }
    
    func didInsert(_ device: GCKDevice, at index: UInt) {
        availableDevices.append(device)
        availableDeviceDelegate?.reloadAvailableDeviceData()
    }
    
    func didRemoveDevice(at index: UInt) {
        availableDevices.remove(at: Int(index))
        availableDeviceDelegate?.reloadAvailableDeviceData()
    }
}

// MARK: - Device Operation
extension GoogleCastManager {
    func isConnected() -> Bool {
        return sessionManager.hasConnectedCastSession()
    }
    
    func connectToDevice(device: GCKDevice) {
        if discoveryManager.deviceCount == 0 && sessionManager.hasConnectedCastSession() {
            return
        }
        
        sessionStatus = .connecting
        sessionManager.startSession(with: device)
    }
    
    func disconnectFromCurrentDevice() {
        if isConnected() {
            removeRemoteMediaListener()
            sessionManager.endSession()
        }
    }
}

// MARK: - GCKRequestDelegate
extension GoogleCastManager: GCKRequestDelegate {
    func requestDidComplete(_ request: GCKRequest) {
        requestResultListener?.onComplete()
    }
    
    func request(_ request: GCKRequest, didFailWithError error: GCKError) {
        requestResultListener?.onError(error: error.localizedDescription)
    }
}

// MARK: - GCKSessionManagerListener
extension GoogleCastManager: GCKSessionManagerListener {
    public func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        print("sessionManager started")
        sessionStatus = .started
        addRemoteMediaListerner()
    }
    
    public func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        print("sessionManager resumed")
        sessionStatus = .resumed
        addRemoteMediaListerner()
    }
    
    public func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        print("sessionManager ended")
        sessionStatus = .ended
    }
    
    public func sessionManager(_ sessionManager: GCKSessionManager, didFailToStart session: GCKSession, withError error: Error) {
        print("sessionManager failed to start")
        sessionStatus = .failedToStart
    }
    
    public func sessionManager(_ sessionManager: GCKSessionManager, didSuspend session: GCKSession, with reason: GCKConnectionSuspendReason) {
        print("sessionManager suspended")
        sessionStatus = .ended
    }
}

extension GoogleCastManager: GCKRemoteMediaClientListener {
    func remoteMediaClient(_ client: GCKRemoteMediaClient, didUpdate mediaStatus: GCKMediaStatus?) {
        didUpdateMediaStatusDelegate?.gckDidUpdateMediaStatus(mediaInfo: mediaStatus?.mediaInformation)
        setMediaInfo(with: mediaStatus?.mediaInformation)
        gckMediaInformationListener?.onChange(client: client, mediaInfo: gckMediaInformation)
    }
}

extension GoogleCastManager: GCKLoggerDelegate {
    func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        if (kDebugLoggingEnabled) {
            print(function + " - " + message)
        }
    }
}

func == (left: GCKDevice, right: GCKDevice) -> Bool {
    return left.deviceID == right.deviceID && left.uniqueID == right.uniqueID
}

func != (left: GCKDevice, right: GCKDevice) -> Bool {
    return left.deviceID != right.deviceID && left.uniqueID != right.uniqueID
}

extension GCKMediaPlayerState {
    func toString() -> String {
        switch self.rawValue {
        case GCKMediaPlayerState.playing.rawValue:
            return "playing"
        case GCKMediaPlayerState.buffering.rawValue:
            return "buffering"
        case GCKMediaPlayerState.idle.rawValue:
            return "idle"
        case GCKMediaPlayerState.loading.rawValue:
            return "loading"
        case GCKMediaPlayerState.paused.rawValue:
            return "paused"
        default:
            return "unknown"
        }
    }
}

extension GCKMediaPlayerIdleReason {
    func toString() -> String {
        switch self.rawValue {
        case GCKMediaPlayerIdleReason.cancelled.rawValue:
            return "cancelled"
        case GCKMediaPlayerIdleReason.error.rawValue:
            return "error"
        case GCKMediaPlayerIdleReason.finished.rawValue:
            return "finished"
        case GCKMediaPlayerIdleReason.interrupted.rawValue:
            return "interrupted"
        default:
            return "none"
        }
    }
}
