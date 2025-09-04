//  TOTPApp.swift
//  macOS SwiftUI 單檔示範：TOTP 驗證系統
//  需求：macOS 12+；在 Xcode 建立「App」專案後，將本檔放入即可編譯執行。

import SwiftUI
import CryptoKit
import CoreImage
import CoreImage.CIFilterBuiltins


// MARK: - ViewModel
@Observable
final class TOTPViewModel {
    // 使用者輸入
    var accountName: String = "abcdef"
    var issuer: String = "wits"
    var secretBase32: String = TOTPViewModel.randomBase32(length: 16)

    // 顯示用狀態
    var generatedURI: String = ""
    var currentCode: String = "------"
    var remaining: Int = 30
    var verifyInput: String = ""
    var verifyMessage: VerifyMessage? = nil

    // QR 影像
    var qrImage: NSImage? = nil

    // 定時器
    private var timer: Timer? = nil

    // MARK: - 動作
    func start() {
        // 啟動每秒 tick
        timer?.invalidate()
        tick(force: true)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick(force: false)
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func generateNewSecret() {
        secretBase32 = Self.randomBase32(length: 16)
        verifyMessage = nil
        regenerateURIAndQR()
        tick(force: true)
    }

    func regenerateURIAndQR() {
        guard let secData = Self.base32Decode(secretBase32) else { return }
        generatedURI = Self.makeOtpauthURI(account: accountName, issuer: issuer, secretBase32: secretBase32)
        qrImage = Self.makeQRCode(from: generatedURI)
        // 立即更新一次
        currentCode = Self.totp(secret: secData)
    }

    func copyURIToPasteboard() {
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(generatedURI, forType: .string)
    }

    func openOnlineQR() {
        guard !generatedURI.isEmpty else { return }
        let encoded = generatedURI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://api.qrserver.com/v1/create-qr-code/?size=256x256&data=\(encoded)") {
            NSWorkspace.shared.open(url)
        }
    }

    func verify() {
        verifyMessage = nil
        guard let secData = Self.base32Decode(secretBase32) else { return }
        let now = Date()
        // 容忍前後 +-1 個 time step
        let window = [-1, 0, 1]
        let period = 30.0
        let user = verifyInput
        guard user.count == 6, user.allSatisfy({ $0.isNumber }) else {
            verifyMessage = .error("請輸入 6 位數字驗證碼。")
            return
        }

        for w in window {
            let shifted = now.addingTimeInterval(Double(w) * period)
            let code = Self.totp(secret: secData, time: shifted)
            if code == user {
                verifyMessage = .success("驗證成功！")
                verifyInput = ""
                return
            }
        }
        // 顯示目前正確碼以利教學
        let current = Self.totp(secret: secData, time: now)
        verifyMessage = .error("驗證失敗。您輸入：\(user)\n目前正確驗證碼：\(current)")
        verifyInput = ""
    }

    // MARK: - 每秒更新
    private func tick(force: Bool) {
        guard let secData = Self.base32Decode(secretBase32) else { return }
        let now = Date()
        let step = 30
        let epoch = Int(now.timeIntervalSince1970)
        let r = step - (epoch % step)
        let code = Self.totp(secret: secData, time: now)
        if force || remaining != r || currentCode != code {
            remaining = r
            currentCode = code
        }
    }
}

