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
        ScrollView(.vertical){
            VStack {
                ForEach(viewModel.records){record in
                    WeatherRecordView(record: record, viewModel: viewModel)
                }.padding()
            }
        }
    }
}

struct WeatherRecordView: View {
    
    var record: WeatherModel.WeatherRecord
    var viewModel: WeatherViewModel
    var params = ["temperature", "humidity", "wind"]
    @State var current = 0
    @State var currParam = "temperature"
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0).stroke()
            GeometryReader(content: { geometry in
                HStack{
                Text(viewModel.getWeatherIcon(record: record))
                    .font(.system(size: 0.55 * geometry.size.height)).padding()
                    
                VStack(alignment: .leading){
                    Text(record.cityName)
                    switch currParam {
                    case "humidity":
                        Text("Humidity: \(record.humidity, specifier: "%.1f")%").font(.caption)
                    case "wind":
                        Text("Wind: \(record.windSpeed, specifier: "%.1f")m/s").font(.caption)                  default:
                        Text("Temperature: \(record.temperature, specifier: "%.1f")°C").font(.caption)
                            
                    }
                }.onTapGesture{
                    current += 1
                    currParam = params[current % 3]
                
                }
                Spacer()
                Text("🔄").onTapGesture {
                    viewModel.refresh( record: record, currParam: currParam)
                }.padding()
                }})
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                idealHeight: 90,
                alignment: .leading)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
