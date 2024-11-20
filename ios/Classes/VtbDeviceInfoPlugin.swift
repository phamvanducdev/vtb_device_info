import CoreBluetooth
import Flutter
import Network
import UIKit

public class VtbDeviceInfoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "vtb_device_info", binaryMessenger: registrar.messenger())
    let instance = VtbDeviceInfoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getDeviceInfo":
      let device = UIDevice.current
      let deviceInfo: [String: String] = [
          "deviceId": device.identifierForVendor?.uuidString ?? "Unknown",
          "deviceName": device.name,
          "deviceModel": device.model,
          "systemName": device.systemName,
          "systemVersion": device.systemVersion,
        ]
      result(deviceInfo)
    case "isInternetConnected":
      result(isInternetConnected())
    case "isBluetoothEnabled":
      result(isBluetoothEnabled())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func isInternetConnected() -> Bool {
    let monitor = NWPathMonitor()
    var isConnected = false
    let queue = DispatchQueue(label: "InternetMonitor")
    monitor.pathUpdateHandler = { 
      path in isConnected = path.status == .satisfied
    }
    monitor.start(queue: queue)
    return isConnected
  }

  private func isBluetoothEnabled() -> Bool {
    let bluetoothManager = CBCentralManager()
    return bluetoothManager.state == .poweredOn
  }
}
