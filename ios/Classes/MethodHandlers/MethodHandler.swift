import Flutter

class MethodHandler: NSObject {
    private let connectionHelper: ConnectionHelper

    init(connectionHelper: ConnectionHelper) {
        self.connectionHelper = connectionHelper
    }

    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getDeviceInfo":
            result(DeviceInfoHelper().getDeviceInfo())
        case "isInternetConnected":
            connectionHelper.isInternetConnected { isConnected in
                DispatchQueue.main.async {
                    result(isConnected)
                }
            }
        case "isBluetoothEnabled":
            connectionHelper.isBluetoothEnabled { isEnabled in
                DispatchQueue.main.async {
                    result(isEnabled)
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
