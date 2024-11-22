//
//  LocationHelper.swift
//  Pods
//
//  Created by Duc Pham on 22/11/24.
//

import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((CLLocation?) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        locationCompletion = completion
        locationManager.requestLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location changed: \(locations)")
        locationCompletion?(locations.last)
        locationCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
        locationCompletion?(nil)
        locationCompletion = nil
    }
}
