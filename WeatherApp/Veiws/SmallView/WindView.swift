//
//  WindView.swift
//  WeatherApp
//
//  Created by htetmyet on 2/5/25.
//

import SwiftUI

struct WindView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var viewModel: WeatherViewModel
    var weather: ResponseBody
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                BannerView(title: "Wind Speed", index: viewModel.convertWindSpeed(weather.wind.speed), description: viewModel.windGustDescription(for: weather.wind.gust), customBackground: viewModel.windGustGradient(for: weather.wind.speed))
            }
            .padding(.vertical, 20)
            VStack(alignment: .leading) {
                Text(windGustPersonalised(for: weather.wind.gust))
                    
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
    WindView(weather: previewWeather)
        .environmentObject(ThemeManager())
        .environmentObject(WeatherViewModel())
}

func windGustPersonalised(for gustSpeed: Double?) -> String {
    guard let gust = gustSpeed else { return "No strong gusts detected. The air is still and calm. Enjoy your day without any wind-related worries." }
    
    switch gust {
    case 0..<10:
        return "Calm wind, no problem at all. The breeze is light and barely noticeable. Perfect conditions for outdoor activities."
    case 10..<25:
        return "Breezy conditions, enjoy the nature. Leaves rustle gently, creating a soothing atmosphere. It’s a great time for a walk or picnic."
    case 25..<40:
        return "Strong gusts, secure loose items! You might feel resistance while walking against the wind. Be cautious with lightweight objects that could get blown away."
    case 40..<60:
        return "Very strong winds, exercise caution! Branches may sway aggressively, and walking could become challenging. If driving, keep a firm grip on the wheel."
    case 60...:
        return "Extreme gusts, stay indoors! The wind is powerful enough to cause damage and flying debris is a risk. It’s best to stay safe inside until conditions improve."
    default:
        return "No gust detected. The atmosphere is still, with no noticeable wind movement. Enjoy a peaceful and quiet environment."
    }
}
