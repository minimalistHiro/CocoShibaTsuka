//
//  SendPayViewModel.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/11/22.
//

import SwiftUI

//class SendPayViewModel: ContentViewModel {
    
//    @ObservedObject var vm = ContentViewModel()
//    @Published var sendPayText = "0"                    // 送金テキスト
//    @Published var inputs: Inputs = .tappedAC           // ボタン押下実行処理
//    @Published var errorMessage = ""                    // エラーメッセージ
//    @Published var isShowError = false                  // エラー表示有無
//    let keyboard = ["7", "8", "9", "4", "5", "6", "1", "2", "3", "0", "00", "AC"]
//    var chatUser: ChatUser?
//    let didCompleteSendPayProcess: (String) -> ()
    
    // アラート
//    @Published var isShowSendPayAlert = false           // 送るポイントアラート
//    @Published var isShowOverPointError = false         // 送ポイントが所持ポイントを超えた場合のアラート
//    @Published var isShowZeroAlert = false              // 送るポイントが0以下の場合のアラート
//    @Published var isShowFailedUpdateUserError = false  // ユーザー情報更新失敗アラート
    
//    init(chatUser: ChatUser?) {
//        self.chatUserSP = chatUser
////        self.didCompleteSendPayProcess = didCompleteSendPayProcess
//    }
    
    // 入力ステータス
//    enum Inputs {
//        case tappedAC                   // キーボード（"AC"）
//        case tappedNumberPad            // キーボード（数字）
//    }
    
//    ///　キーボード入力から実行処理を分配する。
//    /// - Parameters:
//    ///   - keyboard: 入力されたキーボード
//    /// - Returns: なし
//    func apply(_ keyboard: String) {
//        // 入力したキーボードから入力ステータス（Inputs）を振り分ける。
//        if let _ = Double(keyboard) {
//            tappedNumberPadProcess(keyboard)
//        } else if keyboard == "AC" {
//            sendPayText = "0"
//            inputs = .tappedAC
//        }
//    }
    
//    ///　数字キーボード実行処理
//    /// - Parameters:
//    ///   - keyboard: 入力されたキーボード
//    /// - Returns: なし
//    private func tappedNumberPadProcess(_ keyboard: String) {
//        // テキストが初期値"0"の時に、"0"若しくは"00"が入力された時、何もしない。
//        if sendPayText == "0" && (keyboard == "0" || keyboard == "00") {
//            return
//        }
//        
//        if inputs == .tappedNumberPad {
//            // テキストに表示できる最大数字を超えないように制御
//            if isCheckOverMaxNumberOfDigits(sendPayText + keyboard) {
//                return
//            }
//            if sendPayText == "0" {
//                sendPayText = keyboard
//            } else {
//                sendPayText += keyboard
//            }
//        } else {
//            // 初回に"00"が入力された時、"0"と表記する。
//            if keyboard == "00" {
//                sendPayText = "0"
//            } else {
//                sendPayText = keyboard
//            }
//        }
//        inputs = .tappedNumberPad
//    }
//    
//    ///　計算結果がテキスト最大文字数を超えているかをチェックする。
//    /// - Parameters:
//    ///   - numberText: テキストに表示できる最大桁数に合わせて小数点以下を丸めたテキスト
//    /// - Returns: テキスト最大文字数以内の場合True、そうでない場合false。
//    private func isCheckOverMaxNumberOfDigits(_ numberText: String) -> Bool {
//        if numberText.count > Setting.maxNumberOfDigits {
//            return true
//        }
//        return false
//    }
//    
//    /// 送金処理
//    /// - Parameters: なし
//    /// - Returns: なし
//    func handleSendPay() {
//        guard let chatUser = chatUser else { return }
//        guard let user = currentUser else { return }
//        
//        // 各ユーザーの残高を計算
//        let chatUserMoney = (Int(chatUser.money) ?? 1000) + (Int(sendPayText) ?? 100)
//        let userMoney = (Int(user.money) ?? 1000) - (Int(sendPayText) ?? 100)
//        
//        // 各ユーザーの残高が0以下の場合、アラートを発動
//        if (chatUserMoney < 0) || (userMoney < 0) {
////            isShowOverPointError = true
//            self.errorMessage = "入力数値が残ポイントを超えています。"
//            self.isShowError = true
//            print(self.errorMessage)
//            return
//        }
//        
//        // 送金相手のデータを更新
//        let chatUserData = [FirebaseConstants.money: String(chatUserMoney),]
//        
//        FirebaseManager.shared.firestore.collection(FirebaseConstants.users)
//            .document(chatUser.uid)
//            .updateData(chatUserData as [AnyHashable : Any]) { error in
//                if error != nil {
////                print("Failed to update chatUser:", error)
////                self.isShowFailedUpdateUserError = true
//                self.errorMessage = "ユーザー情報の更新に失敗しました。"
//                self.isShowError = true
//                print(self.errorMessage)
//                return
//            }
//        }
//        
//        // 自身のデータを更新
//        let userData = [FirebaseConstants.money: String(userMoney),]
//        
//        FirebaseManager.shared.firestore.collection(FirebaseConstants.users)
//            .document(user.uid)
//            .updateData(userData as [AnyHashable : Any]) { error in
//                if error != nil {
////                print("Failed to update chatUser:", error)
////                self.isShowFailedUpdateUserError = true
//                self.errorMessage = "ユーザー情報の更新に失敗しました。"
//                self.isShowError = true
//                print(self.errorMessage)
//                return
//            }
//        }
////        didCompleteSendPayProcess(sendPayText)
//    }
//}
