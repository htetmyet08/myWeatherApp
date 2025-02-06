//
//  ModelData.swift
//  WeatherApp
//
//  Created by htetmyet on 1/17/25.
//

import Foundation

var previewWeather: ResponseBody = load("weatherData")
var previewAirPollution: AirPollutionResponse = load("airPreview")
var previewForecast: ForecastResponse = load("forecastPreview")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: "json") else {
        fatalError("Couldn't find \(filename) in bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle: \(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