// MARK: - SwiftUI View
struct ContentView: View {
    @State private var vm = TOTPViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                step1
                step2
                step3
                footerNote
            }
            .padding(24)
        }
        .frame(minWidth: 820, minHeight: 820)
        .onAppear { vm.start(); vm.regenerateURIAndQR() }
        .onDisappear { vm.stop() }
    }

    // MARK: - Sections
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🔐 TOTP 驗證系統 ").font(.largeTitle.weight(.bold))
            Text("TOTP (Time-based One-Time Password) 使用共享密鑰 + 當下時間，依 30 秒產生 6 位一次性驗證碼。")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var step1: some View {
        GroupBox("步驟 1：設定 TOTP 參數") {
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
                GridRow {
                    Text("帳號名稱 (顯示於驗證器)")
                    TextField("account", text: $vm.accountName)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("發行商 (issuer)")
                    TextField("issuer", text: $vm.issuer)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("密鑰 (Base32，16 位)")
                    HStack(spacing: 8) {
                        TextField("Base32 Secret", text: $vm.secretBase32)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.body, design: .monospaced))
                            .onChange(of: vm.secretBase32) { _, newValue in
                                vm.secretBase32 = newValue.uppercased().filter { "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567".contains($0) }.prefix(16).toString
                            }
                        Button("隨機生成密鑰") { vm.generateNewSecret() }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            HStack {
                Button("生成 URI 與 驗證碼") { vm.regenerateURIAndQR() }
                Spacer()
            }
        }
    }

    private var step2: some View {
        GroupBox("步驟 2：URI 與 QR 碼") {
            VStack(alignment: .leading, spacing: 12) {
                infoBox(text:
                    "1. 將下方 otpauth URI 複製到驗證器 (Google Authenticator、Authy… )\n2. 或使用內建 QR 碼直接掃描\n3. 驗證器會每 30 秒刷新 6 位數驗證碼")

                // URI 顯示 + 操作
                VStack(alignment: .leading, spacing: 8) {
                    Text("otpauth URI")
                    TextEditor(text: .constant(vm.generatedURI))
                        .font(.system(.body, design: .monospaced))
                        .frame(height: 72)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.quaternary))
                        .disabled(true)
                    HStack {
                        Button("複製 URI") { vm.copyURIToPasteboard() }
                        Button("在線生成 QR 碼") { vm.openOnlineQR() }
                        Spacer()
                    }
                }

                // 內建 QR 圖
                if let img = vm.qrImage {
                    VStack(spacing: 8) {
                        Image(nsImage: img)
                            .interpolation(.none)
                            .resizable()
                            .frame(width: 256, height: 256)
                            .border(Color.gray.opacity(0.2))
                        Text("內建 QR 碼 (點右上角線上版本可另開視窗)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                            .foregroundStyle(Color.gray.opacity(0.4))
                        Text("尚未生成 QR 碼")
                            .foregroundStyle(.secondary)
                    }
                    .frame(height: 260)
                }
            }
        }
    }

    private var step3: some View {
        GroupBox("步驟 3：驗證測試") {
            VStack(spacing: 12) {
                // 當前系統生成碼
                VStack(spacing: 6) {
                    Text("🕐 當前系統生成的驗證碼").font(.title3.weight(.semibold))
                    Text("剩餘時間：\(vm.remaining) 秒").foregroundStyle(.secondary)
                    Text(vm.currentCode)
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.accentColor, lineWidth: 3))
                        .accessibilityLabel("目前驗證碼")
                    Text("這是你的系統依據密鑰與時間產生的驗證碼")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // 使用者輸入 + 驗證
                VStack(alignment: .leading, spacing: 8) {
                    Text("📱 請輸入驗證器 App 顯示的 6 位驗證碼：")
                    TextField("000000", text: $vm.verifyInput)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(.title3, design: .monospaced))
                        .onChange(of: vm.verifyInput) { _, newValue in
                            vm.verifyInput = newValue.filter { $0.isNumber }.prefix(6).toString
                        }
                    Button("驗證") { vm.verify() }
                    if let msg = vm.verifyMessage {
                        switch msg {
                        case .success(let s):
                            resultBox(text: "✅ " + s, style: .success)
                        case .error(let e):
                            resultBox(text: "❌ " + e, style: .error)
                        }
                    }
                }
            }
        }
    }

    private var footerNote: some View {
        GroupBox("程式實作重點") {
            VStack(alignment: .leading, spacing: 6) {
                Text("1. 將使用者的密鑰 (secret) 安全保存於資料庫 (建議加密/鑰匙圈)。")
                Text("2. 驗證時以同一密鑰產生當前 TOTP，與用戶輸入比對。")
                Text("3. 可容忍前後 1~2 個 time step 以處理時鐘誤差。")
                Text("4. 防重放：記錄已使用過的 (code, 時段) 做去重。")
                Text("5. `otpauth://` URI 與 QR 方便導入至驗證器 App。")
                Divider()
                Text("資料表建議：")
                    .font(.callout.weight(.semibold))
                Text("""
CREATE TABLE totp_secrets (
    user_id VARCHAR(50),
    secret VARCHAR(32) NOT NULL,
    issuer VARCHAR(50),
    account_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
""")
                .font(.system(.footnote, design: .monospaced))
            }
        }
    }

    // MARK: - UI Helpers
    func infoBox(text: String) -> some View {
        Text(text)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            //.background(Color(NSColor(calibratedRed: 0.65, green: 0.96, blue: 1.0, alpha: 1)))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(NSColor(calibratedRed: 0.70, green: 0.84, blue: 1.0, alpha: 1))))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    enum ResultStyle { case success, error }

    func resultBox(text: String, style: ResultStyle) -> some View {
        let bg: Color
        let border: Color
        let fg: Color
        switch style {
        case .success:
            bg = Color(nsColor: NSColor(calibratedRed: 0.84, green: 0.94, blue: 0.86, alpha: 1))
            border = Color(nsColor: NSColor(calibratedRed: 0.76, green: 0.90, blue: 0.79, alpha: 1))
            fg = Color(nsColor: NSColor(calibratedRed: 0.09, green: 0.34, blue: 0.15, alpha: 1))
        case .error:
            bg = Color(nsColor: NSColor(calibratedRed: 0.97, green: 0.86, blue: 0.87, alpha: 1))
            border = Color(nsColor: NSColor(calibratedRed: 0.96, green: 0.78, blue: 0.79, alpha: 1))
            fg = Color(nsColor: NSColor(calibratedRed: 0.44, green: 0.13, blue: 0.14, alpha: 1))
        }
        return Text(text)
            .foregroundStyle(fg)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(bg)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(border))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(.body.weight(.semibold))
    }
}

