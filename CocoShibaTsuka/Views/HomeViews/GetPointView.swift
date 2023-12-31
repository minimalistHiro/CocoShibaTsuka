//
//  GetPointView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/12/31.
//

import SwiftUI

struct GetPointView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Icon.CustomCircle(imageSize: .large)
                HStack {
                    Text("1")
                        .font(.system(size: 70))
                        .bold()
                    Text("pt")
                        .font(.title)
                }
                Text("ゲット!")
                    .font(.system(size: 30))
                    .bold()
            }
        }
    }
}

#Preview {
    GetPointView()
}
