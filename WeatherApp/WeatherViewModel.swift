//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by  Emilia Mączka on 06/05/2021.
//

import Foundation
import Combine
import CoreLocation
import MapKit

class WeatherViewModel : NSObject, ObservableObject, CLLocationManagerDelegate{
    
    private var citiesList = ["Barcelona", "Paris", "London", "Warsaw", "Prague", "Rome", "Washington"]
    @Published var woeId: Int = 0
    @Published var message: String = "(user message)"
    
    private var cancellables: Set<AnyCancellable> = []
    private let fetcher: WeatherApiFetcher
    private let fetcherLattLong: LattLongApiFetcher
    private let fetcherCity: CityApiFetcher
    
    private let locationManager: CLLocationManager
    @Published var currentLocation: CLLocation?
    
    @Published private(set) var model: WeatherModel = WeatherModel()
   
    override init() {
        fetcher = WeatherApiFetcher()
        fetcherLattLong = LattLongApiFetcher()
        fetcherCity = CityApiFetcher()
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        citiesList.forEach{fetchCity(forName: $0)}
        
       /* $woeId
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: fetchWeather(forId:))
            .store(in: &cancellables)*/
    }

    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        let geocoder = CLGeocoder()
        if let location = currentLocation {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let lat = placemarks.first?.location?.coordinate.latitude,
                    let lon = placemarks.first?.location?.coordinate.longitude
                else {
                    return
                }
                self.fetchLattLong(lat: lat, lon: lon)
            }
        }
    }
    
    func fetchLattLong(lat: Double, lon: Double){
        fetcherLattLong.forecast(forLat: lat, forLong: lon)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                self.fetchWeather(forId: value[0].woeid)
            })
            .store(in: &cancellables)
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
    
    func getRegion(record: WeatherModel.WeatherRecord) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: record.latitude, longitude: record.longitude), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    }
}
