//
//  Extension.swift
//  WeatherApp
//
//  Created by htetmyet on 1/17/25.
//

import Foundation
import CoreLocation

extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}
extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
