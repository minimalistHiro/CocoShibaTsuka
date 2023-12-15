//
//  ContentView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/10/14.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ContentView: View {
    
    @ObservedObject var vm = ViewModel()
    
    init() {
        vm.isUserCurrentryLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
//        if FirebaseManager.shared.auth.currentUser?.uid != nil {
//            vm.fetchCurrentUser()
//            vm.fetchRecentMessages()
//        }
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "house")
                        }
                    }
                    .tag(1)
                TradingHistoryView()
                    .tabItem {
                        VStack {
                            Image(systemName: "clock.arrow.circlepath")
                        }
                    }
                    .tag(2)
                AccountView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person.fill")
                        }
                    }
                    .tag(3)
            }
        }
        .tint(.black)
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
    ContentView()
}
