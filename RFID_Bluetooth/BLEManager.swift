//
//  BLEManager.swift
//  RFID_Bluetooth
//
//  Created by 孙世伟 on 2020/11/26.
//

import Foundation
import CoreBluetooth


class BLEManager: NSObject , ObservableObject , CBCentralManagerDelegate , CBPeripheralDelegate{
    
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    @Published var message: String = ""
    
    var myCentral: CBCentralManager!
    var sendCharacteristic:CBCharacteristic!
    var peripheral:CBPeripheral!
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {        //扫描
        
        if peripheral.name != nil {
            let peripheralName: String = peripheral.name ?? "unname"
            let peripheralId: UUID = peripheral.identifier
            let peripheralState: String = someCBPeripheralState(peripheral.state.rawValue)
            let tempPeripheral = Peripheral(id: peripheralId, name: peripheralName, state: peripheralState, myPeripheral: peripheral)
            if (!peripherals.contains(tempPeripheral)){
                peripherals.append(tempPeripheral)
            }
        }
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {        //本机蓝牙状态
        if central.state == .poweredOn {
            isSwitchedOn = true
        }else{
            isSwitchedOn = false
        }
    }
    
    func startScanning() {      //开始扫描
        print("startScanning")
        myCentral.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {       //停止扫描
        print("stopScanning")
        peripherals.removeAll()
        myCentral.stopScan()
    }

    func connectPeripheral(_ peripheral:CBPeripheral){  //接口
        self.peripheral = peripheral
        myCentral.connect(peripheral, options: nil)
        chanceTheState("开始连接")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) { //did连接
        myCentral.stopScan()
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        chanceTheState("蓝牙连接成功")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {    //寻找服务
        chanceTheState("开始寻找外设")
        for service: CBService in peripheral.services! {
            //print("外设中的服务有：\(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {  //寻找特征值
        if (error != nil){
            return
        }
        for characteristic in service.characteristics! {
            if characteristic.uuid == CBUUID(string: "FFE1") {
                self.sendCharacteristic = characteristic
                chanceTheState("开始订阅特征值")
                peripheral.setNotifyValue(true, for: characteristic)
            }
            
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {  //didupdate订阅值
            print("订阅失败: \(error)")
            return
        }
        if characteristic.isNotifying {
            chanceTheState("订阅成功")
            print("成功")
        } else {
            print("取消订阅")
        }
    }
    //-MARK:读取消息
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)-> (){
        if(error != nil){       //更新接受信息
            return
        }
        let data = characteristic.value
        let str = String(decoding: data!, as: UTF8.self)
        clearMessage(str)
    }
    
    func clearMessage(_ str:String){    //信息输出
        let array = Array(str)
        var temp:String = ""
        for i in 0..<array.count {
            if i != array.count-1{
                temp += String(array[i])
            }
        }
        message = temp
    }
    //-MARK:发送消息
    func writeToPeripheral(_ textSting: String) {
//        let bytes = textSting.utf8
//        let buffer = [UInt8](bytes)
        let data = textSting.data(using: .utf8)!
        peripheral.writeValue(data, for: sendCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
        print(textSting)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        chanceTheState("断开连接")
        central.connect(peripheral, options: nil)
    }
    
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
        
    }
    
    func chanceTheState(_ state: String){
        peripherals[getTheIndex()].setState(state)
    }
    
    func getTheIndex()-> Int{       //返回索引
        if peripheral != nil {
            var index = 0
            for i in 0..<peripherals.count{
                if peripherals[i].myPeripheral == peripheral {
                    index = i
                    break
                }
            }
            return index
        }
        return 0
    }
    
    func someCBPeripheralState(_ index: Int)->String{       //返回蓝牙状态
        var tempString = "UNKNOW"
        if let someState = CBPeripheralState(rawValue: index){
            switch someState {
            case .connected:
                tempString = "connected"
            case.connecting:
                tempString = "connecting"
            case.disconnected:
                tempString = "未连接/可连接"
            case.disconnecting:
                tempString = "disconnecting"
            @unknown default:
                tempString = "nil"
            }
        }
        return tempString
    }
}
