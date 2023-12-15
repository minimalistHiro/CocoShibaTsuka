//
//  HomeView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/10/14.
//

import SwiftUI

// MARK: - HomeView
struct HomeView: View {
    
    @ObservedObject var vm = ViewModel()
    @ObservedObject var userSetting = UserSetting()
    @State private var isShowQRCodeView = false             // QRCodeView表示有無
    @State private var isShowSignOutAlert = false           // 強制サインアウトアラート
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    cardView
                    buttons
                }
            }
            .overlay {
                qrCodeButton
            }
        }
        .onAppear {
            if FirebaseManager.shared.auth.currentUser?.uid != nil {
                vm.fetchCurrentUser()
            }
        }
        .asSingleAlert(title: "",
                       isShowAlert: $vm.isShowError,
                       message: vm.errorMessage,
                       didAction: {
            DispatchQueue.main.async {
                vm.isShowError = false
            }
            isShowSignOutAlert = true
        })
        .asSingleAlert(title: "",
                       isShowAlert: $isShowSignOutAlert,
                       message: "エラーが発生したためログアウトします。",
                       didAction: {
            isShowSignOutAlert = false
            vm.handleSignOut()
        })
        .fullScreenCover(isPresented: $isShowQRCodeView) {
            QRCodeView()
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentryLoggedOut) {
            EntryView {
                vm.isUserCurrentryLoggedOut = false
                vm.fetchCurrentUser()
                vm.fetchRecentMessages()
                vm.fetchFriends()
            }
        }
    }
    
    // MARK: - cardView
    private var cardView: some View {
        Rectangle()
            .foregroundColor(.white)
            .frame(width: 300, height: 200)
            .cornerRadius(20)
            .shadow(radius: 7, x: 0, y: 0)
            .overlay {
                VStack {
                    Spacer()
                    Text("残ポイント")
                    Spacer()
                    HStack {
                        Spacer()
                        
                        if userSetting.isShowPoint {
                            Spacer()
                            
                            if vm.onIndicator {
                                Indicator(onIndicator: $vm.onIndicator)
                                    .scaleEffect(2)
                            } else {
                                Text(String(vm.currentUser?.money ?? "Error"))
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                if let _ = vm.currentUser?.money {
                                    Text("pt")
                                        .bold()
                                }
                            }
                            
                            Spacer()
                            
                            if !vm.onIndicator {
                                Button {
                                    vm.fetchCurrentUser()
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15)
                                        .foregroundStyle(.black)
                                }
                            }
                            
                        } else {
                            Text("******")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                        }
                        
                        Spacer()
                    }
                    Spacer()
                    Spacer()
                }
            }
            .padding()
    }
    
    // MARK: - buttons
    private var buttons: some View {
        HStack {
            NavigationLink {
                MoneyTransferView()
            } label: {
                VStack {
                    Image(systemName: "yensign.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                    Text("送る")
                }
            }
            .foregroundColor(.black)
        }
    }
    
    // MARK: - qrCodeButton
    private var qrCodeButton: some View {
        VStack {
            Spacer()
            Button {
                isShowQRCodeView = true
            } label: {
                CustomCapsule(text: "QRコードで送る",
                              imageSystemName: "qrcode",
                              foregroundColor: .black,
                              textColor: .white,
                              isStroke: false)
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    HomeView()
}
