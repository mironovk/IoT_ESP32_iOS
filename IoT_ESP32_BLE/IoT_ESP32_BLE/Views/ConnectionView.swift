//
//  ContentView.swift
//  IoT_ESP32_BLE
//
//  Created by Кирилл Миронов on 15.11.2023.
//

import SwiftUI


struct ConnectionView: View {
    
//    @State var DeviceName: String = ""
    @ObservedObject var deviceData = DeviceDataModel()
    
//    @ObservedObject var service = BluetoothService()
//    @EnvironmentObject var deviceData: DeviceDataModel
//    @Published var DeviceName = ""
//    @IBOutlet var SensorName: String
//    @StateObject var service = BluetoothService()
//    var SensorName: String = "BMP180
//    bottomColor: Color("lightBlue")
    
    var body: some View {
        NavigationView {
            
            
            ZStack {
                BackgroundView(topColor: .white)
                
                
                VStack(alignment: .center) {
                    
                    TextField("", text: self.$deviceData.DeviceName)
                        .modifier(TopFloatingHolder(noText: self.deviceData.DeviceName.isEmpty, placeHolderKey: "Device name"))
                        .frame(height: 50, alignment: .center)
                        .font(.system(size: 25, weight: .medium, design: .default))
                    
                    
                    
                    GeometryReader { geometry in
                        NavigationLink(destination: ContentView(DeviceName: self.$deviceData.DeviceName),
                                       label: { Text("Connect").font(.system(size: 20, weight: .medium, design: .default)) })
                            .frame(width: geometry.size.width, height: 50)
                            .accentColor(.white)
                            .background(.blue)
                            .cornerRadius(10)
//                            .onSubmit() {
//                                service.fetch(name: self.deviceData.DeviceName)
//                            }

                    }
                    .frame(maxWidth: 200, maxHeight: 50)
                    .padding()
                    
                    
                    
//                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
////                            .frame(width: geometry.size.width / 2 - 10, height: 50)
//                        .accentColor(.white)
//                        .background(.blue)
//                        .cornerRadius(10)
                    
                    
                    
                        
//                        .frame(alignment: .center)
                    
//                    Text("\(self.deviceData.DeviceName)")
                
                }
                .padding()
                
//                Spacer()
            }
                
            .navigationBarTitle("Connect to sensor")
        }
        
    }

    
    
    
}

public struct TopFloatingHolder: ViewModifier {
    
    let noText: Bool
    let placeHolderKey: LocalizedStringKey
    
    public func body(content: Content) -> some View {
        
        ZStack(alignment: .leading) {
            
            Text(placeHolderKey)
                .offset(x: 0, y: noText ? 0 : -20)
                .font(.system(size: noText ? 25 : 15))
                .foregroundColor(.black.opacity(noText ? 0.4 : 0.6))
            
            content
        }
    }
    
}


#Preview {
    ConnectionView()
}
