//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import Foundation

class WeatherViewModel : ObservableObject {
    
    @Published private(set) var model: WeatherModel = WeatherModel(cities: ["Cracow", "Paris", "London", "Paris", "Prague", "New York", "Los Angeles"])
    
    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }
    
    func refresh(record: WeatherModel.WeatherRecord) {
        //objectWillChange.send()
        model.refresh(record: record)
    }
}
