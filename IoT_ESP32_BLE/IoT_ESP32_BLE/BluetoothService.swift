//
//  BluetoothService.swift
//  IoT_ESP32_BLE
//
//  Created by Кирилл Миронов on 16.11.2023.
//

import Foundation
import CoreBluetooth

let DeviceName: String = String("BMP180_BLE_Sensor")

let SERVICE_UUID: CBUUID = CBUUID(string: "bff0a4e6-6aa8-47b0-b6d8-9c2145b6fd93")

let TEMPERATURE_UUID: CBUUID = CBUUID(string: "f5b019d8-747c-44ba-b1e1-6e8ae03d9501")
let PRESSURE_UUID: CBUUID = CBUUID(string: "4890fbd4-320c-4295-b833-bd5132a057b1")
let NAME_UUID: CBUUID = CBUUID(string: "3ac44097-e190-4b13-a835-e452baa630ee")
let RECIEVE_UUID: CBUUID = CBUUID(string: "6de451b9-902f-4a84-b1fc-b8834e4f792d")
//SERVICE_UUID ("bff0a4e6-6aa8-47b0-b6d8-9c2145b6fd93")

enum ConnectionStatus: String {
    case connected
    case disconnected
    case searching
    case connecting
    case error
}

class BluetoothService: NSObject, ObservableObject {
    
    private var centralManager: CBCentralManager!
    
    var SensorPeripheral: CBPeripheral?
    
    @Published var peripheralSatus: ConnectionStatus = .disconnected
    @Published var TemperatureValue: Double = 0
    @Published var PressureValue:Double = 0
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scanForPeripherals() {
        peripheralSatus = .searching
        centralManager.scanForPeripherals(withServices: nil)
//        centralManager.scanForPeripherals(withServices: [SERVICE_UUID])
    }
}

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("CoreBluetooth Powered On")
            scanForPeripherals()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name == "BMP180_BLE_Sensor" {
            print("Discovered \(peripheral.name ?? "no name")")
            SensorPeripheral = peripheral
            centralManager.connect(SensorPeripheral!)
            peripheralSatus = .connecting
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheralSatus = .connected
        
        peripheral.delegate = self
        peripheral.discoverServices([SERVICE_UUID])
        centralManager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        peripheralSatus = .disconnected
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        peripheralSatus = .error
        print(error?.localizedDescription ?? "no error")
    }
}

extension BluetoothService: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            if service.uuid == SERVICE_UUID {
                print("Found service for \(SERVICE_UUID)")
                peripheral.discoverCharacteristics(nil , for: service)
//                peripheral.discoverCharacteristics([TEMPERATURE_UUID] , for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics ?? [] {
            peripheral.setNotifyValue(true, for: characteristic)
            print("Found characteristic, waiting on values...")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == TEMPERATURE_UUID {
            guard let data = characteristic.value else {
                print("No data recieved for \(characteristic.uuid.uuidString)")
                return
            }
            
            let sensorData: Double = data.withUnsafeBytes { $0.pointee }
            TemperatureValue = sensorData.rounded(toPlaces: 2)
        }
    
        if characteristic.uuid == PRESSURE_UUID {
            guard let data = characteristic.value else {
                print("No data recieved for \(characteristic.uuid.uuidString)")
                return
            }
            
            let sensorData: Double = data.withUnsafeBytes { $0.pointee }
            PressureValue = sensorData.rounded(toPlaces: 2)
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
