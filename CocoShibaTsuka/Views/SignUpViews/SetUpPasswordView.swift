//
//  SetUpPasswordView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/12/21.
//

import SwiftUI

struct SetUpPasswordView: View {
    
    @FocusState var focus: Bool
    @ObservedObject var vm: ViewModel
    let didCompleteLoginProcess: () -> ()
    @State private var isShowPassword = false           // パスワード表示有無
    
    // DB
    @State private var password: String = ""            // パスワード
    @State private var password2: String = ""           // 確認用パスワード
    @Binding var email: String
    @Binding var username: String
    @Binding var image: UIImage?
    
    var disabled: Bool {
        if !password.isEmpty {
            // パスワードが入力済みで、確認用パスワードと一致していた場合のみ押下可能。
            if password == password2 {
                return false
            }
        }
        return true
    }                                                   // ボタンの有効性
    
    init(email: Binding<String>, 
         username: Binding<String>,
         image: Binding<UIImage?>,
         didCompleteLoginProcess: @escaping () -> ())
    {
        self._email = email
        self._username = username
        self._image = image
        self.didCompleteLoginProcess = didCompleteLoginProcess
        self.vm = .init(didCompleteLoginProcess: didCompleteLoginProcess)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                InputText.InputPasswordTextField(focus: $focus, editText: $password, titleText: "パスワード", isShowPassword: $isShowPassword)
                    .padding(.bottom)
                
                InputText.InputPasswordTextField(focus: $focus, editText: $password2, titleText: "パスワード（確認用）", isShowPassword: $isShowPassword)
                    .padding(.bottom)
                
                Spacer()
                
                Button {
                    vm.createNewAccount(email: email, password: password, username: username, image: image)
                } label: {
                    CustomCapsule(text: "アカウントを作成", imageSystemName: nil, foregroundColor: disabled ? .gray : .black, textColor: .white, isStroke: false)
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
            .navigationTitle("パスワードを設定")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .overlay {
                ScaleEffectIndicator(onIndicator: $vm.onIndicator)
            }
        }
        .asSingleAlert(title: "",
                        isShowAlert: $vm.isShowError,
                        message: vm.errorMessage,
                        didAction: { vm.isShowError = false })
    }
}

#Preview {
    SetUpPasswordView(email: .constant("test@gmail.com"), username: .constant("test"), image: .constant(nil), didCompleteLoginProcess: {})
}
