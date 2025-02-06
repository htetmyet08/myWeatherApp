//
//  AirPollutionView.swift
//  WeatherApp
//
//  Created by htetmyet on 1/30/25.
//

import SwiftUI

struct AirPollutionView: View {
    let airPollution: AirPollutionResponse
    @EnvironmentObject var themeManager: ThemeManager
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                if let firstPollution = airPollution.list.first {
// AQI Banner
                    BannerView(title: "Air Quality Index", index: "\(firstPollution.main.aqi)", description: aqiDescription(for: firstPollution.main.aqi), customBackground: aqiGradient(for: firstPollution.main.aqi))
                    
// Pollutant Data Cards
                    VStack(spacing: 15) {
                        HStack {
                            PollutantCard(icon: "aqi.low", title: "PM2.5", value: "\(firstPollution.components.pm2_5) µg/m³")
                            PollutantCard(icon: "aqi.medium", title: "PM10", value: "\(firstPollution.components.pm10) µg/m³")
                        }
                        HStack {
                            PollutantCard(icon: "aqi.high", title: "CO", value: "\(firstPollution.components.co) µg/m³")
                            PollutantCard(icon: "leaf", title: "NO2", value: "\(firstPollution.components.no2) µg/m³")
                        }
                    }
                    .padding(.top, 5)
                    VStack(alignment: .leading) {
                        TextView(caption: "PM2.5 (Fine Particulate Matter, ≤2.5μm)", source: "Source: Vehicle emissions, industrial smoke, wildfires.", hazard: "Hazard: Penetrates lungs, enters bloodstream, causes heart and lung diseases.")
                        TextView(caption: "PM10 (Coarse Particulate Matter, ≤10μm)", source: "Source: Dust, pollen, construction debris.", hazard: "Hazard: Irritates respiratory system, worsens asthma and lung conditions.")
                        TextView(caption: "CO (Carbon Monoxide)", source: "Source: Vehicle exhaust, burning fuel, wood, or charcoal.", hazard: "Hazard: Reduces oxygen in blood, causes dizziness, headaches, and can be fatal in high exposure.")
                        TextView(caption: "NO₂ (Nitrogen Dioxide)", source: "Source: Vehicle emissions, power plants, burning fossil fuels.", hazard: "Hazard: Triggers asthma, lung inflammation, and contributes to smog.")
                    }
                    .font(.callout)
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                } else {
                    Text("No air pollution data available")
                        .foregroundColor(.gray)
                        .italic()
                }
            }
            .padding()
        }
    }
    
// AQI Gradient Background
    func aqiGradient(for aqi: Int) -> LinearGradient {
        let colors: [Color]
        
        switch aqi {
        case 1: colors = [Color.green.opacity(0.8), Color.blue.opacity(0.6)] // Good
        case 2: colors = [Color.yellow.opacity(0.8), Color.orange.opacity(0.6)] // Fair
        case 3: colors = [Color.orange.opacity(0.8), Color.red.opacity(0.6)] // Moderate
        case 4: colors = [Color.red.opacity(0.8), Color.purple.opacity(0.6)] // Poor
        case 5: colors = [Color.purple.opacity(0.8), Color.black.opacity(0.6)] // Hazardous
        default: colors = [Color.gray.opacity(0.5), Color.blue.opacity(0.5)]
        }
        
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    // AQI Description
    func aqiDescription(for aqi: Int) -> String {
        switch aqi {
        case 1: return "Good 😊 - Air quality is clean"
        case 2: return "Fair 🙂 - Acceptable air quality"
        case 3: return "Moderate 😐 - May affect sensitive people"
        case 4: return "Poor ⚠️ - Unhealthy for sensitive groups"
        case 5: return "Hazardous ☠️ - Serious health risks"
        default: return "Unknown"
        }
    }
    
    // Pollutant Card Component

}
#Preview {
    AirPollutionView(airPollution: previewAirPollution)
}



