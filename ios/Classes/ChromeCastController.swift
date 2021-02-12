//
//  ChromeCastManager.swift
//  flutter_video_cast
//
//  Created by Daniil Kostin on 02/03/2020.
//

import Flutter
import GoogleCast

class ChromeCastController: NSObject {
    // MARK: - Internal properties
    private let castManager = GoogleCastManager.instance
    var eventSink: FlutterEventSink?
    
    // MARK: - Init
    
    init(
        registrar: FlutterPluginRegistrar
    ) {
        super.init()
        
        let eventChannel = FlutterEventChannel(
            name: "flutter_video_cast/chromeCastEvent",
            binaryMessenger: registrar.messenger())
        
        eventChannel.setStreamHandler(self)
    }
}

// MARK: - FLTVideoCastApi

extension ChromeCastController: FLTVideoCastApi {
    func initialize(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        castManager.initialise()
        castManager.addSessionStatusListener(listener: self)
        castManager.addRequestResultListenerListener(listener: self)
        castManager.addDeviceDiscoveryListener(listener: self)
        castManager.addGCKMediaInformationListenerlistener(listener: self)
    }
    
    func startDeviceDiscovery(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        castManager.startDeviceDiscovery()
    }
    
    func discoverDevices(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTDevicesMessage? {
        let devices = castManager.getAvailableDevices()
        //        NSLog("devices: %i", devices.count)
        
        let res = FLTDevicesMessage()
        res.devicesData = convertDevicesToJson(devices: devices)
        //        NSLog("json: %@", NSString(string: json!))
        
        return res
    }
    
    func getCurrentDevice(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTDevicesMessage? {
        let device = castManager.getCurrentDevice()
        
        let res = FLTDevicesMessage()
        if device != nil {
          res.devicesData = convertDevicesToJson(devices: [device!])
        }
        
        return res
    }
    
    func isConnected(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTIsConnectedMessage? {
        let res = FLTIsConnectedMessage()
        res.isConnected = castManager.isConnected() ? 1 : 0
        
        return res
    }
    
    
    func connect(_ input: FLTConnectMessage, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        let device:GCKDevice? = castManager.getAvailableDevices().first { (device) -> Bool in
            return device.deviceID == input.deviceId
        }
        
        if device != nil {
            castManager.connectToDevice(device: device!)
        } else {
            error.pointee = FlutterError(code: "flutter_video_cast", message: "device not found", details: nil)
        }
    }
    
    func disconnect(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        castManager.disconnectFromCurrentDevice()
    }
    
    func loadMedia(_ input: FLTLoadMediaMessage, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        guard
            let url = input.url,
            let mediaUrl = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        let mediaInformation = castManager.buildMediaInformation(contentURL: mediaUrl, title: input.title ?? "", description: input.descr ?? "", studio: input.studio ?? "", duration: nil, streamType: GCKMediaStreamType.buffered, thumbnailUrl: input.thumbnailUrl, customData: nil)
        
        castManager.startSelectedItemRemotely(mediaInformation, at: TimeInterval.init(truncating: input.position ?? 0), autoplay: input.autoPlay?.boolValue ?? true) { (done) in
            if !done {
                error.respondWithSessionNotStartedError()
            }
        }
    }
    
    func play(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        castManager.playSelectedItemRemotely() { (done) in
            if !done {
                error.respondWithSessionNotStartedError()
            }
        }
    }
    
    func pause(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        castManager.pauseSelectedItemRemotely() { (done) in
            if !done {
                error.respondWithSessionNotStartedError()
            }
        }
    }
    
    func stop(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        castManager.stopSelectedItemRemotely() { (done) in
            if !done {
                error.respondWithSessionNotStartedError()
            }
        }
    }
    
    func seek(_ input: FLTSeekMessage, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        castManager.seekSelectedItemRemotely(at: TimeInterval.init(truncating: input.interval ?? 0), relative: input.relative?.boolValue ?? false) { (done) in
            if !done {
                error.respondWithSessionNotStartedError()
            }
        }
    }
    
    func isPlaying(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTIsPlayingMessage? {
        let state = castManager.getMediaPlayerState()
        
        let res = FLTIsPlayingMessage()
        res.isPlaying = state == .playing ? 1 : 0
        
        return res
    }
    
    func getPosition(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTPositionMessage? {
        let pos = castManager.getCurrentPlaybackTime()
        
        let res = FLTPositionMessage()
        res.position = pos as NSNumber? ?? 0.0
        
        return res
    }
    
    
    private func convertDevicesToJson(devices: [GCKDevice]) -> String? {
        var devicesData = [[String: String?]]()
        for device in devices {
            devicesData.append(["id": device.deviceID, "name": device.friendlyName])
        }
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(devicesData)
        
        return String(data: jsonData, encoding: String.Encoding.utf8)
    }
}

// MARK: - FlutterStreamHandler

extension ChromeCastController: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}


// MARK: - SessionStatusListener

extension ChromeCastController: SessionStatusListener {
    func onChange(status: CastSessionStatus) {
        switch status {
        case CastSessionStatus.started:
            eventSink?([
                "event": "didStartSession"
            ])
        case CastSessionStatus.ended:
            eventSink?([
                "event": "didEndSession"
            ])
        case CastSessionStatus.alreadyConnected:
            eventSink?([
                "event": "alreadyConnectedSession"
            ])
        case CastSessionStatus.failedToStart:
            eventSink?([
                "event": "failedToStartSession"
            ])
        case CastSessionStatus.resumed:
            eventSink?([
                "event": "resumedSession"
            ])
        case CastSessionStatus.connecting:
            eventSink?([
                "event": "connectingSession"
            ])
        }
    }
}

// MARK: - RequestResultListener

extension ChromeCastController: RequestResultListener {
    func onComplete() {
        eventSink?([
            "event": "requestDidComplete"
        ])
    }
    
    func onError(error: String) {
        eventSink?([
            "event": "requestDidFail",
            "error": error
        ])
    }
}

// MARK: - DeviceDiscoveryListener

extension ChromeCastController: DeviceDiscoveryListener {
    func onChange(devices: [GCKDevice]) {
        eventSink?([
            "event": "didUpdateDeviceList",
            "data": convertDevicesToJson(devices: devices)
        ])
    }
}


// MARK: - GCKMediaInformationListener

extension ChromeCastController: GCKMediaInformationListener {
    func onChange(client: GCKRemoteMediaClient, mediaInfo: GCKMediaInformation?) {
        let duration = mediaInfo?.streamDuration
        let position = client.approximateStreamPosition()
        
        eventSink?([
            "event": "didUpdatePlayback",
            "duration": duration as Any,
            "position": (position.isNaN ? nil : position) as Any,
            "state": (client.mediaStatus?.playerState.toString() ?? "unknown") as Any,
            "idleReason": (client.mediaStatus?.idleReason.toString() ?? "none") as Any
        ])
    }
}

// MARK: - error extension
extension AutoreleasingUnsafeMutablePointer {
    func respondWithSessionNotStartedError() {
        self.pointee = FlutterError(code: "flutter_video_cast", message: "session is not started", details: nil) as! Pointee
    }
}
