//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 10/06/2021.
//

import SwiftUI
import MapKit

struct WeatherDetail: View {
    var record: WeatherModel.WeatherRecord
    var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            
            // shows map for current city
            MapView(region: viewModel.getRegion(record: record))
                .ignoresSafeArea(edges: .top)
                .frame(height: 140)
            
                // main information display
                VStack(alignment: .center){
                    Text(record.cityName)
                        .font(.largeTitle)
                        .padding(.horizontal, 16.0)
                        .padding(.vertical, 8.0)
                        .background(Color.white)
                        .cornerRadius(20)
                        .offset(y: -30)
                        .padding(.bottom, -130)
                    
                    Text(viewModel.getWeatherIcon(record: record))
                        .font(.title)
                        .padding(.top)
                    
                    Text(record.weatherState)
                }

            // weather info
            VStack(alignment: .center) {
                
                Divider()

                Text("Temperature: \(record.temperature, specifier: "%.1f")°C")
                Text("Min: \(record.minTemperature, specifier: "%.1f")°C | Max: \(record.maxTemperature, specifier: "%.1f")°C")
                    .font(.subheadline)
                
                Divider()
                
                Text("Air pressure: \(record.airPressure, specifier: "%.1f") hPa")
                
                Divider()
                
                Text("Humidity: \(record.humidity, specifier: "%.1f") %")
                
                Divider()
                
                    Text("Wind speed: \(record.windSpeed, specifier: "%.1f") km/h")
                    Text("Wind direction: \(record.windDirectionStr) ( \(record.windDirection, specifier: "%.1f")°C)")
                    
            }
            .padding()
            
            Spacer()
        }
    }
}

struct MapView: View {
    var region: MKCoordinateRegion
    
    var body: some View {
        VStack(){
            // shows map of the current location
            Map(coordinateRegion: .constant(region))

        }
    }
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetail(record: WeatherModel.WeatherRecord(cityName: "Warsaw"), viewModel: WeatherViewModel())
    }
}
