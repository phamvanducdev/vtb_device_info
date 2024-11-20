import Flutter
import UIKit

public class VtbDeviceInfoPlugin: NSObject, FlutterPlugin {
    private var methodChannel: FlutterMethodChannel!
    private var internetEventChannel: FlutterEventChannel!
    private var bluetoothEventChannel: FlutterEventChannel!
    
    private let connectionHelper = ConnectionHelper()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance: VtbDeviceInfoPlugin = VtbDeviceInfoPlugin()
        
        instance.methodChannel = FlutterMethodChannel(
            name: "vtb_device_info",
            binaryMessenger: registrar.messenger()
        )
        
        instance.methodChannel.setMethodCallHandler { (call, result) in
            MethodHandler(connectionHelper: instance.connectionHelper).handle(
                call: call, result: result)
        }
        
        instance.internetEventChannel = FlutterEventChannel(
            name: "vtb_device_info/internet_status",
            binaryMessenger: registrar.messenger()
        )
        instance.internetEventChannel.setStreamHandler(
            InternetEventHandler(connectionHelper: instance.connectionHelper))
        
        instance.bluetoothEventChannel = FlutterEventChannel(
            name: "vtb_device_info/bluetooth_status",
            binaryMessenger: registrar.messenger()
        )
        instance.bluetoothEventChannel.setStreamHandler(
            BluetoothEventHandler(connectionHelper: instance.connectionHelper))
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        methodChannel.setMethodCallHandler(nil)
        internetEventChannel.setStreamHandler(nil)
        bluetoothEventChannel.setStreamHandler(nil)
    }
}
