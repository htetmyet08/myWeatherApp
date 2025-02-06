//
//  TemperatureView.swift
//  WeatherApp
//
//  Created by htetmyet on 2/5/25.
//

import SwiftUI

struct TemperatureView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var viewModel: WeatherViewModel
    var weather: ResponseBody
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                BannerView(title: "Temperature", index: viewModel.convertTemperature(weather.main.feels_like), description:"L: \(viewModel.convertTemperature(weather.main.temp_min))    H:\(viewModel.convertTemperature(weather.main.temp_max))", customBackground: viewModel.temperatureGradient(for: weather.main.feels_like))
            }
            .padding(.vertical, 20)
            VStack(alignment: .leading) {
                Text(temperaturePersonalised(for: weather.main.feels_like))
                    
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
    TemperatureView(weather: previewWeather)
        .environmentObject(ThemeManager())
        .environmentObject(WeatherViewModel())
}
func temperaturePersonalised(for temp: Double) -> String {
    switch temp {
    case ..<0:
        return "Extreme cold can lead to frostbite and hypothermia. Cover exposed skin, and limit outdoor exposure."
    case 0..<10:
        return "Cold weather can cause dry skin and respiratory discomfort. Consider using a humidifier to prevent dryness indoors."
    case 10..<20:
        return "Cool temperatures are generally comfortable but can feel chilly at times. Staying active will help maintain body heat."
    case 20..<30:
        return "This is a comfortable temperature range for most people. Stay hydrated and sunscreen are recommended for sunny days."
    case 30..<40:
        return "Hot weather can cause dehydration and heat exhaustion. Take breaks in the shade or indoors if needed."
    case 40...:
        return "Extreme heat poses serious health risks like heatstroke. Avoid outdoor activities during peak hours."
    default:
        return "Temperature level is unusual or unknown. Monitor your body's response to the weather and adjust accordingly."
    }
}
