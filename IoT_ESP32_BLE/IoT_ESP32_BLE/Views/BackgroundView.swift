//
//  BackgroundView.swift
//  IoT_ESP32_BLE
//
//  Created by Кирилл Миронов on 17.12.2023.
//

import SwiftUI

struct BackgroundView: View {
    var topColor: Color
//    var bottomColor: Color
    
    var body: some View {
//        LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
        Color(topColor)
            .edgesIgnoringSafeArea(.all)
    }
}
