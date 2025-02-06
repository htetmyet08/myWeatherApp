//
//  AirPollutionCompactView.swift
//  WeatherApp
//
//  Created by htetmyet on 2/1/25.
//
import SwiftUI

struct AirPollutionCompactView: View {
    let airPollution: AirPollutionResponse

    var body: some View {
        HStack(spacing: 60){
            VStack(alignment: .leading) {
                if let firstPollution = airPollution.list.first {
                    Text("AQI: \(firstPollution.main.aqi)")
                        .font(.headline)
                        .padding(.bottom, 5)

                    Text(aqiDescription(for: firstPollution.main.aqi))
                        .font(.subheadline)
                        .foregroundColor(.white)

                    Text("tap for more details")
                        .font(.caption)
                }
            }
            if let firstPollution = airPollution.list.first {
                Image(aqiPhoto(for: firstPollution.main.aqi))
                    .resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(aqiGradient(for: airPollution.list.first?.main.aqi ?? 1)))
    }
    func aqiPhoto(for aqi: Int) -> String {
        switch aqi {
        case 1: return "1"
        case 2: return "2"
        case 3: return "3"
        case 4: return "4"
        case 5: return "5"
        default: return "unknown"
        }
    }
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
    func aqiDescription(for aqi: Int) -> String {
        switch aqi {
        case 1: return "Good air quality 😊"
        case 2: return "Fair air quality 🙂"
        case 3: return "Moderate air quality 😐"
        case 4: return "Poor air quality ⚠️"
        case 5: return "Hazardous air quality ☠️"
        default: return "Unknown AQI ❓"
        }
    }
}
#Preview {
    AirPollutionCompactView(airPollution: previewAirPollution)
}
