//
//  SimpleMeatWeatherClientApp.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 20/05/2021.
//

import SwiftUI
@main
struct SimpleMetaWeatherClientApp: App {
    
    var weatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: weatherViewModel)
        }
    }
    
}
