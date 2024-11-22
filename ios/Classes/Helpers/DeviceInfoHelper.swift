//
//  DeviceInfoHelper.swift
//  Pods
//
//  Created by Duc Pham on 20/11/24.
//

import UIKit

class DeviceInfoHelper {
    func getDeviceInfo() -> [String: String] {
        return [
            "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? "Unknown",
            "deviceName": UIDevice.current.name,
            "deviceModel": UIDevice.current.model,
            "systemName": UIDevice.current.systemName,
            "systemVersion": UIDevice.current.systemVersion,
        ]
    }
}
