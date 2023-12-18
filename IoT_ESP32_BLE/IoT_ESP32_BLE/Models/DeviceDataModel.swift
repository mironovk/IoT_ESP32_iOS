//
//  DeviceDataModel.swift
//  IoT_ESP32_BLE
//
//  Created by Кирилл Миронов on 18.12.2023.
//

import Combine

class DeviceDataModel: ObservableObject {
    @Published var DeviceName: String = "BMP180_BLE_Sensor" /*BMP180_BLE_Sensor*/
    @Published var peripheralSatus: ConnectionStatus = .disconnected
    @Published var TemperatureValue: Double = 0
    @Published var PressureValue:Double = 0
}
