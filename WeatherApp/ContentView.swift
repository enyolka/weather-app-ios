//
//  ContentView.swift
//  WeatherApp
//
//  Created by Użytkownik Gość on 06/05/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ForEach(0..<8){_ in
                WeatherRecordView()
            }.padding()
        }
    }
}

struct WeatherRecordView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0).stroke()
            HStack{
                Text("🌤")
                    .font(.largeTitle)
                VStack{
                    Text("City")
                    Text("Temperature: 27°C").font(.caption)
                }
            }
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
