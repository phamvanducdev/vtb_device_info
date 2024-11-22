//
//  LocationEventHandler.swift
//  Pods
//
//  Created by Duc Pham on 22/11/24.
//

import Flutter
import CoreLocation

class LocationEventHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let permissionHelper: PermissionHelper
    private var eventSink: FlutterEventSink?
    
    
    init(permissionHelper: PermissionHelper) {
        self.permissionHelper = permissionHelper
        super.init()
        locationManager.delegate = self
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        permissionHelper.isLocationServiceEnabled { isEnabled in
            if (isEnabled) {
                if (self.permissionHelper.isLocationPermissionGranted()) {
                    self.locationManager.startUpdatingLocation()
                } else {
                    self.eventSink?(
                        FlutterError(
                            code: "LOCATION_ERROR",
                            message: "Location permission not granted",
                            details: nil
                        )
                    )
                }
            } else {
                self.eventSink?(
                    FlutterError(
                        code: "LOCATION_ERROR",
                        message: "Location services are disabled",
                        details: nil
                    )
                )
            }
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        locationManager.stopUpdatingLocation()
        return nil
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]
        eventSink?(locationData)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
        eventSink?(
            FlutterError(
                code: "LOCATION_ERROR",
                message: error.localizedDescription,
                details: nil
            )
        )
    }
}
