//
//  SensorDataView.swift
//  IoT_ESP32_BLE
//
//  Created by Кирилл Миронов on 17.12.2023.
//

import SwiftUI

struct SensorDataView: View {
    
    var DataType: String
    var Value: Double
    var imageName: String
//    let units: String = "°"
    
    var body: some View {
        HStack{
            
            Image(systemName: imageName)
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("\(DataType)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            
            Text("\(NSString(format: "%.2f", Value))")
                .font(.system(size: 20, weight: .medium, design: .monospaced))
            
            if (self.DataType == "P") {
                Text(" мм. рт. ст.")
                    .font(.system(size: 20, weight: .medium, design: .default))
            }
            else {
                Text(" °C")
                    .font(.system(size: 20, weight: .medium, design: .default))
            }
            
        }
        .padding()
        
        
        
    }
}
