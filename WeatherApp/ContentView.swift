//
//  ContentView.swift
//  WeatherApp
//
//  Created by Emilia Mączka on 06/05/2021.
//

import SwiftUI

// "main" view
struct ContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    // @State var woeId: String = ""
    
    // creates scrolled view of all cities
    var body: some View {
        ScrollView(.vertical){
            VStack {
                TextField("Enter WoE ID", text: $viewModel.woeId)
                Text(viewModel.message)
                ForEach(viewModel.records){record in
                    WeatherRecordView(record: record, viewModel: viewModel)
                }.padding(.top, 4)
            }.padding()
        }
    }
}

// view of each single city
struct WeatherRecordView: View {
    
    var record: WeatherModel.WeatherRecord
    var viewModel: WeatherViewModel
    
    // list of possible parameters
    var params = ["temperature", "humidity", "wind"]
    @State var current = 0
    
    var cornerRadius : CGFloat = 25.0
    var iconScale : CGFloat = 0.55
    var min_width : CGFloat = 0
    var height: CGFloat = 90
    
    var body: some View {
        ZStack{
            // border for entire object
            RoundedRectangle(cornerRadius: cornerRadius).stroke()
            GeometryReader(content: { geometry in
                HStack{
                // inserts the appropriate icon for the record, sets dimensions
                Text(viewModel.getWeatherIcon(record: record))
                    .font(.system(size: iconScale * geometry.size.height)).padding()
                
                // each click increses the counter, its value defines which parameter will be displayed
                VStack(alignment: .leading){
                    Text(record.cityName)
                    switch params[current % params.count] {
                    case "humidity":
                        Text("Humidity: \(record.humidity, specifier: "%.1f")%").font(.caption)
                    case "wind":
                        Text("Wind: \(record.windSpeed, specifier: "%.1f") m/s").font(.caption)                  default:
                        Text("Temperature: \(record.temperature, specifier: "%.1f")°C").font(.caption)
                            
                    }
                }.onTapGesture{
                    current += 1
                }
                Spacer()
                // each tap refreshes value of current parameter
                Text("🔄").onTapGesture {
                    viewModel.refresh( record: record, currParam: params[current % params.count])
                }.frame(alignment: .trailing).padding()
                }})
        // sets the dimension of object
        }.frame(minWidth: min_width,
                maxWidth: .infinity,
                idealHeight: height,
                alignment: .leading)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
