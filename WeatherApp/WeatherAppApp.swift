//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by htetmyet on 1/17/25.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @AppStorage("onBoardingFinished") private var onBoardingFinished: Bool = false
    @StateObject private var themeManager = ThemeManager()
    
    
    var body: some Scene {
        WindowGroup {
            if onBoardingFinished {
                WeatherTabView()
                    .environmentObject(themeManager)
                    .preferredColorScheme(themeManager.colorScheme)
            } else {
                OnBoardingView()
            }

        }
    }
}
