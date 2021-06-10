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
            MapView(region: viewModel.getRegion(record: record))
                .ignoresSafeArea(edges: .top)
                .frame(height: 200)
            
            
                VStack(alignment: .center){
                    Text(record.cityName)
                        .font(.largeTitle)
                        .offset(y: -30)
                        .padding(.bottom, -130)
                        .multilineTextAlignment(.center)
                    Text(viewModel.getWeatherIcon(record: record))
                        .font(.title)
                        .padding(.top)
                    Text(record.weatherState)
                }
            VStack(alignment: .leading) {
                
                Divider()

                Text("Temperature: \(record.temperature)")
                Text("Humidity: \(record.humidity)")
                Text("Wind speed: \(record.windSpeed)")
                Text("Wind direction: \(record.windDirection)")
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
