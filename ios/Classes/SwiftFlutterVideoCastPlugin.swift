import Flutter
import UIKit

public class SwiftFlutterVideoCastPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = AirPlayFactory(registrar: registrar)
        registrar.register(factory, withId: "AirPlayButton")
        
        let instance: FLTVideoCastApi = ChromeCastController(registrar: registrar)
        registrar.publish(instance as! NSObject)
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        FLTVideoCastApiSetup(messenger, instance)
    }
}
