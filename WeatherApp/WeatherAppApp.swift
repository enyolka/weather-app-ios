//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Emilia Mączka on 06/05/2021.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    var viewModel = WeatherViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
