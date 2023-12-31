//
//  LoginView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/12/09.
//

import SwiftUI

struct LoginView: View {
    
    @FocusState var focus: Bool
    @ObservedObject var vm: ViewModel
    let didCompleteLoginProcess: () -> ()
    @State private var isShowPassword = false                   // パスワード表示有無
    
    // DB
    @State private var email: String = ""               // メールアドレス
    @State private var password: String = ""            // パスワード
    
    var disabled: Bool {
        self.email.isEmpty || self.password.isEmpty
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
                
                InputText.InputPasswordTextField(focus: $focus, editText: $password, titleText: "パスワード", isShowPassword: $isShowPassword)
                
                Spacer()
                
                Button {
                    vm.handleLogin(email: email, password: password)
                } label: {
                    CustomCapsule(text: "ログイン", imageSystemName: nil, foregroundColor: disabled ? .gray : .black, textColor: .white, isStroke: false)
                }
                .disabled(disabled)
                
                Spacer()
                
                NavigationLink {
                    SendEmailView(didCompleteLoginProcess: didCompleteLoginProcess)
                } label: {
                    Text("パスワードを忘れた方はこちら")
                        .foregroundStyle(.blue)
                }
                
                Spacer()
            }
            // タップでキーボードを閉じるようにするため
            .contentShape(Rectangle())
            .onTapGesture {
                focus = false
            }
            .navigationTitle("ログイン")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                ScaleEffectIndicator(onIndicator: $vm.onIndicator)
            }
        }
        .asBackButton()
        .asSingleAlert(title: "",
                       isShowAlert: $vm.isShowError,
                       message: vm.errorMessage,
                       didAction: { vm.isShowError = false })
    }
}

#Preview {
    LoginView(didCompleteLoginProcess: {})
}
