//
//  RFID_BluetoothApp.swift
//  RFID_Bluetooth
//
//  Created by 孙世伟 on 2020/11/24.
//

import SwiftUI

@main
struct RFID_BluetoothApp: App {
    @StateObject var bleManager = BLEManager()
    @StateObject var RFIDItems = RFIDS()
    
    var body: some Scene {
        WindowGroup {
            BLEListView(bleManager: bleManager, RFIDItems: RFIDItems)
        }
    }
}
