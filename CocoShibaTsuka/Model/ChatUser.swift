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
    
    init(data: [String: Any]) {
        self.uid = data[FirebaseConstants.uid] as? String ?? ""
        self.email = data[FirebaseConstants.email] as? String ?? ""
        self.profileImageUrl = data[FirebaseConstants.profileImageUrl] as? String ?? ""
        self.money = data[FirebaseConstants.money] as? String ?? ""
        self.username = data[FirebaseConstants.username] as? String ?? ""
    }
}
