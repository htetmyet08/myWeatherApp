//
//  SettingsView.swift
//  WeatherApp
//
//  Created by htetmyet on 1/26/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedUnit") private var isImperial = false
    @EnvironmentObject var themeManager: ThemeManager
    @State var notiOn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
// Full-screen background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.cyan.opacity(0.8),
                        Color.orange.opacity(0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    Form {
                        Section(header: Text("Measurement")) {
                            Picker("Units", selection: Binding(
                                get: { isImperial ? "imperial" : "metric" },
                                set: { isImperial = ($0 == "imperial") }
                            )) {
                                HStack {
                                    Text("Metric")
                                        .font(.headline)
                                    Text("°C, km/h, mm")
                                        .font(.caption)
                                }
                                .tag("metric")
                                
                                HStack {
                                    Text("Imperial")
                                        .font(.headline)
                                    Text("°F, mph, in")
                                        .font(.caption)
                                }
                                .tag("imperial")
                            }
                        }
                        
                        Section(header: Text("Theme")) {
                            Picker("Display Theme", selection: $themeManager.selectedTheme) {
                                Text("Light").tag("Light")
                                Text("Dark").tag("Dark")
                                Text("Auto").tag("Auto")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
//                        Section(header: Text("Notification")) {
//                            HStack {
//                                Text("Allow Notification")
//                                Toggle("", isOn: $notiOn)
//                            }
//                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .navigationTitle("Settings")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}


#Preview {
    SettingsView()
        .environmentObject(ThemeManager())

}
