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
    
	// fixed list of cities
    private var citiesList = ["Barcelona", "Paris", "London", "Moscow", "Prague", "Rome", "Washington"]
    
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
        
		// location settings 
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
		// itaretes over the cities list and fetches weather data
        citiesList.forEach{fetchCity(forName: $0)}
        
       /* $woeId
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: fetchWeather(forId:))
            .store(in: &cancellables)*/
    }

    var records: Array<WeatherModel.WeatherRecord> {
        model.records
    }

	// sets the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        let geocoder = CLGeocoder()
        if let location = currentLocation {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let lat = placemarks.first?.location?.coordinate.latitude,
                    let lon = placemarks.first?.location?.coordinate.longitude,
                    let locality = placemarks.first?.locality
                else {
                    return
                }
                self.fetchLattLong(lat: lat, lon: lon, locality: locality)
            }
        }
    }
    
	// fetches info about city from api with given latitude and longitude
    func fetchLattLong(lat: Double, lon: Double, locality: String){
        fetcherLattLong.forecast(forLat: lat, forLong: lon)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                self.fetchWeather(forId: value[0].woeid, locality: locality)
            })
            .store(in: &cancellables)
    }
    
	// fetches weather data from api
    func fetchWeather(forId woeId: Int, locality: String? = nil) {
        fetcher.forecast(forId: woeId)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                if (locality != nil) {
					// refresh first record (set permanently as a record for the current location)
                    self.model.refresh(record: self.records[0], data: value, locality: locality);
                } else {
					// add new record filled with returned data
                    self.model.addRecord(data: value);
                }
            })
            .store(in: &cancellables)
    }
    
	// fetches info about city from api with given city name 
    func fetchCity(forName cityName: String) {
        fetcherCity.forecast(forName: cityName)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                self.fetchWeather(forId: value[0].woeid)
            })
            .store(in: &cancellables)
    }
    
	// refresh selected record
    func refresh(record: WeatherModel.WeatherRecord, woeId: Int) {
        fetcher.forecast(forId: woeId)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                self.model.refresh(record: record, data: value, locality: record.locality)
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
