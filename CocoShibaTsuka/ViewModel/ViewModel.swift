//
//  ViewModel.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/12/02.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseAnalytics

final class ViewModel: ObservableObject {
    
    @Published var currentUser: ChatUser?                       // 現在のユーザー
    @Published var chatUser: ChatUser?                          // トーク相手ユーザー
    @Published var friends = [Friend]()                         // 友達ユーザー
    @Published var friend: Friend?                              // 特定の友達情報
    @Published var recentMessages = [RecentMessage]()           // 全最新メッセージ
    @Published var chatMessages = [ChatMessage]()               // 全メッセージ
    @Published var errorMessage = ""                            // エラーメッセージ
//    @Published var isUserCurrentryLoggedOut = false             // ユーザーのログインの有無
    @Published var isShowError = false                          // エラー表示有無
    @Published var isScroll = false                             // メッセージスクロール用変数
    @Published var onIndicator = false                          // インジケーターが進行中か否か
    @Published var isQrCodeScanError = false                    // QRコード読み取りエラー
    let didCompleteLoginProcess: () -> ()
    
    init(){
        self.didCompleteLoginProcess = {}
    }
    
    init(didCompleteLoginProcess: @escaping () -> ()) {
        self.didCompleteLoginProcess = didCompleteLoginProcess
    }
    
// MARK: - Fetch
    
    /// 現在ユーザー情報を取得
    /// - Parameters: なし
    /// - Returns: なし
    func fetchCurrentUser() {
        onIndicator = true
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.handleError(String.failureFetchUID, error: nil)
            return
        }
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.users)
            .document(uid)
            .getDocument { snapshot, error in
                self.handleNetworkError(error: error, errorMessage: String.failureFetchUser)
                
                guard let data = snapshot?.data() else {
                    self.handleError(String.notFoundData, error: nil)
                    return
                }
                self.currentUser = .init(data: data)
                self.onIndicator = false
//                print("[CurrentUser]\n \(String(describing: self.currentUser))\n")
            }
    }
    
    /// UIDに一致するユーザー情報を取得
    /// - Parameters:
    ///   - uid: トーク相手のUID
    /// - Returns: なし
    func fetchUser(uid: String) {
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.users)
            .document(uid)
            .getDocument { snapshot, error in
                self.handleNetworkError(error: error, errorMessage: String.failureFetchUser)
                
                guard let data = snapshot?.data() else {
                    self.isQrCodeScanError = true
                    self.handleError(String.notFoundData, error: nil)
                    return
                }
                self.chatUser = .init(data: data)
//                print("[ChatUser]\n \(String(describing: self.chatUser))\n")
            }
    }
    
    /// 最新メッセージを取得
    /// - Parameters: なし
    /// - Returns: なし
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        self.recentMessages.removeAll()
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.message)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                self.handleNetworkError(error: error, errorMessage: "最新メッセージの取得に失敗しました。")
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    do {
                        let rm = try change.document.data(as: RecentMessage.self)
                        self.recentMessages.insert(rm, at: 0)
                    } catch {
                        self.handleError(String.notFoundData, error: nil)
                        return
                    }
                })
//                print("[RecentMessage]\n \(String(describing: self.recentMessages))\n")
            }
    }
    
    /// メッセージを取得
    /// - Parameters:
    ///   - toId: トーク相手のUID
    /// - Returns: なし
    func fetchMessages(toId: String) {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        chatMessages.removeAll()
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                self.handleNetworkError(error: error, errorMessage: "メッセージの取得に失敗しました。")
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            let cm = try change.document.data(as: ChatMessage.self)
                            self.chatMessages.append(cm)
                        } catch {
                            self.handleError(String.notFoundData, error: nil)
                            return
                        }
                    }
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.isScroll.toggle()
                }
