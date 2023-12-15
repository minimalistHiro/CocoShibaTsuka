//
//  TextEditor.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/11/28.
//

import SwiftUI

struct InputText {
    static let shared = InputText()
    
    // 各種サイズ
    class Size {
        static let textPaddingLeading: CGFloat = 50
        static let textFieldPaddingTop: CGFloat = 16
        static let textFieldPaddingHeight: CGFloat = 25
        static let imagePaddingTrailing: CGFloat = 30
        static let rectangleFrameHeight: CGFloat = 2
        static let rectanglePaddingVertical: CGFloat = 8
        static let rectanglePaddingHorizontal: CGFloat = 25
    }
    
    let maxEmailTextFieldCount = 40             // メールアドレス最大文字数
    let maxUsernameTextFieldCount = 15          // ユーザーネーム最大文字数
    let maxPasswordTextFieldCount = 30          // パスワード最大文字数
    
    struct InputTextField: View {
        
        var focus: FocusState<Bool>.Binding
        @Binding var editText: String
        let titleText: String
        let isEmail: Bool
        var maxTextCount: Int {
            if isEmail {
                InputText.shared.maxEmailTextFieldCount
            } else {
                InputText.shared.maxUsernameTextFieldCount
            }
        }
        
        var body: some View {
            VStack {
                Text(titleText)
                    .font(.caption)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, Size.textPaddingLeading)
                TextField("", text: $editText)
                    .focused(focus.projectedValue)
                    .keyboardType(isEmail ? .emailAddress : .default)
                    .padding(.top, Size.textFieldPaddingTop)
                    .padding(.horizontal, Size.textFieldPaddingHeight)
                    .onChange(of: editText, perform: { value in
                        // 最大文字数に達したら、それ以上書き込めないようにする
                        if value.count > maxTextCount {
                            editText.removeLast(editText.count - maxTextCount)
                        }
                    })
                Rectangle()
                    .foregroundColor(.black)
                    .frame(height: Size.rectangleFrameHeight)
                    .padding(.vertical, Size.rectanglePaddingVertical)
                    .padding(.horizontal, Size.rectanglePaddingHorizontal)
            }
        }
    }

    struct InputPasswordTextField: View {
        
        var focus: FocusState<Bool>.Binding
        @Binding var editText: String
        let titleText: String
        @Binding var isShowPassword: Bool
        
        var body: some View {
            VStack {
                Text(titleText)
                    .font(.caption)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, Size.textPaddingLeading)
                HStack {
                    if isShowPassword {
                        TextField("", text: $editText)
                            .focused(focus.projectedValue)
                            .keyboardType(.URL)
                            .padding(.top, Size.textFieldPaddingTop)
                            .padding(.horizontal, Size.textFieldPaddingHeight)
                            .onChange(of: editText, perform: { value in
                                // 最大文字数に達したら、それ以上書き込めないようにする
                                if value.count > InputText.shared.maxPasswordTextFieldCount {
                                    editText.removeLast(editText.count - InputText.shared.maxPasswordTextFieldCount)
                                }
                            })
                    } else {
                        SecureField("", text: $editText)
                            .focused(focus.projectedValue)
                            .keyboardType(.URL)
                            .padding(.top, Size.textFieldPaddingTop)
                            .padding(.horizontal, Size.textFieldPaddingHeight)
                            .onChange(of: editText, perform: { value in
                                // 最大文字数に達したら、それ以上書き込めないようにする
                                if value.count > InputText.shared.maxPasswordTextFieldCount {
                                    editText.removeLast(editText.count - InputText.shared.maxPasswordTextFieldCount)
                                }
                            })
                    }
                    Button {
                        isShowPassword.toggle()
                    } label: {
                        Image(systemName: isShowPassword ? "eye.fill" : "eye.slash.fill")
                            .padding(.trailing, Size.imagePaddingTrailing)
                            .foregroundColor(.black)
                    }
                }
                Rectangle()
                    .foregroundColor(.black)
                    .frame(height: Size.rectangleFrameHeight)
                    .padding(.vertical, Size.rectanglePaddingVertical)
                    .padding(.horizontal, Size.rectanglePaddingHorizontal)
            }
        }
    }
}

//#Preview {
//    InputText.InputTextFiexld(editText: .constant("test@gmail.com"),
//                             titleText: "メールアドレス", isEmail: true)
//}
//
//#Preview {
//    InputText.InputPasswordTextField(focus: false, editText: .constant("123456"),
//                      titleText: "パスワード",
//                      isShowPassword: .constant(true))
//}
