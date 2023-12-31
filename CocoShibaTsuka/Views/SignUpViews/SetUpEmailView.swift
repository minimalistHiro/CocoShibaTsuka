//
//  SetUpEmailView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/12/21.
//

import SwiftUI
import FirebaseAuth

struct SetUpEmailView: View {
    
    @FocusState var focus: Bool
//    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: ViewModel
    let didCompleteLoginProcess: () -> ()
//    @State private var link = ""                        // リンク
    @State private var isShowSendEmailAlert = false     // メール送信確認アラート
//    @State private var isSendEmail = false              // メール送信済みか否か
    @State private var isNavigateSetUpPasswordView = false  // パスワード設定画面の表示有無
    @State private var isShowCloseAlert = false         // 画面戻り確認アラート
    
    // DB
    @State private var email: String = ""               // メールアドレス
    @Binding var username: String
    @Binding var age: String
    @Binding var address: String
    @Binding var image: UIImage?
    
    var disabled: Bool {
        self.email.isEmpty
    }                                                   // ボタンの有効性
    
    init(username: Binding<String>,
         age: Binding<String>,
         address: Binding<String>,
         image: Binding<UIImage?>,
         didCompleteLoginProcess: @escaping () -> ())
    {
        self._username = username
        self._age = age
        self._address = address
        self._image = image
        self.didCompleteLoginProcess = didCompleteLoginProcess
        self.vm = .init(didCompleteLoginProcess: didCompleteLoginProcess)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                InputText.InputTextField(focus: $focus, editText: $email, titleText: "メールアドレス", isEmail: true)
                
                Spacer()
                
                Button {
                    sendSignUpLink(email: email)
                } label: {
                    CustomCapsule(text: "メール送信", imageSystemName: nil, foregroundColor: disabled ? .gray : .black, textColor: .white, isStroke: false)
                }
                .disabled(disabled)
                
                Spacer()
                Spacer()
            }
            // タップでキーボードを閉じるようにするため
            .contentShape(Rectangle())
            .onTapGesture {
                focus = false
            }
            .navigationTitle("メールアドレスを設定")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                ScaleEffectIndicator(onIndicator: $vm.onIndicator)
            }
            .navigationDestination(isPresented: $isNavigateSetUpPasswordView) {
                SetUpPasswordView(email: $email, username: $username, age: $age, address: $address, image: $image, didCompleteLoginProcess: didCompleteLoginProcess)
            }
        }
//        .onAppear {
//            email = UserDefaults.standard.value(forKey: "Email") as? String ?? ""
//            if let link = UserDefaults.standard.value(forKey: "Link") as? String {
//                self.link = link
//                isNavigateSetUpPasswordView = true
//            }
//        }
        .onOpenURL { url in
//            email = UserDefaults.standard.value(forKey: "Email") as? String ?? ""
//            
//            let link = url.absoluteString
            isNavigateSetUpPasswordView = true
            
//            if FirebaseManager.shared.auth.isSignIn(withEmailLink: link) {
//                passwordlessSignIn(email: email, link: link) { result in
//                    switch result {
//                    case let .success(user):
//                        isNavigateSetUpPasswordView = user?.isEmailVerified ?? falseｒ
//                    case let .failure(error):
//                        isNavigateSetUpPasswordView = false
//                        vm.handleNetworkError(error: error, errorMessage: "認証エラーが発生しました。")
//                    }
//                }
//            }
        }
        .asBackButton()
//        .asAlertBackButton {
//            // メールが送信済みの場合のみアラートを発動
//            if isSendEmail {
//                isShowCloseAlert = true
//            } else {
////                dismiss()
//            }
//        }
        .asSingleAlert(title: "",
                       isShowAlert: $vm.isShowError,
                       message: vm.errorMessage,
                       didAction: { vm.isShowError = false })
        .asSingleAlert(title: "",
                       isShowAlert: $isShowSendEmailAlert,
                       message: "入力したメールアドレスにパスワード設定用のURLを送信しました。",
                       didAction: {
            isShowSendEmailAlert = false
        })
        .asDestructiveAlert(title: "",
                            isShowAlert: $isShowCloseAlert,
                            message: "送信したメールリンクが無効になりますがよろしいですか？",
                            buttonText: "戻る") {
//            dismiss()
        }
    }
    
    /// 入力したメールアドレスにパスワード設定リンクを送る
    /// - Parameters:
    ///   - email: メールアドレス
    /// - Returns: なし
    private func sendSignUpLink(email: String) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://cocoshibatsuka.com/signin")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        FirebaseManager.shared.auth.sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            if let error = error as NSError?, let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    vm.handleError(String.invalidEmail, error: error)
                    return
                case .emailAlreadyInUse:
                    vm.handleError(String.emailAlreadyInUse, error: error)
                    return
                case .networkError:
                    vm.handleError(String.networkError, error: error)
                    return
                default:
                    vm.handleError(error.domain, error: error)
                    return
                }
            }
            isShowSendEmailAlert = true
//            UserDefaults.standard.setValue(email, forKey: "Email")
//            isSendEmail = true
        }
    }
    
//    private func passwordlessSignIn(email: String, link: String, completion: @escaping (Result<User?, Error>) -> Void) {
//        FirebaseManager.shared.auth.signIn(withEmail: email, link: link) { result, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription).")
//                completion(.failure(error))
//            } else {
//                completion(.success(result?.user))
//            }
//        }
//    }
}

#Preview {
    SetUpEmailView(username: .constant(String.previewUsername),
                   age: .constant(String.previewAge), 
                   address: .constant(String.previewAddress),
                   image: .constant(nil),
                   didCompleteLoginProcess: {})
}
