//
//  LattLongApiFetcher.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 31/05/2021.
//

import Foundation
import Combine

class LattLongApiFetcher {
    
    func forecast(forLat lat: Double, forLong long: Double) -> AnyPublisher<CityApiResponse, Error> {
        let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=37,-100")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CityApiResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
