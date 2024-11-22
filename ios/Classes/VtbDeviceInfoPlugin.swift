//
//  VtbDeviceInfoPlugin.swift
//  Pods
//
//  Created by Duc Pham on 18/11/24.
//

import Flutter
import UIKit

public class VtbDeviceInfoPlugin: NSObject, FlutterPlugin {
    private var methodChannel: FlutterMethodChannel!
    private var internetEventChannel: FlutterEventChannel!
    private var bluetoothEventChannel: FlutterEventChannel!
    private var locationEventChannel: FlutterEventChannel!
    
    private let deviceInfoHelper = DeviceInfoHelper()
    private let connectionHelper = ConnectionHelper()
    private let permissionHelper = PermissionHelper()
    private let locationHelper = LocationHelper()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance: VtbDeviceInfoPlugin = VtbDeviceInfoPlugin()
        
        /// DEVICE_INFO
        instance.methodChannel = FlutterMethodChannel(
            name: "vtb_device_info",
            binaryMessenger: registrar.messenger()
        )
        
        instance.methodChannel.setMethodCallHandler { (call, result) in
            MethodHandler(
                deviceInfoHelper: instance.deviceInfoHelper,
                connectionHelper: instance.connectionHelper,
                permissionHelper: instance.permissionHelper,
                locationHelper: instance.locationHelper
            ).handle(call: call, result: result)
        }
        
        /// INTERNET
        instance.internetEventChannel = FlutterEventChannel(
            name: "vtb_device_info/internet",
            binaryMessenger: registrar.messenger()
        )
        instance.internetEventChannel.setStreamHandler(
            InternetEventHandler(connectionHelper: instance.connectionHelper))
        
        /// BLUETOOTH
        instance.bluetoothEventChannel = FlutterEventChannel(
            name: "vtb_device_info/bluetooth",
            binaryMessenger: registrar.messenger()
        )
        instance.bluetoothEventChannel.setStreamHandler(
            BluetoothEventHandler(connectionHelper: instance.connectionHelper))
        
        /// LOCATION
        instance.locationEventChannel = FlutterEventChannel(
            name: "vtb_device_info/location",
            binaryMessenger: registrar.messenger()
        )
        instance.locationEventChannel.setStreamHandler(
            LocationEventHandler(permissionHelper: instance.permissionHelper))
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        methodChannel.setMethodCallHandler(nil)
        internetEventChannel.setStreamHandler(nil)
        bluetoothEventChannel.setStreamHandler(nil)
        locationEventChannel.setStreamHandler(nil)
    }
}
