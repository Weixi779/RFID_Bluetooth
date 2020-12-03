//
//  RFIDLlistView.swift
//  RFID_Bluetooth
//
//  Created by 孙世伟 on 2020/11/29.
//

import SwiftUI

struct RFIDLlistView: View {
    @EnvironmentObject var RFIDItems: RFIDS
    var body: some View {
        VStack{
            List{
                ForEach(RFIDItems.rfids){ rfid in
                    VStack(alignment: .leading){
                        Text("\(rfid.name)")
                        HStack {
                            Text("\(rfid.ID)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(rfid.Gold)")
                                .font(.subheadline)
                        }
                    }
                }.onDelete(perform: removeItems)
            }
        }.navigationBarTitle("RFID列表")
    }
    func removeItems(at offsets: IndexSet){
        RFIDItems.rfids.remove(atOffsets: offsets)
    }
}
//struct RFIDLlistView_Previews: PreviewProvider {
//    static var previews: some View {
//        RFIDLlistView()
//    }
//}
