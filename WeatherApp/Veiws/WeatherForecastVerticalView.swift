//
//  WeatherForecastView.swift
//  WeatherApp
//
//  Created by htetmyet on 2/1/25.
//

import SwiftUI

struct WeatherForecastVerticalView: View {
    let forecast : ForecastResponse
    var body: some View {
                VStack(alignment: .leading, spacing: 10) {
                    // City Name & Header
                    Text("\(forecast.city.name), \(forecast.city.country)")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("5-Day Forecast")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Divider()
                    
                    // Scrollable Forecast List
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(forecast.list, id: \.dt) { forecastItem in
                                ForecastRowView(forecast: forecastItem)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
        }

        // Forecast Row View
        struct ForecastRowView: View {
            let forecast: Forecast
            
            var body: some View {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(forecast.dt_txt)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("\(forecast.weather.first?.description.capitalized ?? "No Data")")
                            .font(.headline)

                        Text("Temperature: \(String(format: "%.1f", forecast.main.temp))°C")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        
                        Text("Humidity: \(forecast.main.humidity)%")
                            .font(.subheadline)
                        
                        Text("Wind: \(String(format: "%.1f", forecast.wind.speed)) km/h")
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    // Weather Icon
                    if let icon = forecast.weather.first?.icon {
                        let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                        AsyncImage(url: imageUrl) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
            }
    }

#Preview {
    WeatherForecastVerticalView(forecast: previewForecast)
}
