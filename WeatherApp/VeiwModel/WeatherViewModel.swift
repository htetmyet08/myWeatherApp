//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by htetmyet on 2/4/25.
//

import SwiftUI
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
//TabView//
    @Published var selectedWeather: ResponseBody? = nil
    @Published var selectedTab: Int = 2
    @AppStorage("selectedUnit") var isImperial = false
    private let weatherManager = WeatherManager()
//SearchCityView//
    @Published var cityName: String = ""
    @Published var weatherInfo: ResponseBody?
    @Published var errorMessage: String?
    @Published var savedCities: [ResponseBody] = [] {
        didSet {
            saveCitiesToDefaults()
        }
    }
    
//WeatherView//
    @Published var weatherForecast: ForecastResponse?
    @Published var airPollution: AirPollutionResponse?
    @Published var unitManager = UnitManager()
    
    
//TabView Functions//
    init() {
        loadLastSelectedWeather()
    }

       // Save selected weather to UserDefaults
    private func saveLastSelectedWeather(_ weather: ResponseBody) {
        guard let encoded = try? JSONEncoder().encode(weather) else { return }
        UserDefaults.standard.set(encoded, forKey: "lastSelectedCity")
    }


    func loadLastSelectedWeather() {
        guard let data = UserDefaults.standard.data(forKey: "lastSelectedCity"),
              let decoded = try? JSONDecoder().decode(ResponseBody.self, from: data) else { return }
        self.selectedWeather = decoded
        self.selectedTab = 1
    }
    func loadLastSelectedWeatherUnit() {
        guard let data = UserDefaults.standard.data(forKey: "lastSelectedCity"),
              let decoded = try? JSONDecoder().decode(ResponseBody.self, from: data) else { return }
        self.selectedWeather = decoded

    }


    func convertTemperature(_ temp: Double) -> String {
        return isImperial ? "\(toFahrenheit(temp))°F" : "\(temp.roundDouble())°C"
    }

    private func toFahrenheit(_ celsius: Double) -> Int {
        let fahrenheit = (celsius * 9/5) + 32
        return Int((fahrenheit))
    }
    
//SerachCityView fuction//
    func fetchWeather() async {
        guard !cityName.isEmpty else {
            weatherInfo = nil
            errorMessage = nil
            return
        }

        do {
            weatherInfo = try await weatherManager.getWeatherByCityName(cityName)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            weatherInfo = nil
        }
    }
    
    func saveCitiesToDefaults() {
        guard let encoded = try? JSONEncoder().encode(savedCities) else { return }
        UserDefaults.standard.set(encoded, forKey: "savedCities")
    }
    func saveSelectedWeather(_ weather: ResponseBody) {
        if !savedCities.contains(where: { $0.name == weather.name }) {
            savedCities.append(weather)
        }
        selectedWeather = weather
        selectedTab = 1
        saveLastSelectedCity(weather)
    }
    func selectCity(_ city: ResponseBody) {
        if selectedWeather?.id != city.id {
            selectedWeather = city
            saveLastSelectedCity(city)
            selectedTab = 1
            print("Selected city: \(city.name), switching to Weather tab.") // Debugging log
        }
    }
    func deleteCity(at offsets: IndexSet) {
        savedCities.remove(atOffsets: offsets)
    }
    func loadCitiesFromDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "savedCities"),
              let decoded = try? JSONDecoder().decode([ResponseBody].self, from: data) else { return }
        savedCities = decoded
    }
    func loadLastSelectedCity() {
        guard let data = UserDefaults.standard.data(forKey: "lastSelectedCity"),
              let decoded = try? JSONDecoder().decode(ResponseBody.self, from: data) else { return }
        selectedWeather = decoded
    }
    func saveLastSelectedCity(_ city: ResponseBody) {
        guard let encoded = try? JSONEncoder().encode(city) else { return }
        UserDefaults.standard.set(encoded, forKey: "lastSelectedCity")
    }
//GPS location//
    func fetchWeatherByGPS(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        do {
            weatherInfo = try await weatherManager.getCurrentWeather(latitude: latitude, longitude: longitude)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            weatherInfo = nil
        }
    }
    
