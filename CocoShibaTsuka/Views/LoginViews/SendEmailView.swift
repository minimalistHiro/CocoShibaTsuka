//
//  SendEmailView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/12/27.
//

import SwiftUI

struct SendEmailView: View {
    
    @FocusState var focus: Bool
    @ObservedObject var vm: ViewModel
    let didCompleteLoginProcess: () -> ()
    @State private var isShowSendEmailAlert = false     // メール送信確認アラート
    @State private var isNavigateSetUpPasswordView = false  // パスワード設定画面の表示有無
    
    // DB
    @State private var email: String = ""               // メールアドレス
    
    var disabled: Bool {
        self.email.isEmpty
    }                                                   // ボタンの有効性
    
    init(didCompleteLoginProcess: @escaping () -> ()) {
        self.didCompleteLoginProcess = didCompleteLoginProcess
        self.vm = .init(didCompleteLoginProcess: didCompleteLoginProcess)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                InputText.InputTextField(focus: $focus, editText: $email, titleText: "メールアドレス", isEmail: true)
                    .padding(.bottom)
                
                Spacer()
                
                Button {
                    sendResetPasswordLink(email: email)
                    isShowSendEmailAlert = true
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
            .navigationTitle("メールアドレスを入力")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                ScaleEffectIndicator(onIndicator: $vm.onIndicator)
            }
            .navigationDestination(isPresented: $isNavigateSetUpPasswordView) {
                ResetPasswordView()
            }
        }
        .asBackButton()
        .onOpenURL { url in
            isNavigateSetUpPasswordView = true
        }
        .asSingleAlert(title: "",
                       isShowAlert: $vm.isShowError,
                       message: vm.errorMessage,
                       didAction: { vm.isShowError = false })
        .asSingleAlert(title: "",
                       isShowAlert: $isShowSendEmailAlert,
                       message: "入力したメールアドレスにパスワード再設定用のURLを送信しました。",
                       didAction: {
            isShowSendEmailAlert = false
        })
    }
    
    /// 入力したメールアドレスにパスワード再設定リンクを送る
    /// - Parameters:
    ///   - email: メールアドレス
    /// - Returns: なし
    private func sendResetPasswordLink(email: String) {
        FirebaseManager.shared.auth.sendPasswordReset(withEmail: email) { error in
            vm.handleNetworkError(error: error, errorMessage: "リンクの送信に失敗しました。")
        }
    }
}

#Preview {
    SendEmailView(didCompleteLoginProcess: {})
}
