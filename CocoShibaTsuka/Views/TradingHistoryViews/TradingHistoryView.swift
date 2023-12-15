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
            vm.handleSignOut()
        })
        .fullScreenCover(isPresented: $vm.isUserCurrentryLoggedOut) {
            EntryView {
                vm.isUserCurrentryLoggedOut = false
                vm.fetchCurrentUser()
                vm.fetchRecentMessages()
                vm.fetchFriends()
            }
        }
    }
}

#Preview {
    TradingHistoryView()
}