//                print("[Message]\n \(String(describing: self.chatMessages))\n")
//                print("[Message] \n")
            }
    }
    
    /// UIDに一致する友達情報を取得
    /// - Parameters:
    ///   - document1: ドキュメント1
    ///   - document2: ドキュメント2
    /// - Returns: なし
    func fetchFriend(document1: String, document2: String) {
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.friends)
            .document(document1)
            .collection(FirebaseConstants.user)
            .document(document2)
            .getDocument { snapshot, error in
                self.handleNetworkError(error: error, errorMessage: "このユーザーはあなたと縁を切りました。")
                
                guard let data = snapshot?.data() else {
                    self.handleError("このユーザーはあなたと縁を切りました。", error: nil)
                    return
                }
                self.friend = .init(data: data)
//                print("[Friend]\n \(String(describing: self.friend))\n")
            }
    }
    
    /// 友達情報を取得
    /// - Parameters: なし
    /// - Returns: なし
    func fetchFriends() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        self.friends.removeAll()
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.friends)
            .document(uid)
            .collection(FirebaseConstants.user)
            .order(by: FirebaseConstants.username)
            .addSnapshotListener { querySnapshot, error in
                self.handleNetworkError(error: error, errorMessage: "友達情報の取得に失敗しました。")
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            let fr = try change.document.data(as: Friend.self)
                            self.friends.append(fr)
                        } catch {
                            self.handleError(String.notFoundData, error: nil)
                            return
                        }
                    }
                })
//                print("[Friend]\n \(String(describing: self.friends))\n")
            }
    }
    
// MARK: - Handle
    
    /// ログイン
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    /// - Returns: なし
    func handleLogin(email: String, password: String) {
        onIndicator = true
        // メールアドレス、パスワードどちらかが空白の場合、エラーを出す。
        if email.isEmpty || password.isEmpty {
            self.handleError(String.emptyEmailOrPassword, error: nil)
            return
        }
        
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error as NSError?, let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    self.handleError(String.invalidEmail, error: error)
                    return
                case .userNotFound, .wrongPassword:
                    self.handleError(String.userNotFound, error: error)
                    return
                case .userDisabled:
                    self.handleError(String.userDisabled, error: error)
                    return
                case .networkError:
                    self.handleError(String.networkError, error: error)
                    return
                default:
                    self.handleError(error.domain, error: error)
                    return
                }
            }
            self.onIndicator = false
            self.didCompleteLoginProcess()
//            self.isUserCurrentryLoggedOut = false
        }
    }
    
    /// 新規作成
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    ///   - password: ユーザー名
    ///   - image: トップ画像
    /// - Returns: なし
    func createNewAccount(email: String, password: String, username: String, age: String, address: String, image: UIImage?) {
        onIndicator = true
        // メールアドレス、パスワードどちらかが空白の場合、エラーを出す。
        if email.isEmpty || password.isEmpty {
            self.handleError(String.emptyEmailOrPassword, error: nil)
            return
        }
        
        // パスワードの文字数が足りない時にエラーを発動。
//        if password.count < Setting.minPasswordOfDigits {
//            self.isShowPasswordOfDigitsError = true
//            return
//        }
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error as NSError?, let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    self.handleError(String.invalidEmail, error: error)
                    return
                case .weakPassword:
                    self.handleError(String.weakPassword, error: error)
                    return
                case .emailAlreadyInUse:
                    self.handleError(String.emailAlreadyInUse, error: error)
                    return
                case .networkError:
                    self.handleError(String.networkError, error: error)
                    return
                default:
                    self.handleError(error.domain, error: error)
                    return
                }
            }
            
            if image == nil {
                self.persistUsers(email: email, username: username, age: age, address: address, imageProfileUrl: nil)
            } else {
                self.persistImage(email: email, username: username, age: age, address: address, image: image)
            }
        }
    }
    