// MARK: - Verify Message
enum VerifyMessage {
    case success(String)
    case error(String)
}

// MARK: - TOTP / Base32 實作
extension TOTPViewModel {
    /// 產生 otpauth URI
    static func makeOtpauthURI(account: String, issuer: String, secretBase32: String, period: Int = 30, digits: Int = 6, algorithm: String = "SHA1") -> String {
        let encAccount = account.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? account
        let encIssuer = issuer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? issuer
        return "otpauth://totp/\(encAccount)?secret=\(secretBase32)&issuer=\(encIssuer)&period=\(period)&digits=\(digits)&algorithm=\(algorithm)"
    }

    /// TOTP 產生（HMAC-SHA1 + 動態截取）
    static func totp(secret: Data, time: Date = Date(), digits: Int = 6, period: Int = 30) -> String {
        let counter = UInt64(floor(time.timeIntervalSince1970 / Double(period)))
        var counterBE = counter.bigEndian
        let counterData = withUnsafeBytes(of: &counterBE) { Data($0) } // 8 bytes

        let key = SymmetricKey(data: secret)
        let mac = HMAC<Insecure.SHA1>.authenticationCode(for: counterData, using: key)
        let hash = Data(mac)

        let offset = Int(hash.last! & 0x0f)
        let binCode =
            (Int(hash[offset]) & 0x7f) << 24 |
            (Int(hash[offset + 1]) & 0xff) << 16 |
            (Int(hash[offset + 2]) & 0xff) << 8 |
            (Int(hash[offset + 3]) & 0xff)

        let mod = Int(pow(10.0, Double(digits)))
        let code = binCode % mod
        return String(format: "%0\(digits)d", code)
    }

    /// Base32 解碼 (A-Z, 2-7)，忽略空白與填充 '='
    static func base32Decode(_ s: String) -> Data? {
        let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567")
        var clean = s.uppercased().filter { alphabet.contains($0) }
        guard !clean.isEmpty else { return nil }
        var buffer = 0
        var bitsLeft = 0
        var bytes: [UInt8] = []
        for c in clean {
            guard let idx = alphabet.firstIndex(of: c) else { continue }
            buffer = (buffer << 5) | idx
            bitsLeft += 5
            if bitsLeft >= 8 {
                let val = UInt8((buffer >> (bitsLeft - 8)) & 0xff)
                bytes.append(val)
                bitsLeft -= 8
            }
        }
        return Data(bytes)
    }

    /// 產生隨機 Base32 Secret
    static func randomBase32(length: Int) -> String {
        let chars = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567")
        var result = ""
        for _ in 0..<length {
            result.append(chars.randomElement()!)
        }
        return result
    }

    /// 產生 QR Code 影像 (256x256)
    static func makeQRCode(from string: String) -> NSImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"
        guard let outputImage = filter.outputImage else { return nil }
        let scaled = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10)) // 大約 260px
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        let size = NSSize(width: 256, height: 256)
        let image = NSImage(cgImage: cgImage, size: size)
        return image
    }
}

// MARK: - 小工具
fileprivate extension Substring {
    var toString: String { String(self) }
}

fileprivate extension String {
    var toString: String { self }
}
