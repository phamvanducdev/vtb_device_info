//
//  PermisstionHelper.swift
//  Pods
//
//  Created by Duc Pham on 22/11/24.
//

import CoreLocation

class PermissionHelper: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var permissionCompletion: ((Bool) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func isLocationPermissionGranted() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    func isLocationPermissionDenied() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .denied || status == .restricted
    }
    
    func isLocationServiceEnabled(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let locationServicesEnabled = CLLocationManager.locationServicesEnabled()
            DispatchQueue.main.async {
                completion(locationServicesEnabled)
            }
        }
    }
    
    func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        if isLocationPermissionGranted() {
            completion(true)
            return
        }
        if isLocationPermissionDenied() {
            promptUserToOpenSettings()
            return
        }
        permissionCompletion = completion
        locationManager.requestWhenInUseAuthorization()
    }
    
    func promptUserToOpenSettings() {
        let alertController = UIAlertController(
            title: "Location Access Denied",
            message: "This app requires access to your device's location. Please enable location access for this app in Settings.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Open Setting", style: .default) { _ in
            if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingsURL)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertController, animated: true)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location permission changed: \(status.rawValue)")
        let isGranted = status == .authorizedAlways || status == .authorizedWhenInUse
        permissionCompletion?(isGranted)
        // If permission is denied, show notification open settings
        if status == .denied || status == .restricted {
            promptUserToOpenSettings()
        }
        permissionCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to handle permission: \(error.localizedDescription)")
    }
}
