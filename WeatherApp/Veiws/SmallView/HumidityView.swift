//
//  HumidityView.swift
//  WeatherApp
//
//  Created by htetmyet on 2/1/25.
//

import SwiftUI

struct HumidityView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var weather: ResponseBody
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                BannerView(title: "Humidity", index: String(format: "%.0f%%", weather.main.humidity), description: humidityDescription(for: weather.main.humidity), customBackground: humidityGradient(for: weather.main.humidity))
            }
            .padding(.vertical, 20)
            VStack(alignment: .leading) {
                Text(humidityPersonalised(for: weather.main.humidity))
            }
            .font(.callout)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.horizontal, 20)
            .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    HumidityView(weather: previewWeather)
}
func humidityDescription(for humidity: Double) -> String {
    switch humidity {
    case 0..<30:
        return "dry air, use moisturizer"
    case 30..<55:
        return "comfortable to live"
    case 55..<80:
        return "a bit humid, increased risk of mold"
    case 80...100:
        return "high humidity, ventilate properly"
    default:
        return "Unknown"
    }
}
func humidityGradient(for humidity: Double) -> LinearGradient {
    let colors: [Color]
    switch humidity {
    case 0..<30:
        colors = [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]
    case 30..<55:
        colors = [Color.green.opacity(0.8), Color.teal.opacity(0.6)]
    case 55..<80:
        colors = [Color.orange.opacity(0.8), Color.yellow.opacity(0.6)]
    case 80...100:
        colors = [Color.red.opacity(0.8), Color.purple.opacity(0.6)]
    default:
        colors = [Color.gray.opacity(0.5), Color.blue.opacity(0.5)]
    }

    return LinearGradient(
        gradient: Gradient(colors: colors),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
func humidityPersonalised(for humidity: Double) -> String {
    switch humidity {
    case 0..<30:
        return "The air is dry, which can cause skin irritation and respiratory discomfort.Stay hydrated by drinking plenty of water."
    case 30..<55:
        return "The humidity level is comfortable for most people. Your home feels fresh, and the risk of mold growth is minimal."
    case 55..<80:
        return "This humidity level can make the air feel sticky. Watch out for mold growth in damp areas. Ventilating your space regularly."
    case 80...100:
        return "High humidity can lead to discomfort and potential health risks. Use dehumidifier or air conditioner"
    default:
        return "Unknown humidity level detected. Please check your hygrometer for accurate readings."
    }
}
