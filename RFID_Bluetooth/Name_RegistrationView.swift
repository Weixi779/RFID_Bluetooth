//
//  Name_RegistrationView.swift
//  RFID_Bluetooth
//
//  Created by 孙世伟 on 2020/11/30.
//

import SwiftUI

struct Name_RegistrationView: View {
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var RFIDItems: RFIDS
    @Environment(\.presentationMode) var presentationMode
    
    @State var Rename: String = ""
    var body: some View {
        ZStack{
            Color("ButtonColor")
                .edgesIgnoringSafeArea(.all)
            VStack{
                VStack{
                    VStack{
                        Color(.white)
                    }.frame(height: 50)
                    .clipShape(Capsule())
                    HStack{
                        Text("卡号:\(bleManager.message)")
                            .font(.system(.largeTitle, design: .monospaced))
                            .foregroundColor(Color("ButtonColor"))
                            .padding(.top,-52)
                            .padding(.horizontal)
                        Spacer()
                    }
                }
                
                VStack{
                    VStack{
                        Color(.white)
                    }.frame(height: 50)
                    .clipShape(Capsule())
                    HStack{
                    TextField(RFIDItems.IsInlist(bleManager.message) ? "名称:\(RFIDItems.GiveMeName(bleManager.message))" : "未注册", text: $Rename)
                            .font(.system(.largeTitle, design: .monospaced))
                            .foregroundColor(Color("ButtonColor"))
                            .padding(.top,-52)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                }
                
                Button {
                    RFIDItems.Name_Registration(bleManager.message, Rename)
                    bleManager.writeToPeripheral("Bee")
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("注册/命名")
                        .clipedCapsule_II()
                }
            }
        }.navigationBarColor(UIColor(Color("ButtonColor")))

    }
}

//struct Name_RegistrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        Name_RegistrationView()
//    }
//}
