//
//  ThemeManager.swift
//  WeatherApp
//
//  Created by htetmyet on 2/1/25.
//

import SwiftUI
class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") var selectedTheme: String = "Light" {
        didSet { applyTheme()}
    }
    @Published var colorScheme: ColorScheme? = nil
    init () {
        applyTheme()
    }
    private func applyTheme() {
        switch selectedTheme {
        case "Light":
            colorScheme = .light
        case "Dark":
            colorScheme = .dark
        default:
            colorScheme = nil
        }
    }
}
