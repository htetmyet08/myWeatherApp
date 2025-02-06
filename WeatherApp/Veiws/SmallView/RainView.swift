//
//  CloudView.swift
//  WeatherApp
//
//  Created by htetmyet on 2/3/25.
//

import SwiftUI

struct RainView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var weather: ResponseBody
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                BannerView(title: "Cloudiness", index: String(format: "%d%%",weather.clouds.all), description: rainDescription(for: weather.rain?.oneHour), customBackground: rainGradient(for: weather.rain?.oneHour))
                    .padding(.vertical, 20)
                    .padding(.top, 20)
                VStack(alignment: .leading) {
                    Text(rainPersonalised(for: weather.rain?.oneHour))
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
}

#Preview {
    RainView( weather: previewWeather)
}

func rainGradient(for rainAmount: Double?) -> LinearGradient {
    let colors: [Color]

    guard let rain = rainAmount else {
        colors = [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    switch rain {
    case 0..<0.5:
        colors = [Color.cyan.opacity(0.8), Color.blue.opacity(0.6)]
    case 0.5..<2:
        colors = [Color.purple.opacity(0.8), Color.blue.opacity(0.6)]
    case 2...:
        colors = [Color.red.opacity(0.8), Color.purple.opacity(0.6)]
    default:
        colors = [Color.gray.opacity(0.8), Color.blue.opacity(0.6)]
    }

    return LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
}
func rainDescription(for rainAmount: Double?) -> String {
    guard let rain = rainAmount else { return "no rain" }
    
    switch rain {
    case 0..<0.5:
        return "light rain may occur"
    case 0.5..<2:
        return "moderate rain may occur"
    case 2...:
        return "heavy rain may occur, bring out your umbrella"
    default:
        return "no rain"
    }
}

func rainPersonalised(for rainAmount: Double?) -> String {
    guard let rain = rainAmount else { return "No rain expected. Enjoy your day without worrying about getting wet." }
    
    switch rain {
    case 0..<0.5:
        return "Light rain may occur, but it shouldn’t cause much disruption. Carrying an umbrella might be a good idea."
    case 0.5..<2:
        return "Moderate rain is possible, making roads slightly slippery. Consider bringing an umbrella."
    case 2...:
        return "Heavy rain is expected, which may lead to puddles and reduced visibility. Avoid unnecessary outdoor activities."
    default:
        return "No rain in the forecast. It’s a great opportunity for outdoor plans."
    }
}
