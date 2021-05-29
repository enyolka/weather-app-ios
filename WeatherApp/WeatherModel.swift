//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Emilia Mączka on 06/05/2021.
//

import Foundation

struct WeatherModel {
    var records: Array<WeatherRecord> = []
    
    init(cities: Array<String>) {
        records = Array<WeatherRecord>()
        /*for city in cities {
            records.append(WeatherRecord(cityName: city))
        }*/
    }
    
    // weather record info
    // weather state is drawn from the list
    struct WeatherRecord: Identifiable {
        var id: UUID = UUID()
        var woeId: Int = [44418, 615702, 523920].randomElement()!
        var cityName: String
        var weatherState: String = ["Snow", "Sleet", "Hail",  "Thunderstorm", "Heavy Rain", "Light Rain", "Showers", "Heavy Cloud", "Light Cloud", "Clear"].randomElement()!
        var temperature: Float = Float.random(in: -10.0 ... 30.0)
        var humidity: Float = Float.random(in: 0 ... 100)
        var windSpeed: Float = Float.random(in: 0 ... 20)
        var windDirection: Float = Float.random(in: 0 ..< 360)
    }
    
    // selects the appropiate parameter and makes a random change on it
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
    
    mutating func addRecord(data: WeatherApiResponse) {
        records.append(WeatherRecord(
                        woeId: data.woeid,
                        cityName: data.title,
            weatherState: data.consolidatedWeather.first?.weatherStateName ?? "Clear",
            temperature: Float(data.consolidatedWeather.first?.theTemp ?? 0),
            humidity: Float(data.consolidatedWeather.first?.humidity ?? 0),
            windSpeed: Float(data.consolidatedWeather.first?.windSpeed ?? 0),
            windDirection: Float(data.consolidatedWeather.first?.windDirection ?? 0)
            ))
        
    }
}
