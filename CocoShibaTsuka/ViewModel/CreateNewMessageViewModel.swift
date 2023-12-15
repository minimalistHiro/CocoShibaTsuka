//
//  CreateNewMessageViewModel.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject {
    
//    @ObservedObject var vm = ContentViewModel()
//    @Published var users = [ChatUser]()
//    @Published var searchText = ""                  // 検索テキスト
//    @Published var resultUsers = [ChatUser]()       // 検索に一致したユーザー名
//    @Published var isShowError = false
//    
//    init() {
//        fetchAllUsers()
//    }
    
//    /// 全ユーザー情報を取得。
//    /// - Parameters: なし
//    /// - Returns: なし
//    func fetchAllUsers() {
//        FirebaseManager.shared.firestore.collection(FirebaseConstants.users).getDocuments { documentsSnapshot, error in
//            if let error = error {
//                print("Failed to fetch users: \(error)")
//                self.isShowError = true
//                return
//            }
//            
//            documentsSnapshot?.documents.forEach({ snapshot in
//                    let data = snapshot.data()
//                    let user = ChatUser(data: data)
//                    
//                    // 追加するユーザーが自分以外の場合のみ、追加する。
//                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
//                        self.users.append(.init(data: data))
//                    }
//            })
//        }
//    }
    
//    /// 検索に一致した名前を取得
//    /// - Parameters: なし
//    /// - Returns: なし
//    func fetchSearchNames() {
//        resultUsers = []
//        
//        if searchText.isEmpty {
//            resultUsers = []
//        } else if vm.recentMessages == [] {
//            // 最新メッセージが空の場合
//            resultUsers = users.filter { user in
//                // 検索ワードに一致しているーザーネームのみ含める。
//                if user.username.contains(searchText) {
//                    return true
//                }
//                return false
//            }
//        } else {
//            let filteredUsers = users.filter {
//                // 検索ワードに一致しているーザーネームのみ含める。
//                $0.username.contains(searchText)
//            }
//            
//            // 最新メッセージのトーク相手のuidを取得
//            let recentMessageId = vm.recentMessages.map {
//                FirebaseManager.shared.auth.currentUser?.uid == $0.fromId ? $0.toId : $0.fromId
//            }
//            
//            // 最新メッセージを取得した相手を省く。
//            resultUsers = filteredUsers.filter {
//                !recentMessageId.contains($0.uid)
//            }
//        }
//    }
}
