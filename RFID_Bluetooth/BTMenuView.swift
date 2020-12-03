//
//  MeumView.swift
//  RFID_Bluetooth
//
//  Created by 孙世伟 on 2020/11/29.
//

import SwiftUI

struct BTMenuView: View {
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var RFIDItems: RFIDS
    
    @State var showTheSheet = false
    @State var signUp_rename = false
    @State var spend_reload = false

    var body: some View {
        ZStack{
            Color("ButtonColor")
                .edgesIgnoringSafeArea(.all)
            HStack{
                Spacer()
                Button {
                    showTheSheet.toggle()
                } label: {
                    Image(systemName: "doc.plaintext")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }.sheet(isPresented: $showTheSheet) {
                    RFIDLlistView().environmentObject(RFIDItems)
                }
            }
            VStack{
                Text("RFID管理界面")
                    .font(.system(.largeTitle , design:.rounded))
                    .foregroundColor(Color(.white))
                    .padding()
                
                NavigationLink(destination: Name_RegistrationView().environmentObject(bleManager).environmentObject(RFIDItems)){
                    Text("注册/命名")
                        .clipedCapsule_II()
                }
                
                NavigationLink(destination: Consumer_RechargeView().environmentObject(bleManager).environmentObject(RFIDItems)){
                    Text("消费/充值")
                        .clipedCapsule_II()
                }
            }
        }.navigationBarColor(UIColor(Color("ButtonColor")))

        
    }
}

//struct MeumView_Previews: PreviewProvider {
//    static var previews: some View {
//        BTMenuView()
//    }
//}
