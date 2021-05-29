//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by  Emilia Mączka on 06/05/2021.
//

import Foundation
import Combine

class WeatherViewModel : ObservableObject {
    
    private var citiesList = ["Barcelona", "Paris", "London", "Warsaw", "Prague", "Rome", "Washington"]
    @Published var woeId: Int = 0
    @Published var message: String = "(user message)"
    
    private var cancellables: Set<AnyCancellable> = []
    private let fetcher: WeatherApiFetcher
    private let fetcherCity: CityApiFetcher
    
    @Published private(set) var model: WeatherModel = WeatherModel()
    

    
    init() {
        fetcher = WeatherApiFetcher()
        fetcherCity = CityApiFetcher()
        
        citiesList.forEach{fetchCity(forName: $0)}
        
       /* $woeId
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: fetchWeather(forId:))
            .store(in: &cancellables)*/
    }


    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }
    
    func fetchWeather(forId woeId: Int) {
        fetcher.forecast(forId: woeId)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                self.model.addRecord(data: value)
            })
            .store(in: &cancellables)
    }
    
    func fetchCity(forName cityName: String) {
        fetcherCity.forecast(forName: cityName)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                self.fetchWeather(forId: value[0].woeid)
            })
            .store(in: &cancellables)
    }
    
    func refresh(record: WeatherModel.WeatherRecord, currParam: String) {
        //objectWillChange.send()
        fetcher.forecast(forId: record.woeId)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                self.model.refresh(record: record, currParam: currParam, data: value)
            })
            .store(in: &cancellables)
    }
    
    // assigns icons to weather descriptions and returns the appropriate image
    func getWeatherIcon(record: WeatherModel.WeatherRecord) -> String {
            let weatherIcons = ["Snow": "❄️", "Sleet": "🌨", "Hail":  "🌨",  "Thunderstorm": "🌩", "Heavy Rain": "🌧", "Light Rain": "🌧", "Showers": "🌦", "Heavy Cloud": "⛅️", "Light Cloud": "🌤", "Clear": "☀️"]
            
            return weatherIcons[record.weatherState]!
        }
}
