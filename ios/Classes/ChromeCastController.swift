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
    var devices = [GCKDevice](){
        didSet{
            print("did set device")
        }
    }
    
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
    }
    
    func discoverDevices(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTDevicesMessage? {
        let devices = castManager.getAvailableDevices()
        //        NSLog("devices: %i", devices.count)
        
        let res = FLTDevicesMessage()
        
        var devicesData = [[String: String?]]()
        for device in devices {
            devicesData.append(["id": device.deviceID, "name": device.friendlyName])
        }
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(devicesData)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
        res.devicesData = json
        //        NSLog("json: %@", NSString(string: json!))
        
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
        
        let mediaInformation = castManager.buildMediaInformation(contentURL: mediaUrl, title: input.title ?? "", description: input.description ?? "", studio: input.studio ?? "", duration: nil, streamType: GCKMediaStreamType.buffered, thumbnailUrl: input.thumbnailUrl, customData: nil)
        
        castManager.startSelectedItemRemotely(mediaInformation, at: TimeInterval.init(truncating: input.position ?? 0), completion: { (done) in
            if !done {
                error.pointee = FlutterError(code: "flutter_video_cast", message: "session is not started", details: nil)
            }
        })
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
