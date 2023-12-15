//
//  ChatLogViewModel.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/11/22.
//

import SwiftUI
import FirebaseFirestore

class ChatLogViewModel: ContentViewModel {
    
//    @ObservedObject var vm = ContentViewModel()
//    @Published var chatMessages = [ChatMessage]()
//    @Published var chatText = ""                                // ユーザーの入力テキスト
//    @Published var count = 0                                    // 新規メッセージを取得した時を検出するカウンター変数
//    @Published var lastText = ""                                // 一時保存用最新メッセージ
//    @Published var isSendPay = false                            // 送金処理をしたか否か
//    @Published var errorMessage = ""                            // エラーメッセージ
//    @Published var isShowError = false                          // エラー表示有無
//    var firestoreListner: ListenerRegistration?
//    var chatUser: ChatUser?
    
    // アラート
//    @Published var isShowNotFetchMessagesError = false          // メッセージ取得失敗アラート
//    @Published var isShowNoDataFoundError = false               // データ未発見アラート
//    @Published var isShowFailedSaveMessageError = false         // メッセージ保存失敗アラート
//    @Published var isShowFailedSaveRecentMessageError = false   // 最新メッセージ保存失敗アラート
    
//    init(chatUser: ChatUser?) {
//        self.chatUser = chatUser
//    }
    
    /// メッセージを取得
    /// - Parameters: なし
    /// - Returns: なし
//    func fetchMessages() {
//        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        
//        guard let toId = chatUser?.uid else { return }
//        firestoreListner?.remove()
//        chatMessages.removeAll()
//        
//        FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.messages)
//            .document(fromId)
//            .collection(toId)
//            .order(by: FirebaseConstants.timestamp)
//            .addSnapshotListener { querySnapshot, error in
//                if error != nil {
////                    print("Failed to listen for messages: \(error)")
////                    self.isShowNotFetchMessagesError = true
//                    self.errorMessage = "メッセージの取得に失敗しました。"
//                    self.isShowError = true
//                    print(self.errorMessage)
//                    return
//                }
//                
//                querySnapshot?.documentChanges.forEach({ change in
//                    if change.type == .added {
//                        do {
//                            let cm = try change.document.data(as: ChatMessage.self)
//                            self.chatMessages.append(cm)
//                        } catch {
////                            print("Failed to decode message: \(error)")
////                            self.isShowNoDataFoundError = true
//                            self.errorMessage = "データが見つかりませんでした。"
//                            self.isShowError = true
//                            print(self.errorMessage)
//                        }
//                    }
//                })
//                DispatchQueue.main.async {
//                    self.count += 1
//                }
//            }
//    }
    
//    /// テキスト送信処理
//    /// - Parameters: なし
//    /// - Returns: なし
//    func handleSend() {
//        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        guard let toId = chatUser?.uid else { return }
//        
//        let document = FirebaseManager.shared.firestore.collection(FirebaseConstants.messages)
//            .document(fromId)
//            .collection(toId)
//            .document()
//        
//        // 自身のメッセージデータを保存
//        let messageData = [FirebaseConstants.fromId: fromId,
//                           FirebaseConstants.toId: toId,
//                           FirebaseConstants.text: (isSendPay ? lastText : chatText),
//                           FirebaseConstants.isSendPay: isSendPay,
//                           FirebaseConstants.timestamp:
//                           Timestamp()] as [String : Any]
//        
//        document.setData(messageData) { error in
//            if error != nil {
////                print("Failed to save message into Firesotre: \(error)")
////                self.isShowFailedSaveMessageError = true
//                self.errorMessage = "メッセージの保存に失敗しました。"
//                self.isShowError = true
//                print(self.errorMessage)
//                return
//            }
//        }
//        
//        // トーク相手のメッセージデータを保存
//        let recipientMessageDocument = FirebaseManager.shared.firestore.collection(FirebaseConstants.messages)
//            .document(toId)
//            .collection(fromId)
//            .document()
//        
//        recipientMessageDocument.setData(messageData) { error in
//            if error != nil {
////                print("Failed to save message into Firesotre: \(error)")
////                self.isShowFailedSaveMessageError = true
//                self.errorMessage = "メッセージの保存に失敗しました。"
//                self.isShowError = true
//                print(self.errorMessage)
//                return
//            }
//        }
//        
//        // 送金処理以外（通常テキスト送信）の場合のみ実行
//        if !isSendPay {
//            self.lastText = chatText
//            self.chatText = ""
//        }
//    }
    
    /// 最新のメッセージを保存
    /// - Parameters: なし
    /// - Returns: なし
//    func persistRecentMessage() {
//        guard let chatUser = chatUser else { return }
//        
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        guard let toId = self.chatUser?.uid else { return }
//        
//        // 自身のメッセージデータを保存
//        let document = FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.recentMessages)
//            .document(uid)
//            .collection(FirebaseConstants.message)
//            .document(toId)
//        
//        let data = [
//            FirebaseConstants.email: chatUser.email,
//            FirebaseConstants.text: self.lastText,
//            FirebaseConstants.fromId: uid,
//            FirebaseConstants.toId: toId,
//            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
//            FirebaseConstants.isSendPay: isSendPay,
//            FirebaseConstants.username: chatUser.username,
//            FirebaseConstants.timestamp: Timestamp(),
//        ] as [String : Any]
//        
//        document.setData(data) { error in
//            if error != nil {
////                print("Failed to save recent message: \(error)")
////                self.isShowFailedSaveRecentMessageError = true
//                self.errorMessage = "最新メッセージの保存に失敗しました。"
//                self.isShowError = true
//                print(self.errorMessage)
//                return
//            }
//        }
//        
//        // トーク相手のメッセージデータを保存
////        guard let currentUser = vm.chatUser else { return }
//        guard let currentUser = currentUser else { return }
//        
//        let recipientDocument = FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.recentMessages)
//            .document(toId)
//            .collection(FirebaseConstants.message)
//            .document(uid)
//        
//        let recipientData = [
//            FirebaseConstants.email: currentUser.email,
//            FirebaseConstants.text: self.lastText,
//            FirebaseConstants.fromId: uid,
//            FirebaseConstants.toId: toId,
//            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
//            FirebaseConstants.isSendPay: isSendPay,
//            FirebaseConstants.username: currentUser.username,
//            FirebaseConstants.timestamp: Timestamp(),
//        ] as [String : Any]
//        
//        recipientDocument.setData(recipientData) { error in
//            if error != nil {
////                print("Failed to save recent message: \(error)")
////                self.isShowFailedSaveRecentMessageError = true
//                self.errorMessage = "最新メッセージの保存に失敗しました。"
//                self.isShowError = true
//                print(self.errorMessage)
//                return
//            }
//        }
//    }
}
