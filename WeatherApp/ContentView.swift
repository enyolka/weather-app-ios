//
//  ContentView.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            ForEach(viewModel.records){record in
                WeatherRecordView(record: record, viewModel: viewModel)
            }.padding()
        }
    }
}

struct WeatherRecordView: View {
    
    var record: WeatherModel.WeatherRecord
    var viewModel: WeatherViewModel
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0).stroke()
            HStack{
                Text("🌤")
                    .font(.largeTitle)
                VStack{
                    Text(record.cityName)
                    Text("Temperature: \(record.temperature, specifier: "%.1f")°C").font(.caption)
                }
                Text("🔄").onTapGesture {
                    viewModel.refresh( record: record)
                }
            }
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
