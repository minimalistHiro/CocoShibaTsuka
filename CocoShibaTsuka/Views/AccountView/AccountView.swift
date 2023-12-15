//
//  AccountView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/10/14.
//

import SwiftUI
import SDWebImageSwiftUI

struct AccountView: View {
    
//    @ObservedObject var vm = ContentViewModel()
    @ObservedObject var vm = ViewModel()
    @ObservedObject var userSetting = UserSetting()
    @State private var isShowConfirmationSignOutAlert = false           // サインアウト確認アラート
    @State private var isShowConfirmationWithdrawalAlert = false        // 退会確認アラート
    @State private var isShowSuccessWithdrawalAlert = false             // 退会成功アラート
    @State private var isShowSignOutAlert = false                       // 強制サインアウトアラート
    
    init() {
        vm.isUserCurrentryLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
//        if FirebaseManager.shared.auth.currentUser?.uid != nil {
//            vm.fetchCurrentUser()
//            vm.fetchRecentMessages()
//            vm.fetchFriends()
//        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // トップ画像
                if let image = vm.currentUser?.profileImageUrl {
                    if image == "" {
                        Icon.CustomCircle(imageSize: .large)
                            .padding(.top)
                    } else {
                        Icon.CustomWebImage(imageSize: .large, image: image)
                            .padding(.top)
                    }
                } else {
                    Icon.CustomCircle(imageSize: .large)
                        .padding(.top)
                }
                
                Text(vm.currentUser?.username ?? "しば太郎")
                    .font(.title3)
                    .bold()
                    .padding()
                
                Text("しばID : " + (vm.currentUser?.id ?? ""))
                    .font(.caption)
                    .padding(.bottom, 60)
            }
            
            Text("設定")
                .font(.callout)
                .bold()
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .padding(.leading, 50)
            
            List {
                // ユーザー名を変更
                NavigationLink {
//                    UpdateUserInfo(category: .username, text: vm.currentUser?.username ?? "")
                    UpdateUsernameView(username: vm.currentUser?.username ?? "")
                } label: {
                    HStack {
                        Text("ユーザー名を変更")
                            .foregroundStyle(.black)
                        Spacer()
                        Text(vm.currentUser?.username ?? "")
                            .foregroundStyle(.gray)
                            .font(.caption2)
                    }
                }
                
                // 残高表示
                Toggle(isOn: $userSetting.isShowPoint, label: {
                    Text("ポイントを表示する")
                })
                
                // ログアウト
                Button {
                    isShowConfirmationSignOutAlert = true
                } label: {
                    Text("ログアウト")
                        .foregroundColor(.red)
                }
                
                // 退会
                Button {
                    isShowConfirmationWithdrawalAlert = true
                } label: {
                    Text("退会する")
                        .foregroundColor(.red)
                }
            }
            .padding(.leading, 10)
            .listStyle(.inset)
            .environment(\.defaultMinListRowHeight, 60)
        }
        .onAppear {
            if FirebaseManager.shared.auth.currentUser?.uid != nil {
                vm.fetchCurrentUser()
                vm.fetchRecentMessages()
                vm.fetchFriends()
            }
        }
        .asDestructiveAlert(title: "",
                            isShowAlert: $isShowConfirmationSignOutAlert,
                            message: "ログアウトしますか？",
                            buttonText: "ログアウト",
                            didAction: {
            DispatchQueue.main.async {
                isShowConfirmationSignOutAlert = false
            }
            vm.handleSignOut()
        })
        .asDestructiveAlert(title: "",
                            isShowAlert: $isShowConfirmationWithdrawalAlert,
                            message: "退会しますか？",
                            buttonText: "退会",
                            didAction: {
            handleWithdrawal()
            DispatchQueue.main.async {
                isShowConfirmationWithdrawalAlert = false
            }
            isShowSuccessWithdrawalAlert = true
        })
        .asSingleAlert(title: "",
                       isShowAlert: $isShowSuccessWithdrawalAlert,
                       message: "退会しました。",
                       didAction: {
            DispatchQueue.main.async {
                isShowSuccessWithdrawalAlert = false
            }
            vm.handleSignOut()
        })
        .asSingleAlert(title: "",
                       isShowAlert: $vm.isShowError,
                       message: vm.errorMessage,
                       didAction: {
            DispatchQueue.main.async {
                vm.isShowError = false
            }
            isShowSignOutAlert = true
        })
        .asSingleAlert(title: "",
                        isShowAlert: $isShowSignOutAlert,
                        message: "エラーが発生したためログアウトします。",
                        didAction: {
             DispatchQueue.main.async {
                 isShowSignOutAlert = false
             }
             vm.handleSignOut()
         })
        .onAppear {
            if FirebaseManager.shared.auth.currentUser?.uid != nil {
                vm.fetchCurrentUser()
                vm.fetchRecentMessages()
                vm.fetchFriends()
            }
        }
        // TODO: - AccountViewにもフルスクリーンカバーをしないと、ログインした時にLoginViewが表示されない。そのままで良いのか？
        .fullScreenCover(isPresented: $vm.isUserCurrentryLoggedOut) {
            EntryView {
                vm.isUserCurrentryLoggedOut = false
                vm.fetchCurrentUser()
                vm.fetchRecentMessages()
                vm.fetchFriends()
            }
        }
    }
    
    // MARK: - 退会処理
    /// - Parameters: なし
    /// - Returns: なし
    private func handleWithdrawal() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // ユーザー情報削除
        vm.deleteUsers(document: uid)
        
        // メッセージを削除
        for recentMessage in vm.recentMessages {
            vm.deleteMessages(document: uid, collection: FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId)
        }
        
        // 最新メッセージを削除
        for recentMessage in vm.recentMessages {
            vm.deleteRecentMessage(document1: uid, document2: FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId)
        }
        
        // 友達を削除
        for friend in vm.friends {
            vm.deleteFriend(document1: uid, document2: friend.uid)
        }
        
        // 画像削除
        vm.deleteImage(withPath: uid)
        
        // Auth削除
        vm.deleteAuth()
    }
}

#Preview {
    AccountView()
}
