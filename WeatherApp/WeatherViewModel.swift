//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by  Emilia Mączka on 06/05/2021.
//

import Foundation
import Combine

class WeatherViewModel : ObservableObject {
    
    @Published var woeId: String = ""
    @Published var message: String = "(user message)"
    
    private var cancellables: Set<AnyCancellable> = []
    private let fetcher: WeatherApiFetcher
    
    func fetchWeather(forId woeId: String) {
        fetcher.forecast(forId: woeId)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                print(value)
            })
            .store(in: &cancellables)
    }
    
    init() {
        fetcher = WeatherApiFetcher()
        
        $woeId
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: fetchWeather(forId:))
            .store(in: &cancellables)
    }
    
    @Published private(set) var model: WeatherModel = WeatherModel(cities: ["Cracow", "Paris", "London", "Warsaw", "Prague", "New York", "Los Angeles"])
    
    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }
    
    func refresh(record: WeatherModel.WeatherRecord, currParam: String) {
        //objectWillChange.send()
        model.refresh(record: record, currParam: currParam)
    }
    
    // assigns icons to weather descriptions and returns the appropriate image
    func getWeatherIcon(record: WeatherModel.WeatherRecord) -> String {
            let weatherIcons = ["Snow": "❄️", "Sleet": "🌨", "Hail":  "🌨",  "Thunderstorm": "🌩", "Heavy Rain": "🌧", "Light Rain": "🌧", "Showers": "🌦", "Heavy Cloud": "⛅️", "Light Cloud": "🌤", "Clear": "☀️"]
            
            return weatherIcons[record.weatherState]!
        }
}
