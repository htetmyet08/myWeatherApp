//
//  LocationManager.swift
//  WeatherApp
//
//  Created by htetmyet on 1/17/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        let authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            isLoading = true
            manager.requestLocation()
        case .denied, .restricted:
            print("❌ Location access denied or restricted")
        @unknown default:
            break
        }
    }

    // ✅ This will be called when location is retrieved
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async {
            self.location = location.coordinate
            self.isLoading = false
            print("📍 Location updated: \(location.coordinate)")
        }
    }

    // ✅ Handle errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Error getting location: \(error.localizedDescription)")
        isLoading = false
    }
}