//GPS location//
    
    
//WeatherView Functions//
    func fetchAirPollutionData() async {
        guard let weather = selectedWeather else {
            DispatchQueue.main.async {
                self.errorMessage = "No city selected"
            }
            return
        }

        do {
            let pollutionData = try await weatherManager.getAirPollutionData(
                lat: weather.coord.lat,
                lon: weather.coord.lon
            )
            DispatchQueue.main.async {
                self.airPollution = pollutionData
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchForecastData() async {
        guard let weather = selectedWeather else {
            DispatchQueue.main.async {
                self.errorMessage = "No city selected"
            }
            return
        }

        do {
            let forecastData = try await weatherManager.getForecastData(
                lat: weather.coord.lat,
                lon: weather.coord.lon
            )
            DispatchQueue.main.async {
                self.weatherForecast = forecastData
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    func convertWindSpeed(_ speed: Double) -> String {
        return isImperial ? "\(unitManager.toMilesPerHour(speed)) mph" : "\(speed.roundDouble()) km/h"
    }
    
//WeatherView Description/ Color Functions//
    func windGustDescription(for gustSpeed: Double?) -> String {
        guard let gust = gustSpeed else { return "no strong gusts" }
        
        switch gust {
        case 0..<10:
            return "calm wind"
        case 10..<25:
            return "breezy condition"
        case 25..<40:
            return "strong gusts!"
        case 40..<60:
            return "very strong wind gust!"
        case 60...:
            return "extreme gusts wind gust!"
        default:
            return "no gust"
        }
    }
    func windGustGradient(for speed: Double) -> LinearGradient {
        let colors: [Color]

        switch speed {
        case 0..<10:
            colors = [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]
        case 10..<30:
            colors = [Color.green.opacity(0.8), Color.blue.opacity(0.6)]
        case 30..<50:
            colors = [Color.yellow.opacity(0.8), Color.orange.opacity(0.6)]
        case 50..<70:
            colors = [Color.orange.opacity(0.8), Color.red.opacity(0.6)]
        default:
            colors = [Color.red.opacity(0.8), Color.purple.opacity(0.6)]
        }

        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
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
            return "light rain"
        case 0.5..<2:
            return "moderate rain"
        case 2...:
            return "heavy rain"
        default:
            return "no rain"
        }
    }
    func temperatureGradient(for temp: Double) -> LinearGradient {
        let colors: [Color]

        switch temp {
        case ..<0:
            colors = [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]
        case 0..<10:
            colors = [Color.cyan.opacity(0.8), Color.green.opacity(0.6)]
        case 10..<20:
            colors = [Color.green.opacity(0.8), Color.yellow.opacity(0.6)]
        case 20..<30:
            colors = [Color.orange.opacity(0.8), Color.yellow.opacity(0.6)]
        case 30..<40:
            colors = [Color.red.opacity(0.8), Color.orange.opacity(0.6)]
        case 40...:
            colors = [Color.purple.opacity(0.8), Color.red.opacity(0.6)]
        default:
            colors = [Color.gray.opacity(0.5), Color.blue.opacity(0.5)]
        }

        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    func visibilityRecommendation(for visibility: Int) -> String {
        switch visibility {
        case 8000...:
            return "Visibility is excellent."
        case 5000..<8000:
            return "Visibility is good."
        case 2000..<5000:
            return "Visibility is moderate. Be cautious while driving."
        case 500..<2000:
            return "Visibility is low. Use headlights and drive carefully."
        case 0..<500:
            return "Visibility is very poor. Avoid unnecessary travel and stay safe."
        default:
            return "Visibility data is unavailable."
        }
    }
    
    func humidityDescription(for humidity: Double) -> String {
        switch humidity {
        case 0..<30:
            return "dry air, use moisturizer"
        case 30..<55:
            return "comfortable to live"
        case 55..<80:
            return "humid"
        case 80...100:
            return "ventilate properly"
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
    func humidityRecommendation(for humidity: Double) -> String {
        switch humidity {
        case 0..<30:
            return "The weather is dry. It's recommended to use moisturizer and drink more water."
        case 30..<55:
            return "Stay hydrated and enjoy your day."
        case 55..<80:
            return "The humidity is a bit high. Keep cool and drink enough fluids."
        case 80...100:
            return "The weather is very humid. Wear light clothing and stay in a cool place."
        default:
            return "Humidity data is unavailable."
        }
    }

}
