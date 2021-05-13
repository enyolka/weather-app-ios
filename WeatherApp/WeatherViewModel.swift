//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import Foundation

class WeatherViewModel : ObservableObject {
    
    @Published private(set) var model: WeatherModel = WeatherModel(cities: ["Cracow", "Paris", "London", "Warsaw", "Prague", "New York", "Los Angeles"])
    
    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }
    
    func refresh(record: WeatherModel.WeatherRecord) {
        //objectWillChange.send()
        model.refresh(record: record)
    }
    
    func getWeatherImage(record: WeatherModel.WeatherRecord) -> String {
        switch record.weatherState {
        case "Snow":
            return "❄️"
        case "Sleet":
            return "🌨"
        case "Hail":
            return "⛈"
        case "ThunderStorm":
            return "🌩"
        default:
            return "☀️"
        }
    }
}
