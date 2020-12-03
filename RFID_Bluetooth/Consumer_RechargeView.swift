//
//  Consumer_RechargeView.swift
//  RFID_Bluetooth
//
//  Created by 孙世伟 on 2020/11/30.
//

import SwiftUI

struct Consumer_RechargeView: View {
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var RFIDItems: RFIDS
    @State var downGold: Int = 0
    @State var showTheSheet = false

    var body: some View {
            ZStack{
                Color("ButtonColor")
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    VStack{
                        Color(.white)
                    }.frame(height: 50)
                    .clipShape(Capsule())
                    VStack{
                        HStack{
                            Text("卡号:\(bleManager.message)")
                                .foregroundColor(Color("ButtonColor"))
                            Spacer()
                        }
                        HStack{
                            Text( RFIDItems.IsInlist(bleManager.message) ? "余额:\(RFIDItems.GiveMeGold(bleManager.message))" : "未注册")
                                .foregroundColor(Color("ButtonColor"))
                            Spacer()
                        }
                    }
                    .padding(.top,-52)
                    .padding(.horizontal)
                    
                    VStack{
                        VStack{
                            Divider()
                            HStack{
                                Text("消费金额")
                                    .font(.subheadline)
                                    .foregroundColor(Color(.white))
                                Spacer()
                            }
                        }
                        
                        VStack{
                            VStack{
                                Color(.white)
                            }.frame(height: 20)
                            .clipShape(Capsule())
                            TextField("消费金额", value: $downGold, formatter: NumberFormatter())
                                .padding(.top,-28)
                                .padding(.horizontal)
                        }
                        
                        VStack{
                            Button {
                                if RFIDItems.IsEnoughGold(bleManager.message, downGold){
                                    bleManager.writeToPeripheral("Yes")
                                }else{
                                    bleManager.writeToPeripheral("No")
                                }
                            } label: {
                                Text("消费确认")
                                    .clipedCapsule_II()
                            }
                            Button {
                                showTheSheet.toggle()
                            } label: {
                                Text("充值界面")
                                    .clipedCapsule_II()
                            }
                            .sheet(isPresented: $showTheSheet) {
                                upSheetView(showTheSheet: $showTheSheet).environmentObject(bleManager).environmentObject(RFIDItems)
                            }
                        }
                        
                    }
                    
                }
            }
            
    }
}

struct upSheetView: View {
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var RFIDItem: RFIDS
    @State var upGold: Int = 0
    @State var RfidID: String = ""
    @Binding var showTheSheet: Bool
    var body: some View{
        NavigationView{
            Form{
                Section(header: Text("选卡")){
                    Picker("选卡", selection: $RfidID){
                        ForEach(RFIDItem.nameArray() , id: \.self){
                            Text($0)
                        }
                    }
                }
                Section(header: Text("充值金额")) {
                    TextField("充值金额", value: $upGold, formatter: NumberFormatter())
                }
                Section{
                    Button {
                        if RFIDItem.upGold(RfidID, upGold){
                            bleManager.writeToPeripheral("Yes")
                        }else{
                            bleManager.writeToPeripheral("No")
                        }
                        showTheSheet.toggle()
                    } label: {
                        Text("充值确认")
                    }
                    
                }
            }.navigationTitle("充值界面")
            

        }
    }
}

//struct Consumer_RechargeView_Previews: PreviewProvider {
//    static var previews: some View {
//        Consumer_RechargeView()
//    }
//}
