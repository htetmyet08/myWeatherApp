//
//  CityWeatherCard.swift
//  WeatherApp
//
//  Created by htetmyet on 2/4/25.
//

import SwiftUI
import Kingfisher

struct CityListItem: View {
    let city: ResponseBody
    @EnvironmentObject var viewModel: WeatherViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack{
                    Text(city.name)
                        .font(.headline)
                        .frame(width: 200, alignment: .leading)
                }

                HStack {
                    Text("\(viewModel.convertTemperature(city.main.temp))")
                        .frame(width: 60, alignment: .leading)
                    
                    Text("| \(city.weather.first?.description ?? "N/A")")
                        .frame(minWidth: 100, maxWidth: .infinity, alignment: .leading)
                        .lineLimit(nil)
                }
                .font(.subheadline)
            }
            
            Spacer()
            
            if let icon = city.weather.first?.icon {
                let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                KFImage(imageUrl)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .shadow(color: .gray, radius: 3)
                    .padding(.trailing)
            } else {
                Text("No icon available")
            }
        }
        .padding(.vertical, 5)
    }
}
#Preview {
    CityListItem(city: previewWeather)
        .environmentObject(WeatherViewModel())
}
