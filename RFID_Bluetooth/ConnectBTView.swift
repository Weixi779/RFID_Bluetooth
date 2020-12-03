//
//  DetailBTView.swift
//  RFID_Bluetooth
//
//  Created by 孙世伟 on 2020/11/28.
//

import SwiftUI

struct ConnectBTView: View {
    @ObservedObject var bleManager: BLEManager
    @ObservedObject var RFIDItems: RFIDS

    @State var isActive: Bool = false
    @State var showTheAlert: Bool = true
//    var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var peripheral : Peripheral
    
    var body: some View {
        ZStack{
            Color("ButtonColor")
                .edgesIgnoringSafeArea(.all)
            VStack{
                NavigationLink("", destination: BTMenuView().environmentObject(bleManager).environmentObject(RFIDItems), isActive: $isActive)
                VStack{
                    Text(showTheAlert ? "欢迎来到数据处理界面" : "蓝牙连接状态")
                        .foregroundColor(Color(.white))
                        .font(.system(size: 25))
                        .padding()
                    Text(showTheAlert ? "请点击开始连接按钮" : "\(bleManager.peripherals[bleManager.getTheIndex()].state)")
                        .foregroundColor(Color(.white))
                        .font(.headline)
                        .padding()
                }
                .padding(.horizontal)
                

                HStack (spacing: 10) {
                    Button(action: {
                        if showTheAlert == true{
                            showTheAlert.toggle()
                        }else{
                            isActive.toggle()
                        }
                        showTheAlert ? bleManager.stopScanning() : bleManager.connectPeripheral(peripheral.myPeripheral)
                    }) {
                        Text(showTheAlert ? "开始连接" : "跳转界面")
                            .fontWeight(.bold)
                            .clipedCapsule_II()
                    }
//                    .onReceive(timer) {_ in
//                        if bleManager.peripherals[bleManager.getTheIndex()].state == "订阅成功"{
//                            isActive = true
//                            timer.upstream.connect().cancel()
//                        }
//                    }
                }
            }.padding(.top,-20)
        }
        .navigationBarTitle("\(peripheral.name)", displayMode: .inline)
    }
    
}

//struct DetailBTView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailBTView()
//    }
//}
