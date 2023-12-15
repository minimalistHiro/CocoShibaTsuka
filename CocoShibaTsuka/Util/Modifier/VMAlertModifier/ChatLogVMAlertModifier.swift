////
////  ChatLogVMAlertModifier.swift
////  CocoShibaTsuka
////
////  Created by 金子広樹 on 2023/11/22.
////
//
//import SwiftUI
//
//struct ChatLogVMAlertModifier: ViewModifier {
//    
//    @ObservedObject var vm: ChatLogViewModel
//    
//    func body(content: Content) -> some View {
//        content
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowNotFetchMessagesError,
//                           message: "メッセージの取得に失敗しました。",
//                           didAction: { vm.isShowNotFetchMessagesError = false })
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowNoDataFoundError,
//                           message: "データが見つかりませんでした。",
//                           didAction: { vm.isShowNoDataFoundError = false })
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowFailedSaveMessageError,
//                           message: "メッセージの保存に失敗しました。",
//                           didAction: { vm.isShowFailedSaveMessageError = false })
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowFailedSaveRecentMessageError,
//                           message: "最新メッセージの保存に失敗しました。",
//                           didAction: { vm.isShowFailedSaveRecentMessageError = false })
//    }
//}
//