//    func signInWithEmailLink(email: String, link: String) {
//        Auth.auth().signIn(withEmail: email, link: link) { user, error in
//            self.handleNetworkError(error: error, errorMessage: "メールアドレス認証に失敗しました。")
//        }
//    }
    
    /// テキスト送信処理
    /// - Parameters:
    ///   - toId: 受信者UID
    ///   - chatText: ユーザーの入力テキスト
    ///   - lastText: 一時保存用最新メッセージ
    ///   - isSendPay: 送金の有無
    /// - Returns: なし
    func handleSend(toId: String, chatText: String, lastText: String, isSendPay: Bool) {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let messageData = [FirebaseConstants.fromId: fromId,
                           FirebaseConstants.toId: toId,
                           FirebaseConstants.text: (isSendPay ? lastText : chatText),
                           FirebaseConstants.isSendPay: isSendPay,
                           FirebaseConstants.timestamp:
                            Timestamp()] as [String : Any]
        
        // 自身のメッセージデータを保存
        let messageDocument = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .document()
        
        messageDocument.setData(messageData) { error in
            if error != nil {
                self.handleError("メッセージの保存に失敗しました。", error: error)
                return
            }
        }
        
        // トーク相手のメッセージデータを保存
        let recipientMessageDocument = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if error != nil {
                self.handleError("メッセージの保存に失敗しました。", error: error)
                return
            }
        }
        
        // 自身のメッセージデータを保存
        guard let chatUser = chatUser else { return }
        persistRecentMessage(user: chatUser, isSelf: true, fromId: fromId, toId: toId, text: isSendPay ? lastText : chatText, isSendPay: isSendPay)
        
        // トーク相手のメッセージデータを保存
        guard let currentUser = currentUser else { return }
        persistRecentMessage(user: currentUser, isSelf: false, fromId: fromId, toId: toId, text: isSendPay ? lastText : chatText, isSendPay: isSendPay)
    }
    
    /// サインアウト
    /// - Parameters: なし
    /// - Returns: なし
//    func handleSignOut() {
//        isUserCurrentryLoggedOut = true
//        try? FirebaseManager.shared.auth.signOut()
//    }
    
    /// ネットワークエラー処理
    /// - Parameters:
    ///   - error: エラー
    ///   - errorMessage: エラーメッセージ
    /// - Returns: なし
    func handleNetworkError(error: Error?, errorMessage: String) {
        if let error = error as NSError?, let errorCode = AuthErrorCode.Code(rawValue: error.code) {
            switch errorCode {
            case .networkError:
                self.handleError(String.networkError, error: error)
                return
            default:
                self.handleError(errorMessage, error: error)
                return
            }
        }
    }
    
    /// エラー処理
    /// - Parameters:
    ///   - errorMessage: エラーメッセージ
    /// - Returns: なし
    func handleError(_ errorMessage: String, error: Error?) {
        self.onIndicator = false
        self.errorMessage = errorMessage
        self.isShowError = true
        // エラーメッセージ
        if let error = error {
            print("Error: \(error.localizedDescription)")
        } else {
            print("Error: \(errorMessage)")
        }
    }
    
