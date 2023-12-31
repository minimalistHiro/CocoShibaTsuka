//
//  TradingHistoryView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/10/14.
//

import SwiftUI

struct TradingHistoryView: View {
    
    @ObservedObject var vm = ViewModel()
    @State private var isShowSignOutAlert = false       // 強制サインアウトアラート
    
    @Binding var isUserCurrentryLoggedOut: Bool
    
    var body: some View {
        NavigationStack {
//            ScrollView {
                Text("作成中です。")
//            }
        }
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
            isShowSignOutAlert = false
            handleSignOut()
        })
        .fullScreenCover(isPresented: $isUserCurrentryLoggedOut) {
            EntryView {
                isUserCurrentryLoggedOut = false
                vm.fetchCurrentUser()
                vm.fetchRecentMessages()
                vm.fetchFriends()
            }
        }
    }
    
    // MARK: - サインアウト
    /// - Parameters: なし
    /// - Returns: なし
    private func handleSignOut() {
        isUserCurrentryLoggedOut = true
        try? FirebaseManager.shared.auth.signOut()
    }
}

#Preview {
    TradingHistoryView(isUserCurrentryLoggedOut: .constant(false))
}
