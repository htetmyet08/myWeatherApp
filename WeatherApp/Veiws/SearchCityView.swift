//
//  SearchCityView.swift
//  WeatherApp
//
//  Created by htetmyet on 1/23/25.
//
import SwiftUI
import Kingfisher
import CoreLocationUI
import CoreLocation

struct SearchCityView: View {
    @AppStorage("selectedUnit") private var isImperial = false

    @EnvironmentObject var viewModel: WeatherViewModel
    @StateObject var locationManager = LocationManager()
    
    @State private var errorMessage: String?
    private let weatherManager = WeatherManager()
    @State private var isSearching = false
    
    @FocusState private var isSearchFocused: Bool
    @State private var searchText = ""
    

    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        NavigationStack{
            VStack {
                if isSearching {
                    LocationButton(.shareCurrentLocation) {
                        locationManager.requestLocation()
                    }
                    .cornerRadius(20)
                    .foregroundStyle(.white)
                }
                HStack {
                    Text("Saved locations")
                        .fontWeight(.light)
                        .padding(.vertical, -10)
                        .padding(.leading, 15)
                        .hidden()
                    
                }
                .searchable(text: $viewModel.cityName, prompt: "Search weather by city name")
                .onChange(of: viewModel.cityName) { oldValue, newValue in
                    isSearching = !newValue.isEmpty
                    Task {
                        await viewModel.fetchWeather()
                    }
                    print("finding city...")
                }

//City Result here//
                if let weather = viewModel.weatherInfo {
                    CityWeatherCard(weather: weather, screenWidth: screenWidth)
                        .onTapGesture {
                            viewModel.saveSelectedWeather(weather)
                        }
                } else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
//Tap city to show weather//
                List {
                    ForEach(viewModel.savedCities, id: \.id) { city in
                        CityListItem(city: city)
                            .onTapGesture {
                                viewModel.selectCity(city)
                            }
                    }
                    .onDelete(perform: viewModel.deleteCity)
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                .listRowSeparator(.hidden)
                .listStyle(InsetListStyle())
            }
            .navigationTitle("Search")
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .padding(.trailing)
                }
            }

            .onAppear {
                viewModel.loadCitiesFromDefaults()
                viewModel.loadLastSelectedCity()
            }
            .onChange(of: locationManager.location) { _, newLocation in
                Task {
                    if let coord = newLocation {
                        await viewModel.fetchWeatherByGPS(latitude: coord.latitude, longitude: coord.longitude)
                    }
                }
            }
            .background(LinearGradient(
                gradient: Gradient(colors:
                                    [Color.cyan.opacity(0.8),
                                     Color.orange.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }




}
#Preview {
    @Previewable @State var selectedTab: Int = 1
    @Previewable @State var selectedWeather: ResponseBody? = previewWeather

    SearchCityView()
        .environmentObject(WeatherViewModel())
}
