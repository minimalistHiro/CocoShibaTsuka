////
////  CustomTabBar.swift
////  CocoShibaTsuka
////
////  Created by 金子広樹 on 2023/12/09.
////
//
//import SwiftUI
//
//struct CustomTabBar: View {
//    @Binding var tab: MoneyTransferView.Tab
//    let buttonTab: MoneyTransferView.Tab
//    
//    var imageSystemName: String {
//        switch buttonTab {
//        case .history:
//            "clock.arrow.circlepath"
//        case .friend:
//            "person.2"
//        }
//    }
//    
//    // 各種サイズ
//    let frameWidthHeight: CGFloat = 30
//    let rectangleFrameHeight: CGFloat = 2
//    
//    var body: some View {
//        Button {
//            tab = buttonTab
//        } label: {
//            HStack {
//                Spacer()
//                Image(systemName: imageSystemName)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: frameWidthHeight, height: frameWidthHeight)
//                Spacer()
//            }
//        }
//        Rectangle()
//            .foregroundColor(tab == buttonTab ? .black : .white)
//            .frame(height: rectangleFrameHeight)
//    }
//}
//
//#Preview {
//    CustomTabBar(tab: .constant(.history), buttonTab: .history)
//}
