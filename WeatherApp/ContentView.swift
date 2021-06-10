//
//  ContentView.swift
//  WeatherApp
//
//  Created by Emilia Mączka on 06/05/2021.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

// "main" view
struct ContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    // creates scrolled view of all cities
    var body: some View {
//        ScrollView(.vertical){
//            VStack {
//                ForEach(viewModel.records){record in
//                    WeatherRecordView(record: record, viewModel: viewModel)
//                }.padding(.top, 4)
//            }.padding()
//        }
        NavigationView {
            List(viewModel.records) { record in
                NavigationLink( destination: WeatherDetail(record: record, viewModel: viewModel)){
                    WeatherRecordView(record: record, viewModel: viewModel)}
            }
            .navigationTitle("Weather App")
        }
    }
}

// view of each single city record
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
    
    @State private var region = 0
    // boolean value responsible for displaying modal
    @State private var showModal = false
    
    var body: some View {
        ZStack{
            // border for entire object
            
            GeometryReader(content: { geometry in
                HStack{
                // inserts the appropriate icon for the record, sets dimensions
                Text(viewModel.getWeatherIcon(record: record))
                    .font(.system(size: iconScale * geometry.size.height)).padding()
                
                // each click increses the counter, its value defines which parameter will be displayed
                VStack(alignment: .leading){
                    
                    Text(record.locality == "" ? record.cityName : ((record.locality) + " (\(record.cityName))"))
                    
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
                    
                    VStack(){
                        // clicking on the button shows the map
                        Text("🗺").onTapGesture {
                            showModal = true
                        }
                        .sheet(isPresented: $showModal) {
                            ModalView(region: viewModel.getRegion(record: record))
                        }
                        
                        // each tap refreshes value of current parameter
                        Text("🔄").onTapGesture {
                            viewModel.refresh( record: record, woeId: record.woeId)
                        }.padding(.top, 3.0)
                    }
                .frame(alignment: .trailing).padding()
                }})
        // sets dimensions of object
        }.frame(minWidth: min_width,
                maxWidth: .infinity,
                idealHeight: height,
                alignment: .leading)
        
    }
    
}

// modal view for map of current city
struct ModalView: View {
    @Environment(\.presentationMode) var presentationMode

    var region: MKCoordinateRegion
    
    @State private var trackingMode = MapUserTrackingMode.none
    // the pin for AGH A1 building :)
    @State private var places: [Place] = [
        Place(coordinate: .init(latitude: 50.064528, longitude: 19.923556))
    ]
        
    var body: some View {
        VStack(){
            // shows map of the current location and sets pin at AGH A1 
            Map(coordinateRegion: .constant(region), annotationItems: places) { place in
                MapPin(coordinate: place.coordinate)
            }.padding()
            // allows to close the map with a button (next to collapsing by swiping a finger)
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
