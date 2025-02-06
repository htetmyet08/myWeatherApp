//
//  WeatherForecastLargeView.swift
//  WeatherApp
//
//  Created by htetmyet on 2/3/25.
//

import SwiftUI
import Kingfisher

struct WeatherForecastLargeView: View {
    let forecast: ForecastResponse
    @AppStorage("selectedUnit") private var isImperial = false
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                    gradient: Gradient(colors:
                                    [Color.blue.opacity(0.8),
                                        Color.orange.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        HStack{
                            Image(systemName: "arrow.left.circle")
                            Text("Back")
                                .buttonStyle(PlainButtonStyle())
                        }
                        .foregroundStyle(.white)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                VStack{
                    Text("3 hourly forecast for 5 days")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                        .foregroundStyle(.white)
                    Text("\(forecast.city.name), \(forecast.city.country)")
                        .font(.headline)
                        .foregroundStyle(.white)

                }
// View start here//
                VStack(alignment: .leading) {
                            List(forecast.list, id: \.dt) { forecastItem in
                                DailyForecastRow(isImperial: isImperial, forecast: forecastItem)
                                    .listRowBackground(Color.clear)
                            }
                            .scrollContentBackground(.hidden)
                        }
                .padding(.top, -5)
                Spacer()
            }

        }
    }
}

struct DailyForecastRow: View {
    let isImperial: Bool
    private let unitManager = UnitManager()
    let forecast: Forecast

    var body: some View {
        HStack {
//  Date
            Text(formatDateTime(forecast.dt_txt))
                .font(.subheadline)
                .foregroundColor(.white)
                .minimumScaleFactor(0.6)
                .frame(width: 120, alignment: .leading)
            Spacer()

            if let icon = forecast.weather.first?.icon {
                let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                KFImage(imageUrl)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }

            Spacer()
            VStack(alignment: .trailing) {
                Text("L: \(convertTemperature(forecast.main.temp_min, isImperial: isImperial))")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Text("H: \(convertTemperature(forecast.main.temp_max, isImperial: isImperial))")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
    }
}

private func convertTemperature(_ temp: Double, isImperial: Bool) -> String {
    return isImperial ? "\(UnitManager().toFahrenheit(temp))°F" : "\(temp.roundDouble())°C"
}


#Preview {
    WeatherForecastLargeView(forecast: previewForecast)
        .environmentObject(ThemeManager())
}
