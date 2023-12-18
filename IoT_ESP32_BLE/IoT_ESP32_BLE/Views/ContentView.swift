//
//  ContentView.swift
//  IoT_ESP32_BLE
//
//  Created by Кирилл Миронов on 15.11.2023.
//

import SwiftUI

//let DeviceName: String = String("BMP180_BLE_Sensor")
//let DeviceName: String = ""

struct ContentView: View {
    
    @Binding var DeviceName: String
    @StateObject var service = BluetoothService()
//    @ObservedObject var deviceData: DeviceDataModel
//    @State var DeviceName: String = "BMP180_BLE_Sensor"
    
//    DeviceName = $SensorName
    
//    @StateObject var service: BluetoothService
    
//    init(DeviceName: String) {
//        self.DeviceName = DeviceName
////        self.deviceName = SensorName
//        self.service = BluetoothService(DeviceName: DeviceName)
//    }
    
//    @StateObject var service = BluetoothService()
//    service.fetch(name: DeviceName)
//    BluetoothService(SensorName)
//    @IBOutlet var SensorName: String
//     = BluetoothService(DeviceName: SensorName)
//    var SensorName: String = "BMP180"
//    bottomColor: Color("lightBlue")
    
    var body: some View {
        
        ZStack {
            BackgroundView(topColor: .white)
            
            VStack {
//                Text("\(SensorName)")
                Text("\(DeviceName) is \(service.peripheralSatus.rawValue)")
                    .bold()
                    .padding()
                    .onAppear() {
                        service.fetch(name: self.DeviceName)
                    }
                if (service.peripheralSatus.rawValue == "connected") {
                    Image(systemName: "personalhotspot")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                }
                
                Spacer()
                
//                TextField()
                
                //            ConnectionView()
                //            SensorDataView()
                //            TextField("Sensor Name", text: String)
                Spacer()
                
                VStack(alignment: .leading ) {
                    SensorDataView(DataType: "P", Value: service.PressureValue, imageName: "barometer")
                        .frame(maxHeight: 20)
                    
                    SensorDataView(DataType: "T", Value: service.TemperatureValue, imageName: "thermometer.transmission")
                        .frame(maxHeight: 20)
                    
                    
                }
                
                Spacer()
                
                Text("Работу выполнил Миронов К. А.")
                    .font(.system(size: 15, weight: .medium, design: .default))
                    .padding()
                
            }
            .padding()
            
            
        }
    }

    
    
    
}

//#Preview {
//    ContentView(SensorName: (Binding<String>)"")
//}
