//
//  CityWeatherCard.swift
//  WeatherApp
//
//  Created by htetmyet on 2/4/25.
//

import SwiftUI


struct CityWeatherCard: View {
    let weather: ResponseBody
    let screenWidth: CGFloat
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("City:")
                Text("Temperature:")
                Text("Weather:")
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("\(weather.name), \(weather.sys.country)")
                Text(viewModel.convertTemperature(weather.main.temp))
                Text("\(weather.weather.first?.description ?? "N/A")")
            }
        }
        .frame(width: screenWidth * 0.8)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.1))
        )
    }
}
#Preview {
    CityWeatherCard(weather: previewWeather, screenWidth: .infinity)
        .environmentObject(WeatherViewModel())
}
