//
//  ContentView.swift
//  IoT_ESP32_BLE
//
//  Created by Кирилл Миронов on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var service = BluetoothService()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
//            Text("Hello, world!")
            Text(service.peripheralSatus.rawValue)
                .font(.title)
            Text("Temperature: \(service.TemperatureValue)")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("Pressure: \(service.PressureValue)")
                .font(.largeTitle)
                .fontWeight(.heavy)
//            Text(service.peripheralSatus.)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
