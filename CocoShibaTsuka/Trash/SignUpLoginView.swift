////
////  LoginView.swift
////  CocoShibaTsuka
////
////  Created by 金子広樹 on 2023/10/14.
////
//
//import SwiftUI
//
//struct SignUpLoginView: View {
//    
////    @ObservedObject var vm: LoginViewModel
//    @ObservedObject var vm = ViewModel()
//    let didCompleteLoginProcess: () -> ()
//    
//    init(didCompleteLoginProcess: @escaping () -> ()) {
//        self.didCompleteLoginProcess = didCompleteLoginProcess
//        self.vm = .init(didCompleteLoginProcess: didCompleteLoginProcess)
//    }
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                LazyVStack(spacing: 16) {
//                    Picker(selection: $vm.isLoginMode) {
//                        Text("ログイン")
//                            .tag(true)
//                        Text("新規作成")
//                            .tag(false)
//                    } label: {
//                        Text("Picker here")
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    
//                    if !vm.isLoginMode {
//                        Button {
//                            vm.shouldShowImagePicker.toggle()
//                        } label: {
//                            VStack {
//                                if let image = vm.image {
//                                    Image(uiImage: image)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 128, height: 128)
//                                        .cornerRadius(64)
//                                } else {
//                                    Image(systemName: "person.fill")
//                                        .font(.system(size: 64))
//                                        .padding()
//                                        .foregroundColor(Color(.label))
//                                }
//                            }
//                            .overlay {
//                                Circle()
//                                    .stroke(Color(.label), lineWidth: 3)
//                            }
//                        }
//                    }
//                    
//                    Group {
//                        TextField("メールアドレス", text: $vm.email)
//                            .keyboardType(.emailAddress)
//                        SecureField("パスワード", text: $vm.password)
//                    }
//                    .padding(12)
//                    .background(Color.white)
//                    
//                    Button {
//                        vm.handleAction()
//                    } label: {
//                        Capsule()
//                            .foregroundStyle(Color.black)
//                            .frame(height: 50)
//                            .overlay(alignment: .center) {
//                                Text(vm.isLoginMode ? "ログイン" : "新規作成")
//                                    .foregroundColor(.white)
//                                    .padding(.vertical, 10)
//                                    .font(.title3)
//                                    .bold()
//                            }
//                            .padding(.horizontal)
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle(vm.isLoginMode ? "ログイン" : "新規作成")
//            .background(Color(.init(gray: 0, alpha: 0.05)))
//        }
//        .fullScreenCover(isPresented: $vm.shouldShowImagePicker) {
//            ImagePicker(selectedImage: $vm.image)
//        }
////        .asLoginVMAlert(vm: vm)
//        .asSingleAlert(title: "",
//                       isShowAlert: $vm.isShowError,
//                       message: vm.errorMessage,
//                       didAction: { vm.isShowError = false })
//    }
//}
//
//#Preview {
//    SignUpLoginView(didCompleteLoginProcess: {})
//}
