////
////  ContentViewModel.swift
////  CocoShibaTsuka
////
////  Created by 金子広樹 on 2023/11/20.
////
//
//import SwiftUI
//import FirebaseFirestore
//import FirebaseCore
//
//class ContentViewModel: ObservableObject {
//    
//    @Published var currentUser: ChatUser?                       // 現在のユーザー
//    @Published var chatUser: ChatUser?                          // トーク相手ユーザー
//    @Published var recentMessages = [RecentMessage]()           // 全最新メッセージ
//    @Published var chatMessages = [ChatMessage]()               // 全メッセージ
//    @Published var users = [ChatUser]()                         // 全ユーザー
//    @Published var resultUsers = [ChatUser]()                   // 検索に一致したユーザー名
//    @Published var isUserCurrentryLoggedOut = false             // ユーザーのログインの有無
//    @Published var searchText = ""                              // 検索テキスト
//    @Published var errorMessage = ""                            // エラーメッセージ
//    @Published var isShowError = false                          // エラー表示有無
//    @Published var chatText = ""                                // ユーザーの入力テキスト
//    @Published var count = 0                                    // 新規メッセージを取得した時を検出するカウンター変数
//    @Published var lastText = ""                                // 一時保存用最新メッセージ
//    @Published var isSendPay = false                            // 送金処理をしたか否か
//    @Published var sendPayText = "0"                            // 送金テキスト
//    @Published var inputs: Inputs = .tappedAC                   // ボタン押下実行処理
//    private var firestoreListner: ListenerRegistration?
//    let keyboard = ["7", "8", "9", "4", "5", "6", "1", "2", "3", "0", "00", "AC"]
//    
//    init() {
//        DispatchQueue.main.async {
//            self.isUserCurrentryLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
//        }
//        if FirebaseManager.shared.auth.currentUser?.uid != nil {
//            fetchCurrentUser()
//            fetchRecentMessages()
//        }
//    }
//    
//    init(chatUser: ChatUser?) {
//        self.chatUser = chatUser
//        if FirebaseManager.shared.auth.currentUser?.uid != nil {
//            fetchCurrentUser()
//            fetchRecentMessages()
//            fetchMessages()
//        }
//    }
//    
//    // 入力ステータス
//    enum Inputs {
//        case tappedAC                   // キーボード（"AC"）
//        case tappedNumberPad            // キーボード（数字）
//    }
//    
//    // MARK: - キーボード入力から実行処理を分配する
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
//    
//    // MARK: - ユーザー情報を取得
//    /// - Parameters: なし
//    /// - Returns: なし
//    func fetchCurrentUser() {
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
//            self.handleError("UIDの取得に失敗しました。")
//            return
//        }
//        
//        FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.users)
//            .document(uid)
//            .getDocument { snapshot, error in
//                if error != nil {
//                    self.handleError("ユーザー情報の取得に失敗しました。")
//                    return
//                }
//                
//                guard let data = snapshot?.data() else {
//                    self.handleError("データが見つかりませんでした。")
//                    return
//                }
//                self.currentUser = .init(data: data)
//            }
//    }
//    
//    // MARK: - 最新メッセージを取得
//    /// - Parameters: なし
//    /// - Returns: なし
//    func fetchRecentMessages() {
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        
//        firestoreListner?.remove()
//        self.recentMessages.removeAll()
//        
//        firestoreListner = FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.recentMessages)
//            .document(uid)
//            .collection(FirebaseConstants.message)
//            .order(by: FirebaseConstants.timestamp)
//            .addSnapshotListener { querySnapshot, error in
//                if error != nil {
//                    self.handleError("最新メッセージの取得に失敗しました。")
//                    return
//                }
//                
//                querySnapshot?.documentChanges.forEach({ change in
//                    let docId = change.document.documentID
//                    
//                    if let index = self.recentMessages.firstIndex(where: { rm in
//                        return rm.id == docId
//                    }) {
//                        self.recentMessages.remove(at: index)
//                    }
//                    
//                    do {
//                        let rm = try change.document.data(as: RecentMessage.self)
//                        self.recentMessages.insert(rm, at: 0)
//                    } catch {
//                        self.handleError("データが見つかりませんでした。")
//                        return
//                    }
//                })
//            }
//    }
//    
//    // MARK: - メッセージを取得
//    /// - Parameters: なし
//    /// - Returns: なし
//    func fetchMessages() {
//        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        guard let toId = chatUser?.uid else { return }
//        
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
//                    self.handleError("メッセージの取得に失敗しました。")
//                    return
//                }
//                
//                querySnapshot?.documentChanges.forEach({ change in
//                    if change.type == .added {
//                        do {
//                            let cm = try change.document.data(as: ChatMessage.self)
//                            self.chatMessages.append(cm)
//                        } catch {
//                            self.handleError("データが見つかりませんでした。")
//                            return
//                        }
//                    }
//                })
//                DispatchQueue.main.async {
//                    self.count += 1
//                }
//            }
//    }
//    
//    // MARK: - 全ユーザーを取得
//    /// - Parameters: なし
//    /// - Returns: なし
//    func fetchAllUsers() {
//        FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.users)
//            .getDocuments { documentsSnapshot, error in
//            if error != nil {
//                self.handleError("全ユーザーの取得に失敗しました。")
//                return
//            }
//            
//            documentsSnapshot?.documents.forEach({ snapshot in
//                let data = snapshot.data()
//                let user = ChatUser(data: data)
//                
//                // 追加するユーザーが自分以外の場合のみ、追加する。
//                if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
//                    self.users.append(.init(data: data))
//                }
//            })
//        }
//    }
//    
//    // MARK: - 検索に一致した名前を取得
//    /// - Parameters: なし
//    /// - Returns: なし
//    func fetchSearchNames() {
//        resultUsers = []
//        
//        if searchText.isEmpty {
//            resultUsers = []
//        } else if recentMessages == [] {
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
//            let recentMessageId = recentMessages.map {
//                FirebaseManager.shared.auth.currentUser?.uid == $0.fromId ? $0.toId : $0.fromId
//            }
//            
//            // 最新メッセージを取得した相手を省く。
//            resultUsers = filteredUsers.filter {
//                !recentMessageId.contains($0.uid)
//            }
//        }
//    }
//    
//    // MARK: - テキスト送信処理
//    /// - Parameters: なし
//    /// - Returns: なし
//    func handleSend() {
//        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        guard let toId = chatUser?.uid else { return }
//        
//        let messageData = [FirebaseConstants.fromId: fromId,
//                           FirebaseConstants.toId: toId,
//                           FirebaseConstants.text: (isSendPay ? lastText : chatText),
//                           FirebaseConstants.isSendPay: isSendPay,
//                           FirebaseConstants.timestamp:
//                            Timestamp()] as [String : Any]
//        
//        // 自身のメッセージデータを保存
//        let document = FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.messages)
//            .document(fromId)
//            .collection(toId)
//            .document()
//        
//        document.setData(messageData) { error in
//            if error != nil {
//                self.handleError("メッセージの保存に失敗しました。")
//                return
//            }
//        }
//        
//        // トーク相手のメッセージデータを保存
//        let recipientMessageDocument = FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.messages)
//            .document(toId)
//            .collection(fromId)
//            .document()
//        
//        recipientMessageDocument.setData(messageData) { error in
//            if error != nil {
//                self.handleError("メッセージの保存に失敗しました。")
//                return
//            }
//        }
//        
//        // 送金処理以外（通常テキスト送信）の場合のみ実行
//        if !isSendPay {
//            self.lastText = chatText
//            self.chatText = ""
//        }
//        
//        // 自身のメッセージデータを保存
//        guard let chatUser = chatUser else { return }
//        persistRecentMessage(user: chatUser, fromId: fromId, toId: toId, isSelf: true)
//        
//        // トーク相手のメッセージデータを保存
//        guard let currentUser = currentUser else { return }
//        persistRecentMessage(user: currentUser, fromId: fromId, toId: toId, isSelf: false)
//    }
//    
//    // MARK: - 送金処理
//    /// - Parameters: なし
//    /// - Returns: なし
//    func handleSendPay() {
//        guard let chatUser = chatUser else { return }
//        guard let currentUser = currentUser else { return }
//        
//        guard let chatUserMoney = Int(chatUser.money),
//              let currentUserMoney = Int(currentUser.money),
//              let sendPayText = Int(sendPayText) else {
//            self.handleError("送金エラーが発生しました。")
//            return
//        }
//        
//        print("相手情報\(chatUser)")
//        print("自分\(currentUser.username) + \(currentUser.money)")
//        print("相手\(chatUser.username) + \(chatUser.money)")
//        
//        // TODO: - 送金処理を実行して確認
//        
//        // 各ユーザーの残高を計算
//        let calculatedChatUserMoney = chatUserMoney + sendPayText
//        let calculatedCurrentUserMoney = currentUserMoney - sendPayText
//        
//        // 各ユーザーの残高が0以下の場合、アラートを発動
//        if (calculatedChatUserMoney < 0) || (calculatedCurrentUserMoney < 0) {
//            self.handleError("入力数値が残ポイントを超えています。")
//            return
//        }
//        
//        // 送金相手のデータを更新
//        let chatUserData = [FirebaseConstants.money: String(calculatedChatUserMoney),]
//        updateUsers(document: chatUser.uid, data: chatUserData)
//        
////        FirebaseManager.shared.firestore
////            .collection(FirebaseConstants.users)
////            .document(chatUser.uid)
////            .updateData(chatUserData as [AnyHashable : Any]) { error in
////                if error != nil {
////                    self.handleError("ユーザー情報の更新に失敗しました。")
////                    return
////                }
////            }
//        
//        // 自身のデータを更新
//        let userData = [FirebaseConstants.money: String(calculatedCurrentUserMoney),]
//        updateUsers(document: currentUser.uid, data: userData)
//        
////        FirebaseManager.shared.firestore
////            .collection(FirebaseConstants.users)
////            .document(currentUser.uid)
////            .updateData(userData as [AnyHashable : Any]) { error in
////                if error != nil {
////                    self.handleError("ユーザー情報の更新に失敗しました。")
////                    return
////                }
////            }
//    }
//    
//    // MARK: - 最新メッセージを保存
//    /// - Parameters:
//    ///   - user: トーク相手のデータ
//    ///   - fromId: 送信者UID
//    ///   - toId: 受信者UID
//    ///   - isSelf: 自身のデータか否か
//    /// - Returns: なし
//    private func persistRecentMessage(user: ChatUser, fromId: String, toId: String, isSelf: Bool) {
//        let document: DocumentReference
//        
//        // 自身のデータか、トーク相手のデータかでドキュメントを変える。
//        if isSelf {
//            document = FirebaseManager.shared.firestore
//                .collection(FirebaseConstants.recentMessages)
//                .document(fromId)
//                .collection(FirebaseConstants.message)
//                .document(toId)
//        } else {
//            document = FirebaseManager.shared.firestore
//                .collection(FirebaseConstants.recentMessages)
//                .document(toId)
//                .collection(FirebaseConstants.message)
//                .document(fromId)
//        }
//        
//        let data = [
//            FirebaseConstants.email: user.email,
//            FirebaseConstants.text: lastText,
//            FirebaseConstants.fromId: fromId,
//            FirebaseConstants.toId: toId,
//            FirebaseConstants.profileImageUrl: user.profileImageUrl,
//            FirebaseConstants.isSendPay: isSendPay,
//            FirebaseConstants.username: user.username,
//            FirebaseConstants.timestamp: Timestamp(),
//        ] as [String : Any]
//        
//        document.setData(data) { error in
//            if error != nil {
//                self.handleError("最新メッセージの保存に失敗しました。")
//                return
//            }
//        }
//    }
//    
//    // MARK: - サインアウト
//    /// - Parameters: なし
//    /// - Returns: なし
//    func handleSignOut() {
//        isUserCurrentryLoggedOut = true
//        try? FirebaseManager.shared.auth.signOut()
//    }
//    
//    // MARK: - 最新メッセージ、メッセージを削除
//    /// - Parameters: なし
//    /// - Returns: なし
//    func deleteRecentMessageAndMessages(toId: String) {
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        
//        // 最新メッセージを削除
//        deleteRecentMessage(document1: uid, document2: toId)
//        
//        // メッセージを削除
//        deleteMessages(document: uid, collection: toId)
//    }
//    
//    // MARK: - 退会
//    /// - Parameters: なし
//    /// - Returns: なし
//    func handleWithdrawal() {
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        
//        // ユーザー情報削除
//        deleteUsers(document: uid)
//        
//        // メッセージを削除
//        for recentMessage in recentMessages {
//            deleteMessages(document: uid, collection: FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId)
//        }
//        
//        // 最新メッセージを削除
//        for recentMessage in recentMessages {
//            deleteRecentMessage(document1: uid, document2: FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId)
//        }
//        
//        // 画像削除
//        deleteImage(withPath: uid)
//        
//        // Auth削除
//        deleteAuth()
//    }
//    
//    // MARK: - ユーザー情報を更新
//    /// - Parameters:
//    ///   - documentd: ドキュメント
//    ///   - data: データ
//    /// - Returns: なし
//    private func updateUsers(document: String, data: [String: String]) {
//        FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.users)
//            .document(document)
//            .updateData(data as [AnyHashable : Any]) { error in
//                if error != nil {
//                    self.handleError("ユーザー情報の更新に失敗しました。")
//                    return
//                }
//            }
//    }
//    
//    // MARK: - ユーザー情報を削除
//    /// - Parameters:
//    ///   - documentd: ドキュメント
//    /// - Returns: なし
//    private func deleteUsers(document: String) {
//        FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.users)
//            .document(document)
//            .delete { error in
//                if error != nil {
//                    self.handleError("データ削除に失敗しました。")
//                    return
//                }
//            }
//    }
//    
//    // MARK: - メッセージを削除
//    /// - Parameters:
//    ///   - document: ドキュメント
//    ///   - collection: コレクション
//    /// - Returns: なし
//    private func deleteMessages(document: String, collection: String) {
//        FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.messages)
//            .document(document)
//            .collection(collection)
//            .getDocuments { snapshot, error in
//                if error != nil {
//                    self.handleError("メッセージの取得に失敗しました。")
//                    return
//                }
//                for document in snapshot!.documents {
//                    document.reference.delete { error in
//                        if error != nil {
//                            self.handleError("データ削除に失敗しました。")
//                            return
//                        }
//                    }
//                }
//            }
//    }
//    
//    // MARK: - 最新メッセージを削除
//    /// - Parameters:
//    ///   - document1: ドキュメント1
//    ///   - document2: ドキュメント2
//    /// - Returns: なし
//    private func deleteRecentMessage(document1: String, document2: String) {
//        FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.recentMessages)
//            .document(document1)
//            .collection(FirebaseConstants.message)
//            .document(document2)
//            .delete { error in
//                if error != nil {
//                    self.handleError("データ削除に失敗しました。")
//                    return
//                }
//            }
//    }
//    
//    // MARK: - 画像を削除
//    /// - Parameters:
//    ///   - withPath: 削除するパス
//    /// - Returns: なし
//    private func deleteImage(withPath: String) {
//        if let stringImage = currentUser?.profileImageUrl {
//            // 画像が設定されていない場合、この処理をスキップする。
//            if stringImage != "" {
//                let ref = FirebaseManager.shared.storage.reference(withPath: withPath)
//                ref.delete { error in
//                    if error != nil {
//                        self.handleError("データ削除に失敗しました。")
//                        return
//                    }
//                }
//            }
//        }
//    }
//    
//    // MARK: - Auth削除
//    /// - Parameters: なし
//    /// - Returns: なし
//    private func deleteAuth() {
//        FirebaseManager.shared.auth.currentUser?.delete { error in
//            if error != nil {
//                self.handleError("データ削除に失敗しました。")
//                return
//            }
//        }
//    }
//    
//    // MARK: - 数字キーボード実行処理
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
//    // MARK: - 計算結果がテキスト最大文字数を超えているかをチェックする。
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
//    // MARK: - エラー処理
//    /// - Parameters:
//    ///   - errorMessage: エラーメッセージ
//    /// - Returns: なし
//    private func handleError(_ errorMessage: String) {
//        self.errorMessage = errorMessage
//        self.isShowError = true
//        print(self.errorMessage)
//    }
//    
//    // MARK: - StringをUIImageに変換する
//    /// - Parameters:
//    ///   - imageString: 画像データの文字列
//    /// - Returns: UIImage
//    //    private func stringToUIImage(imageString: String) -> UIImage? {
//    //        //空白を+に変換する
//    //        var base64String = imageString.replacingOccurrences(of: " ", with: "+")
//    //
//    //        //BASE64の文字列をデコードしてNSDataを生成
//    //        let decodeBase64:NSData? = NSData(base64Encoded:base64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
//    //
//    //        //NSDataの生成が成功していたら
//    //        if let decodeSuccess = decodeBase64 {
//    //            //NSDataからUIImageを生成
//    //            let img = UIImage(data: decodeSuccess as Data)
//    //            //結果を返却
//    //            return img
//    //        }
//    //        return nil
//    //    }
//    
//    // MARK: - 最新のメッセージを保存
//    /// - Parameters: なし
//    /// - Returns: なし
//    //    func persistRecentMessage() {
//    //        guard let chatUser = chatUser else { return }
//    //        guard let currentUser = currentUser else { return }
//    //
//    //        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//    //        guard let toId = self.chatUser?.uid else { return }
//    //
//    //        // 自身のメッセージデータを保存
//    //        let document = FirebaseManager.shared.firestore
//    //            .collection(FirebaseConstants.recentMessages)
//    //            .document(uid)
//    //            .collection(FirebaseConstants.message)
//    //            .document(toId)
//    //
//    //        let data = [
//    //            FirebaseConstants.email: chatUser.email,
//    //            FirebaseConstants.text: self.lastText,
//    //            FirebaseConstants.fromId: uid,
//    //            FirebaseConstants.toId: toId,
//    //            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
//    //            FirebaseConstants.isSendPay: isSendPay,
//    //            FirebaseConstants.username: chatUser.username,
//    //            FirebaseConstants.timestamp: Timestamp(),
//    //        ] as [String : Any]
//    //
//    //        document.setData(data) { error in
//    //            if error != nil {
//    //                self.errorMessage = "最新メッセージの保存に失敗しました。"
//    //                self.isShowError = true
//    //                print(self.errorMessage)
//    //                return
//    //            }
//    //        }
//    //
//    //        // トーク相手のメッセージデータを保存
//    //        let recipientDocument = FirebaseManager.shared.firestore
//    //            .collection(FirebaseConstants.recentMessages)
//    //            .document(toId)
//    //            .collection(FirebaseConstants.message)
//    //            .document(uid)
//    //
//    //        let recipientData = [
//    //            FirebaseConstants.email: currentUser.email,
//    //            FirebaseConstants.text: self.lastText,
//    //            FirebaseConstants.fromId: uid,
//    //            FirebaseConstants.toId: toId,
//    //            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
//    //            FirebaseConstants.isSendPay: isSendPay,
//    //            FirebaseConstants.username: currentUser.username,
//    //            FirebaseConstants.timestamp: Timestamp(),
//    //        ] as [String : Any]
//    //
//    //        recipientDocument.setData(recipientData) { error in
//    //            if error != nil {
//    //                self.errorMessage = "最新メッセージの保存に失敗しました。"
//    //                self.isShowError = true
//    //                print(self.errorMessage)
//    //                return
//    //            }
//    //        }
//    //    }
//}
