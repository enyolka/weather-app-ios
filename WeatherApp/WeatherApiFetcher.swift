//
//  WeatherApiFetcher.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 27/05/2021.
//

import Foundation
import Combine

class WeatherApiFetcher {
    
    func forecast(forId woeId: Int) -> AnyPublisher<WeatherApiResponse, Error> {
        let url = URL(string: "https://www.metaweather.com/api/location/44418/")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherApiResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
