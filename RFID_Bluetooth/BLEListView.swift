//
//  ContentView.swift
//  RFID_Bluetooth
//
//  Created by 孙世伟 on 2020/11/24.
//

import SwiftUI

struct BLEListView: View {
    @ObservedObject var bleManager: BLEManager
    @ObservedObject var RFIDItems: RFIDS
    let BarColor: UIColor = UIColor(Color("ButtonColor"))
    var body: some View {
        NavigationView{
            VStack{
                List{
                    HStack{
                        Text("蓝牙状态")
                        Spacer()
                        BlueToothStateText()
                    }.padding(.horizontal)
                    ForEach(bleManager.peripherals) { peripheral in
                        NavigationLink(destination: ConnectBTView(bleManager: bleManager, RFIDItems: RFIDItems, peripheral: peripheral).environmentObject(bleManager).environmentObject(RFIDItems)) {
                            VStack(alignment: .leading){
                                Text("\(peripheral.name)")
                                HStack {
                                    Text("\(peripheral.id)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("\(peripheral.state)")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }.listStyle(InsetListStyle())
                
                Spacer()
                
                HStack (spacing: 10) {
                    Button(action: {
                        bleManager.startScanning()
                    }) {
                        Text("开始扫描")
                            .clipedCapsule_I()
                    }
                    Spacer()
                    Button(action: {
                        bleManager.stopScanning()
                    }) {
                        Text("停止扫描")
                            .clipedCapsule_I()
                    }
                }.padding(.horizontal)
            }
            .navigationTitle("选择蓝牙设备")
            .navigationBarColor(BarColor)
            
        }
        
    }
    func BlueToothStateText() -> some View {
        return bleManager.isSwitchedOn ?
            Text("蓝牙开启")
            .foregroundColor(.green)
            :
            Text("蓝牙关闭")
            .foregroundColor(.red)
    }
}


//struct ContentBLEView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentBLEView(bleManager: BLEManager())
//    }
//}
