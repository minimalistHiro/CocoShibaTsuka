//
//  ChatUser.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/10/14.
//

import Foundation

struct ChatUser: Hashable, Identifiable {
    var id: String { uid }
    
    let uid: String
    let email: String
    let profileImageUrl: String
    let money: String
    let username: String
    let age: String
    let address: String
    let isStore: Bool
    
    init(data: [String: Any]) {
        self.uid = data[FirebaseConstants.uid] as? String ?? ""
        self.email = data[FirebaseConstants.email] as? String ?? ""
        self.profileImageUrl = data[FirebaseConstants.profileImageUrl] as? String ?? ""
        self.money = data[FirebaseConstants.money] as? String ?? ""
        self.username = data[FirebaseConstants.username] as? String ?? ""
        self.age = data[FirebaseConstants.age] as? String ?? ""
        self.address = data[FirebaseConstants.address] as? String ?? ""
        self.isStore = data[FirebaseConstants.isStore] as? Bool ?? false
    }
}

let ages: [String] = [
    "",
    "10代以下", 
    "20代",
    "30代",
    "40代",
    "50代",
    "60代以上",
]

let addresses: [String] = [
    "",
    "芝", 
    "芝新町",
    "芝樋ノ爪",
    "芝西",
    "芝塚原",
    "芝宮根町",
    "芝中田",
    "芝下",
    "芝東町",
    "芝園町",
    "芝富士",
    "大字芝",
    "川口市（上記以外）",
    "蕨市",
    "さいたま市",
    "その他",
]


//enum Age: String, CaseIterable, Identifiable {
//    case teens
//    case twenties
//    case thirties
//    case forties
//    case fifties
//    case sixties
//    
//    var id: String { rawValue }
//    
//    var string: String {
//        switch self {
//        case .teens:
//            return "10代以下"
//        case .twenties:
//            return "20代"
//        case .thirties:
//            return "30代"
//        case .forties:
//            return "40代"
//        case .fifties:
//            return "50代"
//        case .sixties:
//            return "60代以上"
//        }
//    }
//}
