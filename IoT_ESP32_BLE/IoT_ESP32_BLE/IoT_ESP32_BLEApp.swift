//
//  IoT_ESP32_BLEApp.swift
//  IoT_ESP32_BLE
//
//  Created by Кирилл Миронов on 15.11.2023.
//

import SwiftUI

@main
struct IoT_ESP32_BLEApp: App {
//    let deviceData = DeviceDataModel()
    
    var body: some Scene {
        WindowGroup {
            ConnectionView()
//            ConnectionView().environment(deviceData)
//            BluetoothService().environment(deviceData)
        }
    }
}
