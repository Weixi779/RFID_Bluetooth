//
//  RFID.swift
//  RFID_Bluetooth
//
//  Created by 孙世伟 on 2020/11/29.
//

import Foundation

struct RFID: Codable,Identifiable,Equatable{
    var id = UUID()
    let ID: String
    var Gold: Int
    var name: String
    static func ==(lhs:RFID , rhs: RFID)->Bool{ lhs.ID  == rhs.ID }
    mutating func resetName(_ str:String){
        name = str
    }
    mutating func upGold(_ up:Int) {
        Gold = Gold + up
    }
    mutating func downGold(_ down:Int) {
        Gold = Gold - down
    }
}

class RFIDS: ObservableObject {
    @Published var rfids : [RFID]{
        didSet{
            let encoder = JSONEncoder()
            if let encoder = try? encoder.encode(rfids) {
                UserDefaults.standard.set(encoder, forKey: "RFID")  //一旦改变 使用编码器
            }
        }
    }
    init() {
        if let rfid = UserDefaults.standard.data(forKey: "RFID"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([RFID].self, from: rfid){
                self.rfids = decoded
                return
            }
        }
        self.rfids = [RFID].init()
    }
    
    func IsInlist(_ str:String) -> Bool {
        for i in rfids {
            if i.ID == str {
                return true
            }
        }
        return false
    }
    func GiveMeName(_ str:String) -> String {
        for i in rfids {
            if i.ID == str {
                return i.name
            }
        }
        return ""
    }
    func FindTheIndex(_ str: String) -> Int{
        for i in 0..<rfids.count{
            if rfids[i].ID == str {
                return i
            }
        }
        return -1
    }
    
    func FindTheIndexII(_ name: String) -> Int{
        for i in 0..<rfids.count{
            if rfids[i].name == name {
                return i
            }
        }
        return -1
    }
    func Name_Registration(_ str:String,_ name:String){
        if IsInlist(str) {
            rfids[FindTheIndex(str)].resetName(name)
        }else{
            if name != "" {
                rfids.append(RFID(ID: str, Gold: 0, name: name))
            }else {
                rfids.append(RFID(ID: str, Gold: 0, name: str))
            }
            
        }
    }
    func GiveMeGold(_ str:String) -> Int {
        for i in rfids {
            if i.ID == str {
                return i.Gold
            }
        }
        return 0
    }
    
    func IsEnoughGold(_ str: String,_ down: Int) -> Bool{
        if IsInlist(str) == false {
            print("Not Find")
            return false
        }
        let gold = GiveMeGold(str)
        if gold < down {
            return false
        }else{
            rfids[FindTheIndex(str)].downGold(down)
            return true
        }
    }
    
    func upGold(_ name: String,_ up:Int) -> Bool {
        if FindTheIndexII(name) != -1 {
            rfids[FindTheIndexII(name)].upGold(up)
            print("成功")
            return true
        }else{
            print("失败")
            return false
        }
    }
    func nameArray()->[String]{
        var array = [String]()
        for i in rfids{
            array.append(i.name)
        }
        return array
    }
}
