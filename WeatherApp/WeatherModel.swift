//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import Foundation

struct WeatherModel {
    var records: Array<WeatherRecord>
    
    struct WeatherRecord {
        var cityName: String
        var weatherState: String
        var temperature: Float
        var humidity: Float
        var windSpeed: Float
        var windDirection: Float
    }
    
    func refresh(record: WeatherRecord) {
        print("Refreshig record: \(record)")
    }
}
