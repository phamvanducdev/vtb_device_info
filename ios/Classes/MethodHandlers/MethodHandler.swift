//
//  MethodHandler.swift
//  Pods
//
//  Created by Duc Pham on 20/11/24.
//

import Flutter

class MethodHandler: NSObject {
    private let deviceInfoHelper: DeviceInfoHelper
    private let connectionHelper: ConnectionHelper
    private let permissionHelper: PermissionHelper
    private let locationHelper: LocationHelper
    
    init(deviceInfoHelper: DeviceInfoHelper,
         connectionHelper: ConnectionHelper,
         permissionHelper: PermissionHelper,
         locationHelper: LocationHelper
    ) {
        self.deviceInfoHelper = deviceInfoHelper
        self.connectionHelper = connectionHelper
        self.permissionHelper = permissionHelper
        self.locationHelper = locationHelper
    }
    
    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getDeviceInfo":
            result(deviceInfoHelper.getDeviceInfo())
        case "checkInternetConnected":
            connectionHelper.isInternetConnected { isConnected in
                DispatchQueue.main.async {
                    result(isConnected)
                }
            }
        case "checkBluetoothEnabled":
            connectionHelper.isBluetoothEnabled { isEnabled in
                DispatchQueue.main.async {
                    result(isEnabled)
                }
            }
        case "getCurrentLocation":
            locationHelper.getCurrentLocation{ location in
                DispatchQueue.main.async {
                    if let location = location {
                        result([
                            "latitude": location.coordinate.latitude,
                            "longitude": location.coordinate.longitude
                        ])
                    } else {
                        result(nil)
                    }
                }
            }
        case "checkLocationPermissionGranted":
            result(permissionHelper.isLocationPermissionGranted())
        case "requestLocationPermission":
            permissionHelper.requestLocationPermission { isGranted in
                DispatchQueue.main.async {
                    result(isGranted)
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
