////
////  LoginVMAlertModifier.swift
////  CocoShibaTsuka
////
////  Created by 金子広樹 on 2023/11/22.
////
//
//import SwiftUI
//
//struct LoginVMAlertModifier: ViewModifier {
//    
//    @ObservedObject var vm: LoginViewModel
//    
//    func body(content: Content) -> some View {
//        content
//            .asSingleAlert(title: "",
//                           isShowAlert: $vm.isShowEmptyError,
//                           message: "メールアドレス、パスワードを入力してください。",
//                           didAction: { vm.isShowEmptyError = false })
//            .asSingleAlert(title: "",
//                           isShowAlert: $vm.isShowLoginError,
//                           message: "メールアドレスもしくはパスワードが違います。",
//                           didAction: { vm.isShowLoginError = false })
//            .asSingleAlert(title: "",
//                           isShowAlert: $vm.isShowPasswordOfDigitsError,
//                           message: "パスワードは\(Setting.minPasswordOfDigits)桁以上で入力してください。",
//                           didAction: { vm.isShowPasswordOfDigitsError = false })
//            .asSingleAlert(title: "新規アカウント作成に失敗",
//                           isShowAlert: $vm.isShowCreateAccountError,
//                           message: "メールアドレスの形式が異なる可能性があります。",
//                           didAction: { vm.isShowCreateAccountError = false })
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowPersistImageError,
//                           message: "画像の保存に失敗しました。",
//                           didAction: { vm.isShowPersistImageError = false })
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowRetrieveDownloadURLError,
//                           message: "画像URLの取得に失敗しました。",
//                           didAction: { vm.isShowRetrieveDownloadURLError = false })
//            .asSingleAlert(title: "サーバーエラー",
//                           isShowAlert: $vm.isShowStoreUserInfoError,
//                           message: "ユーザー情報の保存に失敗しました。",
//                           didAction: { vm.isShowStoreUserInfoError = false })
//    }
//}
