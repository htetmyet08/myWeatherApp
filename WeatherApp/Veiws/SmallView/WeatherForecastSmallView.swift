//
//  testUI.swift
//  WeatherApp
//
//  Created by htetmyet on 2/2/25.
//
import SwiftUI
import Kingfisher

struct WeatherForecastSmallView: View {
    let forecast: ForecastResponse
    @AppStorage("selectedUnit") private var isImperial = false
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        VStack(alignment: .leading) {
            Text("3 Hourly Forecast")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading, 15)
                .padding(.top, 20)
                .foregroundStyle(.white)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(forecast.list.prefix(8), id: \.dt) { forecastItem in
                        HourlyForecastCard(isImperial: isImperial, forecast: forecastItem)
                    }
                }
            }
            .padding(.top, -20)
        }
    }
}

struct HourlyForecastCard: View {
    let isImperial: Bool
    private let unitManager = UnitManager()
    let forecast: Forecast

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 8) {
                VStack{
                    Text(formatDateTime(forecast.dt_txt))
                        .font(.subheadline)
                        .foregroundColor(.white)

                    if let icon = forecast.weather.first?.icon {
                        let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                        KFImage(imageUrl)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                    }

                    Text("\(convertTemperature(forecast.main.temp, isImperial: isImperial))")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            
        }
    private func convertTemperature(_ temp: Double, isImperial: Bool) -> String {
        return isImperial ? "\(unitManager.toFahrenheit(temp))°F" : "\(temp.roundDouble())°C"
    }
    }
    

func formatDateTime(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.timeZone = TimeZone(abbreviation: "UTC")

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MMM d, h a"
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    outputFormatter.timeZone = TimeZone.current
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    } else {
        print("Failed to parse date: \(dateString)")
        return "Invalid Date"
    }
}

#Preview {
    WeatherForecastSmallView(forecast: previewForecast)
        .environmentObject(ThemeManager())
}
