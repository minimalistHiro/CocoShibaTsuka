////
////  SetUpAddressView.swift
////  CocoShibaTsuka
////
////  Created by 金子広樹 on 2023/12/26.
////
//
//import SwiftUI
//
//struct SetUpAddressView: View {
//    
//    @FocusState var focus: Bool
//    @ObservedObject var vm: ViewModel
//    let didCompleteLoginProcess: () -> ()
//    
//    // DB
//    @State private var address: String = ""             // 住所
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Spacer()
//                
//                InputText.InputTextField(focus: $focus, editText: $email, titleText: "メールアドレス", isEmail: true)
//                    .padding(.bottom)
//                
//                Spacer()
//                
//                NavigationLink {
//                    SetUpUsernameView(didCompleteLoginProcess: didCompleteLoginProcess)
//                } label: {
//                    CustomCapsule(text: "次へ", imageSystemName: nil, foregroundColor: disabled ? .gray : .black, textColor: .white, isStroke: false)
//                }
//                .disabled(disabled)
//                
//                Spacer()
//                Spacer()
//            }
//            // タップでキーボードを閉じるようにするため
//            .contentShape(Rectangle())
//            .onTapGesture {
//                focus = false
//            }
//            .navigationTitle("新規アカウントを作成")
//            .navigationBarTitleDisplayMode(.inline)
//            .overlay {
//                ScaleEffectIndicator(onIndicator: $vm.onIndicator)
//            }
//        }
//    }
//}
//
//#Preview {
//    SetUpAddressView()
//}
