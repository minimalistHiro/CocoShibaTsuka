//
//  StringExtension.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/12/08.
//

import Foundation

extension String {
    // Colors
    static let highlight = "Highlight"
    
    // Tutorial
    static func tutorialText(page: Int) -> String {
        switch page {
        case 1:
            return "しば通貨アプリを\nダウンロードしていただき\nありがとうございます"
        case 2:
            return "ボランティア活動を通して\nポイントを貯めることができます"
        case 3:
            return "貯まったポイントは\n対象店舗で使うことができます"
        case 4:
            return "QRコードをスキャンして\n友達に送ったり、お店に支払ったり\nすることができます"
        default :
            return ""
        }
    }
    
    // ErrorCode
    static let emptyEmailOrPassword = "メールアドレス、パスワードを入力してください。"
    static let invalidEmail = "メールアドレスの形式が正しくありません。"
    static let weakPassword = "パスワードは6文字以上で設定してください。"
    static let emailAlreadyInUse = "このメールアドレスはすでに登録されています。"
    static let userNotFound = "メールアドレス、またはパスワードが間違っています。"
    static let userDisabled = "このユーザーアカウントは無効化されています。"
    static let networkError = "通信エラーが発生しました。"
    static let notFoundData = "データが見つかりませんでした。"
    static let failureDeleteData = "データ削除に失敗しました。"
}
