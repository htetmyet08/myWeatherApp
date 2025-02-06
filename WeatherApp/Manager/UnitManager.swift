//
//  UnitManager.swift
//  WeatherApp
//
//  Created by htetmyet on 1/29/25.
//

import Foundation

class UnitManager {
    func toFahrenheit(_ celsius: Double) -> String {
        let fahrenheit = (celsius * 9.0 / 5.0) + 32.0
        return String(format: "%.1f", fahrenheit)
    }
    
    func toMilesPerHour(_ metersPerSecond: Double) -> String {
        let mph = metersPerSecond * 2.23694
        return String(format: "%.1f", mph)
    }
    
    func toMiles(_ meters: Double) -> String {
        let miles = meters / 1609.34
        return String(format: "%.1f", miles)
    }
}
