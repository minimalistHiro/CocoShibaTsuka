//
//  CreateUsernameView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/12/10.
//

import SwiftUI

struct CreateUsernameView: View {
    
    @FocusState var focus: Bool
    @ObservedObject var vm: ViewModel
    let didCompleteLoginProcess: () -> ()
    
    // DB
    @Binding var email: String
    @Binding var password: String
    @Binding var image: UIImage?
    @State private var username: String = ""            // ユーザー名
    
    var disabled: Bool {
        self.email.isEmpty || self.password.isEmpty || self.username.isEmpty
    }                                                   // ボタンの有効性
    
    init(email: Binding<String>, password: Binding<String>, image: Binding<UIImage?>, didCompleteLoginProcess: @escaping () -> ()) {
        self._email = email
        self._password = password
        self._image = image
        self.didCompleteLoginProcess = didCompleteLoginProcess
        self.vm = .init(didCompleteLoginProcess: didCompleteLoginProcess)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                InputText.InputTextField(focus: $focus, editText: $username, titleText: "ユーザー名", isEmail: false)
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
            .navigationTitle("新規アカウントを作成")
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
    CreateUsernameView(email: .constant(""), password: .constant(""), image: .constant(nil), didCompleteLoginProcess: {})
}
