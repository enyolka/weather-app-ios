//
//  WeatherApiFetcher.swift
//  WeatherApp
//
//  Created by Emilia Mączka on 27/05/2021.
//

import Foundation
import Combine

// fetches weather data for given id
class WeatherApiFetcher {
    
    func forecast(forId woeId: Int) -> AnyPublisher<WeatherApiResponse, Error> {
        let url = URL(string: "https://www.metaweather.com/api/location/\(woeId)/")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherApiResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
