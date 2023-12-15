//
//  CocoShibaTsukaApp.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/10/14.
//

import SwiftUI
import FirebaseCore

@main
struct CocoShibaTsukaApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
