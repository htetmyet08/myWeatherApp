//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by htetmyet on 1/17/25.
//

import Foundation
import CoreLocation

class WeatherManager {
    private let apiKey = "e0940ec5f5e092bfeb2f6aabc38d5ed8"
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric")
        else{
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error fetching from API")
        }
        let decoedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        return decoedData
    }
    func getWeatherByCityName(_ cityName: String) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric") else {
            throw WeatherError.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw WeatherError.invalidResponse
            }
            
            do {
                return try JSONDecoder().decode(ResponseBody.self, from: data)
            } catch {
                throw WeatherError.decodingError
            }
        } catch {
            throw WeatherError.networkError
        }
    }
    func getAirPollutionData(lat: Double, lon: Double) async throws -> AirPollutionResponse {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else {
            throw WeatherError.invalidURL
        }

        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw WeatherError.invalidResponse
            }

            do {
                return try JSONDecoder().decode(AirPollutionResponse.self, from: data)
            } catch {
                throw WeatherError.decodingError
            }
        } catch {
            throw WeatherError.networkError
        }
    }
    func getForecastData(lat: Double, lon: Double) async throws -> ForecastResponse {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric") else {
            throw WeatherError.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw WeatherError.invalidResponse
            }
            do {
                return try JSONDecoder().decode(ForecastResponse.self, from: data)
            } catch {
                throw WeatherError.decodingError
            }
        } catch {
            throw WeatherError.networkError
        }
    }
}

struct ResponseBody: Codable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    var rain: RainResponse?
    var clouds: CloudsResponse
    var visibility: Int
    var dt: Int
    var sys: SystemResponse
    var timezone: Int
    var id: Int
    var cod: Int

    struct CoordinatesResponse: Codable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Codable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Codable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
        var sea_level: Double?
        var grnd_level: Double?
    }
    
    struct WindResponse: Codable {
        var speed: Double
        var deg: Double
        var gust: Double?
    }

    struct RainResponse: Codable {
        var oneHour: Double

        private enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }

    struct CloudsResponse: Codable {
        var all: Int
    }

    struct SystemResponse: Codable {
        var type: Int?
        var id: Int?
        var country: String
        var sunrise: Int
        var sunset: Int
    }
}

struct AirPollutionResponse: Codable {
    let list: [AirQualityData]

    struct AirQualityData: Codable {
        let main: AirQualityIndex
        let components: AirComponents
    }

    struct AirQualityIndex: Codable {
        let aqi: Int // 1 (Good) - 5 (Hazardous)
    }

    struct AirComponents: Codable {
        let co: Double
        let no: Double?
        let no2: Double
        let o3: Double
        let so2: Double
        let pm2_5: Double
        let pm10: Double
        let nh3: Double
    }
}
struct ForecastResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [Forecast]
    let city: City
}

struct Forecast: Codable {
    let dt: Int
    let main: MainWeather
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dt_txt: String
}

struct MainWeather: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let sea_level: Int?
    let grnd_level: Int?
    let humidity: Int
    let temp_kf: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Clouds: Codable {
    let all: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Sys: Codable {
    let pod: String
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}

enum WeatherError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidCityName
    case decodingError
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided."
        case .invalidResponse:
            return "Invalid response from the server."
        case .invalidCityName:
            return "The city name provided is invalid."
        case .decodingError:
            return "Failed to decode the data."
        case .networkError:
            return "An network error occurred."
        }
    }
}

//extension ResponseBody.MainResponse {
//    var feelsLike: Double { return feels_like }
//    var tempMin: Double { return temp_min }
//    var tempMax: Double { return temp_max }
//}
