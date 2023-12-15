////
////  LoginViewModel.swift
////  CocoShibaTsuka
////
////  Created by 金子広樹 on 2023/11/21.
////
//
//import SwiftUI
//import FirebaseFirestore
//import FirebaseAuth
//
//class LoginViewModel: ObservableObject {
//    
//    @Published var isLoginMode = true                       // ログインモード
//    @Published var shouldShowImagePicker = false            // ImagePickerの表示有無
//    @Published var errorMessage = ""                        // エラーメッセージ
//    @Published var isShowError = false                      // エラー表示有無
//    let didCompleteLoginProcess: () -> ()
//    
//    // DB
//    @Published var email: String = ""                       // メールアドレス
//    @Published var password: String = ""                    // パスワード
//    @Published var image: UIImage?                          // トップ画像
//    
//    init(didCompleteLoginProcess: @escaping () -> ()) {
//        self.didCompleteLoginProcess = didCompleteLoginProcess
//    }
//    
//    /// ログインモードによって実行処理を変える
//    /// - Parameters: なし
//    /// - Returns: なし
////    func handleAction() {
////        if isLoginMode {
////            loginUser()
////        } else {
////            createNewAccount()
////        }
////    }
//    
////    /// ログイン
////    /// - Parameters: なし
////    /// - Returns: なし
////    private func loginUser() {
////        // メールアドレス、パスワードどちらかが空白の場合、エラーを出す。
////        if email.isEmpty || password.isEmpty {
//////            self.isShowEmptyError = true
////            self.errorMessage = "メールアドレス、パスワードを入力してください。"
////            self.isShowError = true
////            print(self.errorMessage)
////            return
////        }
////        
////        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
////            if let error = error as NSError?, let errorCode = AuthErrorCode.Code(rawValue: error.code) {
////                switch errorCode {
////                case .invalidEmail:
////                    self.errorMessage = "メールアドレスの形式が正しくありません。"
////                    self.isShowError = true
////                    print(self.errorMessage)
////                    return
////                case .userNotFound, .wrongPassword:
////                    self.errorMessage = "メールアドレス、またはパスワードが間違っています。"
////                    self.isShowError = true
////                    print(self.errorMessage)
////                    return
////                case .userDisabled:
////                    self.errorMessage = "このユーザーアカウントは無効化されています。"
////                    self.isShowError = true
////                    print(self.errorMessage)
////                    return
////                case .networkError:
////                    self.errorMessage = "通信エラーが発生しました。"
////                    self.isShowError = true
////                    print(self.errorMessage)
////                    return
////                default:
////                    self.errorMessage = error.domain
////                    self.isShowError = true
////                    print(self.errorMessage)
////                    return
////                }
////            }
////            self.didCompleteLoginProcess()
////        }
////    }
//    
////    /// 新規作成
////    /// - Parameters: なし
////    /// - Returns: なし
////    private func createNewAccount() {
////        // メールアドレス、パスワードどちらかが空白の場合、エラーを出す。
////        if email.isEmpty || password.isEmpty {
////            self.errorMessage = "メールアドレス、パスワードを入力してください。"
////            self.isShowError = true
////            print(self.errorMessage)
////            return
////        }
////        
////        // パスワードの文字数が足りない時にエラーを発動。
//////        if password.count < Setting.minPasswordOfDigits {
//////            self.isShowPasswordOfDigitsError = true
//////            return
//////        }
////        
////        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
////            if let error = error as NSError?, let errorCode = AuthErrorCode.Code(rawValue: error.code) {
////                switch errorCode {
////                case .invalidEmail:
////                    self.errorMessage = "メールアドレスの形式が正しくありません。"
////                    self.isShowError = true
////                    print(self.errorMessage)
////                    return
////                case .weakPassword:
////                    self.errorMessage = "パスワードは6文字以上で設定してください。"
////                    self.isShowError = true
////                    print(self.errorMessage)
////                    return
////                case .emailAlreadyInUse:
////                    self.errorMessage = "このメールアドレスはすでに登録されています。"
////                    self.isShowError = true
////                    print(self.errorMessage)
////                    return
////                case .networkError:
////                    self.errorMessage = "通信エラーが発生しました。"
////                    self.isShowError = true
////                    print(self.errorMessage)
////                    return
////                default:
////                    self.errorMessage = error.domain
////                    self.isShowError = true
////                    print(self.errorMessage)
////                    return
////                }
////            }
////            
////            if self.image == nil {
////                self.storeUserInformation(imageProfileUrl: nil)
////            } else {
////                self.persistImageToStorage()
////            }
////        }
////    }
//    
////    /// DBに画像を保存する
////    /// - Parameters: なし
////    /// - Returns: なし
////    private func persistImageToStorage() {
////        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
////        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
////        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
////        
////        ref.putData(imageData, metadata: nil) { metadata, error in
////            if error != nil {
////                self.errorMessage = "画像の保存に失敗しました。"
////                self.isShowError = true
////                print(self.errorMessage)
////                return
////            }
////            
////            // Firestore Databaseに保存するためにURLをダウンロードする。
////            ref.downloadURL { url, error in
////                if error != nil {
////                    self.errorMessage = "画像URLの取得に失敗しました。"
////                    self.isShowError = true
////                    print(self.errorMessage)
////                    return
////                }
////                guard let url = url else { return }
////                self.storeUserInformation(imageProfileUrl: url)
////            }
////        }
////    }
//    
////    /// ユーザー情報をDBに保存する
////    /// - Parameters: なし
////    /// - Returns: なし
////    private func storeUserInformation(imageProfileUrl: URL?) {
////        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
////        let userData = [FirebaseConstants.uid : uid,
////                        FirebaseConstants.email: email,
////                        FirebaseConstants.profileImageUrl: imageProfileUrl?.absoluteString ?? "",
////                        FirebaseConstants.money: Setting.newRegistrationBenefits,
////                        FirebaseConstants.username: email,
////        ] as [String : Any]
////        
////        FirebaseManager.shared.firestore
////            .collection(FirebaseConstants.users)
////            .document(uid)
////            .setData(userData) { error in
////                if error != nil {
////                self.errorMessage = "ユーザー情報の保存に失敗しました。"
////                self.isShowError = true
////                print(self.errorMessage)
////                return
////            }
////            
////            self.didCompleteLoginProcess()
////        }
////    }
//}
