//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import Foundation

struct WeatherModel {
    var records: Array<WeatherRecord> = []
    
    init(cities: Array<String>) {
        records = Array<WeatherRecord>()
        for city in cities {
            records.append(WeatherRecord(cityName: city))
        }
    }
    
    struct WeatherRecord: Identifiable {
        var id: UUID = UUID()
        var cityName: String
        var weatherState: String = "Clear"
        var temperature: Float = Float.random(in: -10.0 ... 30.0)
        var humidity: Float = Float.random(in: 0 ... 100)
        var windSpeed: Float = Float.random(in: 0 ... 20)
        var windDirection: Float = Float.random(in: 0 ..< 360)
    }
    
    mutating func refresh(record: WeatherRecord, currParam: String) {
        let index = records.firstIndex{$0.id == record.id}
        switch currParam{
        case "humidity":
            records[index!].humidity = Float.random(in: 0 ... 100)
        case "wind":
            records[index!].windSpeed = Float.random(in: 0 ... 20)
        default:
        records[index!].temperature = Float.random(in: -10.0 ... 30.0)
        }
        print("Refreshig record: \(record)")
    }
}
