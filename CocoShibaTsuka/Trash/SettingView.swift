////
////  SettingView.swift
////  CocoShibaTsuka
////
////  Created by 金子広樹 on 2023/11/05.
////
//
//import SwiftUI
//
//struct SettingView: View {
//    
////    @ObservedObject var vm = ContentViewModel()
//    @ObservedObject var vm = ViewModel()
//    
//    // Viewサイズ
//    let listLeadingPadding: CGFloat = 10
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                // トップ画像
//                HStack {
//                    if let image = vm.currentUser?.profileImageUrl {
//                        if image == "" {
////                            Icon.CustomCircle(frameSize: 70, lineWidth: 3)
//                            Icon.CustomCircle(imageSize: .large)
//                                .padding()
//                        } else {
////                            Icon.CustomWebImage(image: image, frameSize: 70, lineWidth: 1, shadow: 0)
//                            Icon.CustomWebImage(imageSize: .large, image: image)
//                                .padding()
//                        }
//                    } else {
////                        Icon.CustomCircle(frameSize: 70, lineWidth: 3)
//                        Icon.CustomCircle(imageSize: .large)
//                            .padding()
//                    }
//                    VStack(alignment: .leading) {
//                        Text("ユーザーネーム")
//                            .foregroundStyle(.gray)
//                            .font(.caption)
//                        Text(vm.currentUser?.username ?? "しば太郎")
//                            .font(.title3)
//                            .bold()
//                    }
//                    Spacer()
//                }
//                .padding(.horizontal, 50)
//                
//                List {
//                    // メールアドレス
//                    NavigationLink {
////                        EditEmailView(email: vm.chatUser?.email ?? "")
//                    } label: {
//                        HStack {
//                            Text("メールアドレス")
//                                .foregroundStyle(.black)
//                            Spacer()
//                            Text(vm.currentUser?.email ?? "")
//                                .foregroundStyle(.gray)
//                                .font(.caption2)
//                        }
//                    }
//                    .padding(.leading, listLeadingPadding)
//                    
//                    // パスワード
//                    NavigationLink {
//                        
//                    } label: {
//                        HStack {
//                            Text("パスワード")
//                                .foregroundStyle(.black)
//                            Spacer()
//                            Text("")
//                                .foregroundStyle(.gray)
//                                .font(.caption2)
//                        }
//                    }
//                    .padding(.leading, listLeadingPadding)
//                }
//                .listStyle(.inset)
//                .environment(\.defaultMinListRowHeight, 60)
//            }
//        }
//        .asBackButton()
//        .onAppear {
//            vm.fetchCurrentUser()
//        }
//    }
//}
//
//#Preview {
//    SettingView()
//}