// MARK: - Persist
    
    /// ユーザー情報を保存
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    ///   - imageProfileUrl: 画像URL
    /// - Returns: なし
    func persistUsers(email: String, username: String, age: String, address: String, imageProfileUrl: URL?) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = [FirebaseConstants.uid : uid,
                        FirebaseConstants.email: email,
                        FirebaseConstants.profileImageUrl: imageProfileUrl?.absoluteString ?? "",
                        FirebaseConstants.money: Setting.newRegistrationBenefits,
                        FirebaseConstants.username: username == "" ? email : username,
                        FirebaseConstants.age: age,
                        FirebaseConstants.address: address,
                        FirebaseConstants.isStore: false,
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.users)
            .document(uid)
            .setData(userData) { error in
                if error != nil {
                    // Authを削除
                    self.deleteAuth()
                    // 画像が保存済みであれば画像を削除
                    if let imageProfileUrl {
                        self.deleteImage(withPath: imageProfileUrl.absoluteString)
                    }
                    self.handleError("ユーザー情報の保存に失敗しました。", error: error)
                    return
                }
//                Analytics.logEvent("user_information", parameters: [
//                  "age": age as NSObject,
//                  "address": address as NSObject,
//                ])
                Analytics.setUserProperty(age, forName: "age")
                Analytics.setUserProperty(address, forName: "address")
                self.onIndicator = false
                self.didCompleteLoginProcess()
            }
    }
    
    /// 最新メッセージを保存
    /// - Parameters:
    ///   - user: トーク相手のデータ
    ///   - isSelf: 自身のデータか否か
    ///   - fromId: 送信者UID
    ///   - toId: 受信者UID
    ///   - text: テキスト
    ///   - isSendPay: 送金の有無
    /// - Returns: なし
    private func persistRecentMessage(user: ChatUser, isSelf: Bool, fromId: String, toId: String, text: String, isSendPay: Bool) {
        let document: DocumentReference
        
        // 自身のデータか、トーク相手のデータかでドキュメントを変える。
        if isSelf {
            document = FirebaseManager.shared.firestore
                .collection(FirebaseConstants.recentMessages)
                .document(fromId)
                .collection(FirebaseConstants.message)
                .document(toId)
        } else {
            document = FirebaseManager.shared.firestore
                .collection(FirebaseConstants.recentMessages)
                .document(toId)
                .collection(FirebaseConstants.message)
                .document(fromId)
        }
        
        let data = [
            FirebaseConstants.email: user.email,
            FirebaseConstants.text: text,
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: user.profileImageUrl,
            FirebaseConstants.isSendPay: isSendPay,
            FirebaseConstants.username: user.username,
            FirebaseConstants.timestamp: Timestamp(),
        ] as [String : Any]
        
        document.setData(data) { error in
            if error != nil {
                self.handleError("最新メッセージの保存に失敗しました。", error: error)
                return
            }
        }
    }
    
    /// 友達情報を保存
    /// - Parameters:
    ///   - document1: ドキュメント1
    ///   - document2: ドキュメント2
    ///   - data: データ
    /// - Returns: なし
    func persistFriends(document1: String, document2: String, data: [String: Any]) {
        let friendDocument = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.friends)
            .document(document1)
            .collection(FirebaseConstants.user)
            .document(document2)
        
        friendDocument.setData(data) { error in
            if error != nil {
                self.handleError("友達の保存に失敗しました。", error: error)
                return
            }
        }
    }
    
    /// 画像を保存
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    ///   - image: トップ画像
    /// - Returns: なし
    func persistImage(email: String, username: String, age: String, address: String, image: UIImage?) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata: nil) { _, error in
            if error != nil {
                self.deleteAuth()
                self.handleError("画像の保存に失敗しました。", error: error)
                return
            }
            // Firestore Databaseに保存するためにURLをダウンロードする。
            ref.downloadURL { url, error in
                if error != nil {
                    self.deleteAuth()
                    self.handleError("画像URLの取得に失敗しました。", error: error)
                    return
                }
                guard let url = url else { return }
                self.persistUsers(email: email, username: username, age: age, address: address, imageProfileUrl: url)
            }
        }
    }
    
