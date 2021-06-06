//
//  CityApiFetcher.swift
//  WeatherApp
//
//  Created by Użytkownik Emilia Mączka on 29/05/2021.
//

import Foundation
import Combine

// fetches city info for given city name
class CityApiFetcher {
    
    func forecast(forName cityName: String) -> AnyPublisher<CityApiResponse, Error> {
        let url = URL(string: "https://www.metaweather.com/api/location/search/?query=\(cityName)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CityApiResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
