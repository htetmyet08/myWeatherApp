//
//  WeatherView.swift
//  WeatherApp
//
//  Created by htetmyet on 1/17/25.
//
import SwiftUI
import Kingfisher

struct WeatherView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    let screenWidth = UIScreen.main.bounds.width
    
    @AppStorage("selectedUnit") private var isImperial = false
    
    @State private var showFullAirPollution = false
    @State private var showHumidityView = false
    @State private var showRainView = false
    @State private var showFullForecast = false
    @State private var showWindView = false
    @State private var showTemperatureView = false

    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 5) {
                    VStack{
                        if let weather = viewModel.selectedWeather {
                            Text(weather.name)
                                .bold()
                                .font(.title2)
                        } else {
                            Text("No City Selected")
                        }
                            
                        Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .fontWeight(.light)

// Temperature Row & Weather Icon
                        HStack {
                            HStack {
                                if let weather = viewModel.selectedWeather {
                                    Text(viewModel.convertTemperature(weather.main.temp))
                                        .font(.system(size: 100, weight: .bold))
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                        .padding(.leading, 25)
                                        .frame(width: screenWidth * 0.5, height: 130)
                                } else {
                                    Text("No Weather Data")
                                }
                            }
                            Spacer()
                            VStack {
                                if let weather = viewModel.selectedWeather, let icon = weather.weather.first?.icon {
                                    let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")

                                    KFImage(imageUrl)
                                        .placeholder {
                                            ProgressView()
                                        }
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: screenWidth * 0.25, height: screenWidth * 0.25)
                                        .shadow(color: Color.gray, radius: 2)
                                        .padding(.trailing, 20)
                                } else {
                                    Text("No icon available")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.vertical, 20)
//Summery//
                        VStack(alignment: .leading) {
                            Text("Today Summary")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.vertical, 8)

                            if let weatherData = viewModel.selectedWeather, let firstWeather = weatherData.weather.first {
                                Text("\(firstWeather.description.capitalized).")
                                    .multilineTextAlignment(.leading)
                                    .font(.subheadline)
                            } else {
                                Text("No Weather Data").italic()
                            }
                            if let weather = viewModel.selectedWeather {
                                Text("\(viewModel.visibilityRecommendation(for: weather.visibility)) \(viewModel.humidityRecommendation(for: weather.main.humidity))")
                                    .font(.subheadline)
                            } else {
                                Text("No weather data available")
                                    .font(.subheadline)
                            }
                            
                                
                        }
                        .padding(.horizontal,15)
                    }
//WeatherDetailRow//
//RectangleStartHere//
                    VStack{
                        if let pollution = viewModel.airPollution, !pollution.list.isEmpty {
                                        AirPollutionCompactView(airPollution: pollution)
                                            .onTapGesture {
                                                showFullAirPollution = true
                                            }
                                    } else {
                                        Text("No air pollution data available")
                                            .foregroundColor(.gray)
                                            .italic()
                                    }
                        HStack{
                            if let weather = viewModel.selectedWeather {
                            RectangleView(
                                caption: "humidity",
                                text1: "\(weather.main.humidity.roundDouble())%",
                                text2: viewModel.humidityDescription(for: viewModel.selectedWeather?.main.humidity ?? 0),
                                customColor: humidityGradient(for: viewModel.selectedWeather?.main.humidity ?? 0)
                            )
                            .onTapGesture {
                                showHumidityView = true
                            }
                                RectangleView(
                                    caption: "cloud",
                                    text1: "\(weather.clouds.all)%",
                                    text2: "\(rainDescription(for: weather.rain?.oneHour))",
                                    customColor: rainGradient(for: weather.rain?.oneHour)
                                    
                                )
                                .onTapGesture {
                                    showRainView = true
                                }
                            }
  
                        }
                        HStack {
                            if let weather = viewModel.selectedWeather {
                                RectangleView(
                                    caption: "wind",
                                    text1: viewModel.convertWindSpeed(weather.wind.speed),
                                    text2: viewModel.windGustDescription(for: weather.wind.gust ?? 0.0),
                                    customColor: viewModel.windGustGradient(for: weather.wind.gust ?? 0.0)
                                )
                                .onTapGesture {
                                    showWindView = true
                                }
                                
                                RectangleView(
                                    caption: "thermometer.variable",
                                    text1: "",
                                    text2: "L: \(viewModel.convertTemperature(weather.main.temp_min))  H: \(viewModel.convertTemperature(weather.main.temp_max))",
                                    customColor: viewModel.temperatureGradient(for: weather.main.temp_max)
                                )
                                .onTapGesture {
                                    showTemperatureView = true
                                }
                            }
                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors:
                                                    [Color.blue.opacity(0.8),
                                                        Color.orange.opacity(0.6)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                            VStack{
                                if let forecast = viewModel.weatherForecast, !forecast.list.isEmpty {
                                    WeatherForecastSmallView(forecast: forecast)
                                        .onTapGesture {
                                            showFullForecast = true
                                        }
                                } else {
                                    Text("Loading Forecast...")
                                        .foregroundColor(.gray)
                                }
                            }
                        
                        }
                    }
                    .padding()
                    .sheet(isPresented: $showFullAirPollution) {
                        if let pollution = viewModel.airPollution {
                            AirPollutionView(airPollution: pollution)
                                .presentationDetents([.large])
                        }
                    }
                    .sheet(isPresented: $showHumidityView) {
                        if let weather = viewModel.selectedWeather {
                            HumidityView(weather: weather)
                                .presentationDetents([.medium])
                        } else {
                            Text("No weather data available")
                        }
                    }
                    .sheet(isPresented: $showRainView) {
                        if let weather = viewModel.selectedWeather {
                            RainView(weather: weather)
                                .presentationDetents([.medium])
                        } else {
                            Text("No weather data available")
                        }
                    }
                    .sheet(isPresented: $showWindView) {
                        if let weather = viewModel.selectedWeather {
                            WindView(weather: weather)
                                .presentationDetents([.medium])
                        } else {
                            Text("No weather data available")
                        }
                    }
                    .sheet(isPresented: $showTemperatureView) {
                        if let weather = viewModel.selectedWeather {
                            TemperatureView(weather: weather)
                                .presentationDetents([.medium])
                        } else {
                            Text("No weather data available")
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchAirPollutionData()
                await viewModel.fetchForecastData()
            }
            .fullScreenCover(isPresented: $showFullForecast) {
                if let forecast = viewModel.weatherForecast {
                    WeatherForecastLargeView(forecast: forecast)
                } else {
                    Text("No forecast available")
                }
            }
            .background(LinearGradient(
                gradient: Gradient(colors:
                                    [Color.cyan.opacity(0.8),
                                     Color.orange.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
        }
    }
    
    
}
#Preview {
    WeatherView()
        .environmentObject(WeatherViewModel())
}

