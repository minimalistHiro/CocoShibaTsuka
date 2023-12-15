////
////  ContentVMAlertModifier.swift
////  CocoShibaTsuka
////
////  Created by 金子広樹 on 2023/11/22.
////
//
//import SwiftUI
//
//struct ContentVMAlertModifier: ViewModifier {
//    
//    @ObservedObject var vm = ContentViewModel()
//    
//    func body(content: Content) -> some View {
//        content
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowNotFindUidError,
//                           message: "UIDの取得に失敗しました。",
//                           didAction: { vm.isShowNotFindUidError = false
//                vm.isShowSignOutAlert = true })
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowNotFetchCurrentUserError,
//                           message: "現在ユーザーの取得に失敗しました。",
//                           didAction: { vm.isShowNotFetchCurrentUserError = false
//                vm.isShowSignOutAlert = true })
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowNoDataFoundError,
//                           message: "データが見つかりませんでした。",
//                           didAction: { vm.isShowNoDataFoundError = false
//                vm.isShowSignOutAlert = true })
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowNotFetchRecentMessageError,
//                           message: "最新メッセージの取得に失敗しました。",
//                           didAction: { vm.isShowNotFetchRecentMessageError = false
//                vm.isShowSignOutAlert = true })
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowNotFetchMessagesError,
//                           message: "メッセージの取得に失敗しました。",
//                           didAction: { vm.isShowNotFetchMessagesError = false
//                vm.isShowSignOutAlert = true })
//            .asSingleAlert(title: "",
//                           isShowAlert: $vm.isShowNotFetchAllUsersError,
//                           message: "全ユーザーの取得に失敗しました。",
//                           didAction: { vm.isShowNotFetchAllUsersError = false
//                vm.isShowSignOutAlert = true })
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowCouldNotDeleteUserError,
//                           message: "データ削除に失敗しました。",
//                           didAction: { vm.isShowCouldNotDeleteUserError = false })
////            .asSingleAlert(title: "",
////                           isShowAlert: $vm.isShowSignOutAlert,
////                           message: "エラーが発生したためログアウトします。",
////                           didAction: {
////                vm.isShowSignOutAlert = false
////                vm.handleSignOut()
////            })
////            .asSingleAlert(title: "",
////                           isShowAlert: $vm.isShowSuccessWithdrawalAlert,
////                           message: "退会しました。",
////                           didAction: {
////                vm.isShowSuccessWithdrawalAlert = false
////                vm.handleSignOut()
////            })
//    }
//}
