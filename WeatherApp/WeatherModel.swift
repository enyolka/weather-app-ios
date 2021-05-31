//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Emilia Mączka on 06/05/2021.
//

import Foundation
import MapKit

struct WeatherModel {
    var records: Array<WeatherRecord> = []
    
    init() {
        records = Array<WeatherRecord>()
    }
    
    // weather record info
    // weather state is drawn from the list
    struct WeatherRecord: Identifiable {
        var id: UUID = UUID()
        var woeId: Int = [44418, 615702, 523920].randomElement()!
        var cityName: String
        var latitude: CLLocationDegrees = CLLocationDegrees(Float.random(in: -180...180))
        var longitude: CLLocationDegrees = CLLocationDegrees(Float.random(in: -180...180))
        var weatherState: String = ["Snow", "Sleet", "Hail",  "Thunderstorm", "Heavy Rain", "Light Rain", "Showers", "Heavy Cloud", "Light Cloud", "Clear"].randomElement()!
        var temperature: Float = Float.random(in: -10.0 ... 30.0)
        var humidity: Float = Float.random(in: 0 ... 100)
        var windSpeed: Float = Float.random(in: 0 ... 20)
        var windDirection: Float = Float.random(in: 0 ..< 360)
    }
    
    // selects the appropiate parameter and makes a random change on it
    mutating func refresh(record: WeatherRecord, currParam: String, data: WeatherApiResponse) {
        let index = records.firstIndex{$0.id == record.id}
        let arr = data.lattLong.components(separatedBy: ",")
        
        records[index!].woeId = data.woeid;
        records[index!].cityName = data.title;
        records[index!].latitude = CLLocationDegrees(arr[0]) ?? 0;
        records[index!].longitude = CLLocationDegrees(arr[1]) ?? 0;
        records[index!].weatherState = data.consolidatedWeather.first?.weatherStateName ?? "Clear";
        records[index!].temperature = Float(data.consolidatedWeather.first?.theTemp ?? 0) + Float.random(in: 0...3);
        records[index!].humidity = Float(data.consolidatedWeather.first?.humidity ?? 0);
        records[index!].windSpeed = Float(data.consolidatedWeather.first?.windSpeed ?? 0);
        records[index!].windDirection = Float(data.consolidatedWeather.first?.windDirection ?? 0);
    }
    
    mutating func addRecord(data: WeatherApiResponse, idx: Int, locality: String? = "") {
        let arr = data.lattLong.components(separatedBy: ",")
        let cityNameLocality = locality == "" ? data.title : data.title + " (\(locality ?? ""))"
        let i = idx == 1 ? self.records.endIndex : 0
        records.insert(WeatherRecord(
                        woeId: data.woeid,
                        cityName: cityNameLocality,
            latitude: CLLocationDegrees(arr[0]) ?? 0,
            longitude: CLLocationDegrees(arr[1]) ?? 0,
            weatherState: data.consolidatedWeather.first?.weatherStateName ?? "Clear",
            temperature: Float(data.consolidatedWeather.first?.theTemp ?? 0),
            humidity: Float(data.consolidatedWeather.first?.humidity ?? 0),
            windSpeed: Float(data.consolidatedWeather.first?.windSpeed ?? 0),
            windDirection: Float(data.consolidatedWeather.first?.windDirection ?? 0)
        ), at: i)
        
    }
}
