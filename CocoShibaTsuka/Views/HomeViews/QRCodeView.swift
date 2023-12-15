//
//  QRCodeView.swift
//  CocoShibaTsuka
//
//  Created by 金子広樹 on 2023/11/25.
//

import SwiftUI
import CodeScanner

struct QRCodeView: View {
    
    @Environment(\.dismiss) var dismiss
    private let brightness: CGFloat = UIScreen.main.brightness      // 画面遷移前の画面輝度を保持
    @State private var isShowSendPayScreen = false      // SendPayViewの表示有無
//    @State private var sendPayText = "0"                // 送金テキスト
//    @State private var lastText = ""                    // 一時保存用最新メッセージ
//    @State private var isSendPay = false                // 送金処理をしたか否か
    @State private var chatUserUID = ""                 // 送金相手UID
    
    enum QRCodeMode {
        case qrCode
        case camera
    }
    
    @ObservedObject var vm = ViewModel()
    @State private var qrCodeMode: QRCodeMode = .qrCode
    @State private var qrCodeImage: UIImage?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if qrCodeMode == .qrCode {
                    qrCodeView
                } else {
                    cameraView
                }
                buttons
            }
            .asCloseButton()
        }
        .onAppear {
            UIScreen.main.brightness = 1.0
            vm.fetchCurrentUser()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.qrCodeImage = generateQRCode(inputText: vm.currentUser?.uid ?? "")
            }
        }
        .onChange(of: vm.isQrCodeScanError) { _ in
            // 1.5秒後にQRコード読みよりエラーをfalseにする。
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                vm.isQrCodeScanError = false
            }
        }
        .onDisappear {
            UIScreen.main.brightness = brightness
        }
    }
    
    // MARK: - qrCodeView
    private var qrCodeView: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .foregroundStyle(.white)
                .frame(width: 300, height: 400)
                .cornerRadius(20)
                .shadow(radius: 7, x: 0, y: 0)
                .overlay {
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 15) {
                            if let image = vm.currentUser?.profileImageUrl {
                                if image == "" {
                                    Icon.CustomCircle(imageSize: .medium)
                                } else {
                                    Icon.CustomWebImage(imageSize: .medium, image: image)
                                }
                            } else {
                                Icon.CustomCircle(imageSize: .medium)
                            }
                            Text(vm.currentUser?.username ?? "")
                                .font(.title3)
                                .bold()
                        }
                        
                        Spacer()
                        
                        if vm.onIndicator {
                            ScaleEffectIndicator(onIndicator: $vm.onIndicator)
                        } else {
                            if let qrCodeImage {
                                Image(uiImage: qrCodeImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            } else {
                                VStack {
                                    Text("データを読み込めませんでした。")
                                        .font(.callout)
                                    Button {
                                        qrCodeImage = generateQRCode(inputText: vm.currentUser?.uid ?? "")
                                    } label: {
                                        Image(systemName: "arrow.clockwise")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20)
                                    }
                                }
                                .frame(width: 200, height: 200)
                            }
                        }
                        
                        Spacer()
                        Text("残ポイント: \(vm.currentUser?.money ?? "") pt")
                            .font(.headline)
                        Spacer()
                    }
                }
            
            Spacer()
            Spacer()
            Spacer()
        }
    }
    
    // MARK: - cameraView
    private var cameraView: some View {
        CodeScannerView(codeTypes: [.qr], completion: handleScan)
            .overlay {
                if vm.isQrCodeScanError {
                    ZStack {
                        Color(.red)
                            .opacity(0.5)
                        VStack {
                            Image(systemName: "multiply")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundStyle(.white)
                                .opacity(0.6)
                                .padding(.bottom)
                            RoundedRectangle(cornerRadius: 20)
                                .padding(.horizontal)
                                .frame(width: UIScreen.main.bounds.width, height: 40)
                                .foregroundStyle(.black)
                                .opacity(0.7)
                                .overlay {
                                    Text("誤ったQRコードがスキャンされました。")
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                } else {
                    Rectangle()
                        .stroke(style:
                                    StrokeStyle(
                                        lineWidth: 7,
                                        lineCap: .round,
                                        lineJoin: .round,
                                        miterLimit: 50,
                                        dash: [100, 100],
                                        dashPhase: 50
                                    ))
                        .frame(width: 200, height: 200)
                        .foregroundStyle(.white)
                }
            }
            .fullScreenCover(isPresented: $isShowSendPayScreen) {
                SendPayView(didCompleteSendPayProcess: { sendPayText in
                    isShowSendPayScreen.toggle()
                    vm.handleSend(toId: chatUserUID, chatText: "", lastText: sendPayText, isSendPay: true)
                    dismiss()
                }, chatUser: vm.chatUser)
            }
    }
    
    // MARK: - buttons
    private var buttons: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    qrCodeMode = .qrCode
                } label: {
                    VStack {
                        Image(systemName: "qrcode")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .padding(.bottom)
                        Text("QRコードを表示する")
                            .font(.caption)
                    }
                }
                .foregroundStyle(qrCodeMode == .qrCode ? .black : .gray)
                
                Spacer()
                
                Button{
                    qrCodeMode = .camera
                } label: {
                    VStack {
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .padding(.bottom)
                        Text("QRコードを読み取る")
                            .font(.caption)
                    }
                }
                .foregroundStyle(qrCodeMode == .camera ? .black : .gray)
                
                Spacer()
            }
            .padding(.bottom)
        }
    }

    // MARK: - QRコードを生成する
    /// - Parameters:
    ///   - inputText: QRコードの生成に使用するテキスト
    /// - Returns: QRコード画像
    private func generateQRCode(inputText: String) -> UIImage? {
        
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        else { return nil }
        
        let inputData = inputText.data(using: .utf8)
        qrFilter.setValue(inputData, forKey: "inputMessage")
        // 誤り訂正レベルをHに指定
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let ciImage = qrFilter.outputImage else { return nil }
        
        // CIImageは小さい為、任意のサイズに拡大。
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCiImage = ciImage.transformed(by: sizeTransform)
        
        // CIImageだとSwiftUIのImageでは表示されない為、CGImageに変換。
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledCiImage,
                                                  from: scaledCiImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
    // MARK: - QRコード読み取り処理
    /// - Parameters:
    ///   - result: QRコード読み取り結果
    /// - Returns: なし
    private func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let fetchedUid = result.string
            self.chatUserUID = fetchedUid
            
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
                vm.handleError("UIDの取得に失敗しました。", error: nil)
                return
            }
            // 同アカウントのQRコードを読み取ってしまった場合、エラーを発動。
            if uid == self.chatUserUID {
                vm.isQrCodeScanError = true
                return
            }
            
            vm.fetchUser(uid: chatUserUID)
            
            // 遅らせてSendPayViewを表示する
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if !vm.isQrCodeScanError {
                    UIScreen.main.brightness = brightness
                    self.isShowSendPayScreen = true
                }
            }
        case .failure(let error):
            vm.isQrCodeScanError = true
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    QRCodeView()
}
