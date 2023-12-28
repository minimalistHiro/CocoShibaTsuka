//
//  SignUpView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/11/28.
//

import SwiftUI

struct SetUpUsernameView: View {
    
    @FocusState var focus: Bool
//    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: ViewModel
    let didCompleteLoginProcess: () -> ()
    @State private var isShowPassword = false           // パスワード表示有無
    @State private var isShowImagePicker = false        // ImagePicker表示有無
    @State private var isShowCloseAlert = false         // 新規作成中止確認アラート
    
    // DB
    @State private var username: String = ""            // ユーザー名
    @State private var image: UIImage?                  // トップ画像
    
    var disabled: Bool {
        self.username.isEmpty
    }                                                   // ボタンの有効性
    
    init(didCompleteLoginProcess: @escaping () -> ()) {
        self.didCompleteLoginProcess = didCompleteLoginProcess
        self.vm = .init(didCompleteLoginProcess: didCompleteLoginProcess)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // トップ画像
                Text("トップ画像（任意）")
                    .font(.callout)
                
                Button {
                    isShowImagePicker.toggle()
                } label: {
                    if let image = image {
                        Icon.CustomImage(imageSize: .large, image: image)
                            .padding()
                    } else {
                        Icon.CustomCircle(imageSize: .large)
                            .padding()
                    }
                }
                
                Spacer()
                
                InputText.InputTextField(focus: $focus, editText: $username, titleText: "ユーザー名", isEmail: false)
                    .padding(.bottom)
                
                Spacer()
                
                NavigationLink {
                    SetUpEmailView(username: $username, image: $image, didCompleteLoginProcess: didCompleteLoginProcess)
                } label: {
                    CustomCapsule(text: "次へ", imageSystemName: nil, foregroundColor: disabled ? .gray : .black, textColor: .white, isStroke: false)
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
        .fullScreenCover(isPresented: $isShowImagePicker) {
            ImagePicker(selectedImage: $image)
        }
        .asBackButton()
//        .asAlertBackButton {
//            isShowCloseAlert = true
//        }
        .asSingleAlert(title: "",
                       isShowAlert: $vm.isShowError,
                       message: vm.errorMessage,
                       didAction: { vm.isShowError = false })
//        .asDestructiveAlert(title: "",
//                            isShowAlert: $isShowCloseAlert,
//                            message: "新規アカウントの作成を中止しますか？",
//                            buttonText: "中止") {
////            dismiss()
//        }
    }
}

#Preview {
    SetUpUsernameView(didCompleteLoginProcess: {})
}
