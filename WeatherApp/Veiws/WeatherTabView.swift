//
//  TabView.swift
//  WeatherApp
//
//  Created by htetmyet on 1/23/25.
//

import SwiftUI

struct WeatherTabView: View {
    @StateObject var viewModel = WeatherViewModel()
    @AppStorage("selectedUnit") private var isImperial = false

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
// Weather Tab
            if viewModel.selectedWeather != nil {
                WeatherView()
                    .environmentObject(viewModel)
                    .tabItem {
                        Label("Weather", systemImage: "sun.max")
                    }
                    .tag(1)
            } else {
                Text("No weather selected. Search for a city.")
                    .foregroundColor(.gray)
                    .tabItem {
                        Label("Weather", systemImage: "sun.max")
                    }
                    .tag(1)
            }
            
            // Search City Tab
            SearchCityView()
                .tabItem {
                    Label("Search City", systemImage: "magnifyingglass")
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .environmentObject(viewModel)
        .accentColor(.blue)
        .onAppear { viewModel.loadLastSelectedWeather() }
        .onChange(of: viewModel.isImperial) { oldValue, newValue in viewModel.loadLastSelectedWeatherUnit() }
    }

}

#Preview {
    WeatherTabView()
        .environmentObject(WeatherViewModel())
        .environmentObject(ThemeManager())
}
