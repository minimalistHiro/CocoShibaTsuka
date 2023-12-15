////
////  EditEmailView.swift
////  CocoShibaTsuka
////
////  Created by 金子広樹 on 2023/11/05.
////
//
//import SwiftUI
//
//struct EditEmailView: View {
//    
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var vm = ContentViewModel()
//    @State var email: String
//    @State private var isShowAlert = false
//    @State private var isShowError = false
//    
////    init(email: String) {
////        self.email = email
////    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading) {
//                Spacer()
//                
//                Text("メールアドレス")
//                    .font(.caption2)
//                    .foregroundStyle(.gray)
//                    .padding(.horizontal)
//                    .padding(.horizontal)
//                TextField("メールアドレス", text: $email)
//                    .font(.title3)
//                    .padding()
//                    .padding(.horizontal)
//                Rectangle()
//                    .fill(.black)
//                    .frame(height: 2)
//                    .padding(.horizontal)
//                    .padding(.horizontal)
//                
//                Spacer()
//                
//                Button {
//                    updateEmail(email: email)
//                    if !isShowError {
//                        isShowAlert = true
//                    }
//                } label: {
//                    Capsule()
//                        .foregroundStyle(Color.blue)
//                        .frame(height: 50)
//                        .overlay(alignment: .center) {
//                            Text("変更")
//                                .foregroundColor(.white)
//                                .padding(.vertical, 10)
//                                .font(.title3)
//                                .bold()
//                        }
//                        .padding(.horizontal)
//                }
//                
//                Spacer()
//                Spacer()
//                Spacer()
//            }
//            .navigationTitle("メールアドレスの変更")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//        .asBackButton()
//        .asSingleAlert(title: "",
//                       isShowAlert: $isShowAlert,
//                       message: "変更を保存しました。",
//                       didAction: {
////            dismiss()
//        })
//        .asSingleAlert(title: "",
//                       isShowAlert: $isShowError,
//                       message: "メールアドレスの書式が異なる可能性があります。",
//                       didAction: {})
//    }
//    
//    private func updateEmail(email: String) {
//        guard let user = vm.chatUser else { return }
//        
//        // Auth更新
//        FirebaseManager.shared.auth.currentUser?.updateEmail(to: email) { error in
//            if let error = error {
//                print("Failed to update email:", error)
//                isShowError = true
//                return
//            }
//        }
//        
//        // Firesotre更新
//        let userData = [FirebaseConstants.uid : user.uid,
//                            FirebaseConstants.email: email,
//                            FirebaseConstants.profileImageUrl: user.profileImageUrl,
//                        FirebaseConstants.money: user.money]
//        
//        FirebaseManager.shared.firestore.collection(FirebaseConstants.users)
//            .document(user.uid)
//            .updateData(userData as [AnyHashable : Any]) { error in
//            if let error = error {
//                print("Failed to update chatUser:", error)
//                isShowError = true
//                return
//            }
//        }
//    }
//}
//
//#Preview {
//    EditEmailView(email: "test@gmail.com")
//}
