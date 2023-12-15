//
//  AccountViewList.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/11/05.
//

//import SwiftUI

//struct AccountNavigationLink: View {
//    
//    var view: some View { get }
//    let text: String
//    let color: Color
//    
//    var body: some View {
//        NavigationLink {
//            view
//        } label: {
//            Text(text)
//                .foregroundStyle(color)
//                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
//                .padding(.leading, 50)
//        }
//        .padding(10)
//        Divider()
//            .padding(.horizontal)
//    }
//}
//
//struct AccountButton: View {
//    
//    let text: String
//    let color: Color
//    let didPressedButtonProcess: () -> ()
//    
//    var body: some View {
//        Button {
//            didPressedButtonProcess()
//        } label: {
//            Text(text)
//                .foregroundColor(color)
//                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
//                .padding(.leading, 50)
//        }
//        .padding(10)
//        Divider()
//            .padding(.horizontal)
//    }
//}
//
//#Preview {
//    struct DummyView: View {
//        var body: some View {
//            Text("Hello, World!")
//        }
//    }
//    AccountNavigationLink(view: DummyView(), text: "一般", color: .black)
//}
//
//#Preview {
//    AccountButton(text: "一般", color: .red, didPressedButtonProcess: {})
//}
