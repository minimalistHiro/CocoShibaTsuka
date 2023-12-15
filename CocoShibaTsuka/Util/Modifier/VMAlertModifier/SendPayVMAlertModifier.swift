////
////  SendPayVMAlertModifier.swift
////  CocoShibaTsuka
////
////  Created by 金子広樹 on 2023/11/22.
////
//
//import SwiftUI
//
//struct SendPayVMAlertModifier: ViewModifier {
//    
//    @ObservedObject var vm: SendPayViewModel
//    
//    func body(content: Content) -> some View {
//        content
//            .asSingleAlert(title: "",
//                           isShowAlert: $vm.isShowOverPointError,
//                           message: "残高以上のポイントは送ることができません。",
//                           didAction: { vm.isShowOverPointError = false })
//            .asSingleAlert(title: "",
//                           isShowAlert: $vm.isShowZeroAlert,
//                           message: "0以上の数字を入力してください。",
//                           didAction: { vm.isShowZeroAlert = false })
//            .asSingleAlert(title: "",
//                           isShowAlert: $vm.isShowFailedUpdateUserError,
//                           message: "ユーザー情報の更新に失敗しました。",
//                           didAction: { vm.isShowFailedUpdateUserError = false })
//    }
//}
//