// MARK: - Update
    
    /// ユーザー情報を更新
    /// - Parameters:
    ///   - document: ドキュメント
    ///   - data: データ
    /// - Returns: なし
    func updateUsers(document: String, data: [String: Any]) {
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.users)
            .document(document)
            .updateData(data as [AnyHashable : Any]) { error in
                self.handleNetworkError(error: error, errorMessage: "ユーザー情報の更新に失敗しました。")
            }
    }
    
    /// 最新メッセージを更新
    /// - Parameters:
    ///   - document1: ドキュメント1
    ///   - document2: ドキュメント2
    ///   - data: データ
    /// - Returns: なし
    func updateRecentMessages(document1: String, document2: String, data: [String: Any]) {
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(document1)
            .collection(FirebaseConstants.message)
            .document(document2)
            .updateData(data as [AnyHashable : Any]) { error in
                self.handleNetworkError(error: error, errorMessage: "最新メッセージの更新に失敗しました。")
            }
    }
    
    /// 友達情報を更新
    /// - Parameters:
    ///   - document1: ドキュメント1
    ///   - document2: ドキュメント2
    ///   - data: データ
    /// - Returns: なし
    func updateFriends(document1: String, document2: String, data: [String: Any]) {
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.friends)
            .document(document1)
            .collection(FirebaseConstants.user)
            .document(document2)
            .updateData(data as [AnyHashable : Any]) { error in
                self.handleNetworkError(error: error, errorMessage: "ユーザー情報の更新に失敗しました。")
            }
    }
    
    /// パスワードを更新
    /// - Parameters:
    ///   - password: パスワード
    /// - Returns: なし
    func updatePassword(password: String) {
        FirebaseManager.shared.auth.currentUser?.updatePassword(to: password) { error in
            self.handleNetworkError(error: error, errorMessage: "パスワードの更新に失敗しました。")
        }
    }
    
// MARK: - Delete
    
    /// ユーザー情報を削除
    /// - Parameters:
    ///   - document: ドキュメント
    /// - Returns: なし
    func deleteUsers(document: String) {
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.users)
            .document(document)
            .delete { error in
                self.handleNetworkError(error: error, errorMessage: String.failureDeleteData)
            }
    }
    
    /// メッセージを削除
    /// - Parameters:
    ///   - document: ドキュメント
    ///   - collection: コレクション
    /// - Returns: なし
    func deleteMessages(document: String, collection: String) {
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(document)
            .collection(collection)
            .getDocuments { snapshot, error in
                self.handleNetworkError(error: error, errorMessage: String.failureDeleteData)
                for document in snapshot!.documents {
                    document.reference.delete { error in
                        if error != nil {
                            self.handleError(String.failureDeleteData, error: error)
                            return
                        }
                    }
                }
            }
    }
    
    /// 最新メッセージを削除
    /// - Parameters:
    ///   - document1: ドキュメント1
    ///   - document2: ドキュメント2
    /// - Returns: なし
    func deleteRecentMessage(document1: String, document2: String) {
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(document1)
            .collection(FirebaseConstants.message)
            .document(document2)
            .delete { error in
                self.handleNetworkError(error: error, errorMessage: String.failureDeleteData)
            }
    }
    
    /// 友達情報を削除
    /// - Parameters:
    ///   - document1: ドキュメント1
    ///   - document2: ドキュメント2
    /// - Returns: なし
    func deleteFriend(document1: String, document2: String) {
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.friends)
            .document(document1)
            .collection(FirebaseConstants.user)
            .document(document2)
            .delete { error in
                self.handleNetworkError(error: error, errorMessage: String.failureDeleteData)
            }
    }
    
    /// 画像を削除
    /// - Parameters:
    ///   - withPath: 削除するパス
    /// - Returns: なし
    func deleteImage(withPath: String) {
        if let stringImage = currentUser?.profileImageUrl {
            // 画像が設定されていない場合、この処理をスキップする。
            if stringImage != "" {
                let ref = FirebaseManager.shared.storage.reference(withPath: withPath)
                ref.delete { error in
                    self.handleNetworkError(error: error, errorMessage: String.failureDeleteData)
                }
            }
        }
    }
    
    /// Auth削除
    /// - Parameters: なし
    /// - Returns: なし
    func deleteAuth() {
        FirebaseManager.shared.auth.currentUser?.delete { error in
            self.handleNetworkError(error: error, errorMessage: String.failureDeleteData)
        }
    }
}
