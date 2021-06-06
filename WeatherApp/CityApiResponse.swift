//
//  CityApiResponse.swift
//  WeatherApp
//
//  Created by Użytkownik Emilia Mączka on 29/05/2021.
//

import Foundation

// returns response for given city name or latitude and longitude
// MARK: - CityApiResponseElement
struct CityApiResponseElement: Codable {
    let title, locationType: String
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

typealias CityApiResponse = [CityApiResponseElement]
