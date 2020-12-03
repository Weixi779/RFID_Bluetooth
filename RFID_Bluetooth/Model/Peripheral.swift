//
//  Peripheral.swift
//  RFID_Bluetooth
//
//  Created by 孙世伟 on 2020/11/29.
//

import Foundation
import CoreBluetooth

struct Peripheral: Identifiable,Equatable{
    var id: UUID
    let name: String
    var state: String
    let myPeripheral: CBPeripheral
    static func ==(lhs:Peripheral , rhs: Peripheral)->Bool{ lhs.id == rhs.id }
    
    mutating func setState(_ nowState:String){
        state = nowState
    }
}
