import SwiftUI

// MARK: - Content View (Root View)
struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainView()
            } else {
                LoginView()
            }
        }
        .environmentObject(authManager)
    }
}

// MARK: - Main View
struct MainView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("歡迎回來！")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("你已成功登入")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                VStack(spacing: 15) {
                    Button("查看個人資料") {
                        // TODO: 導航到個人資料頁面
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("設定") {
                        // TODO: 導航到設定頁面
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                
                Spacer()
                
                Button("登出") {
                    authManager.logout()
                }
                .buttonStyle(DangerButtonStyle())
            }
            .padding()
            .navigationTitle("主頁面")
        }
    }
}

// MARK: - Login View
struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Logo 區域
                VStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.blue)
                    
                    Text("歡迎使用")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("請登入您的帳號")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                
                // 登入表單
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("電子郵件")
                            .font(.headline)
                        
                        TextField("輸入您的電子郵件", text: $email)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("密碼")
                            .font(.headline)
                        
                        SecureField("輸入您的密碼", text: $password)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                }
                
                // 登入按鈕
                VStack(spacing: 15) {
                    Button(action: {
                        Task {
                            await login()
                        }
                    }) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            
                            Text(authManager.isLoading ? "登入中..." : "登入")
                                .fontWeight(.semibold)
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
                    
                    Button("忘記密碼？") {
                        // TODO: 導航到忘記密碼頁面
                    }
                    .font(.footnote)
                    .foregroundStyle(.blue)
                }
                
                Spacer()
                
                // 註冊連結
                HStack {
                    Text("還沒有帳號？")
                        .foregroundStyle(.secondary)
                    
                    Button("立即註冊") {
                        // TODO: 導航到註冊頁面
                    }
                    .foregroundStyle(.blue)
                    .fontWeight(.medium)
                }
                .font(.footnote)
            }
            .padding()
            .navigationTitle("登入")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            // 畫面載入時檢查預設資料
            await authManager.loadInitialData()
        }
        .alert("提示", isPresented: $showingAlert) {
            Button("確定", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func login() async {
        do {
            let success = await authManager.login(email: email, password: password)
            if !success {
                alertMessage = authManager.errorMessage ?? "登入失敗，請檢查您的帳號密碼"
                showingAlert = true
            }
        }
    }
}

// MARK: - Authentication Manager
@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var deviceHasLoggedInBefore = false
    @Published var defaultSettings: [String: Any] = [:]
    
    init() {
        // 檢查本地存儲的登入狀態
        checkStoredAuthState()
    }
    
    // 載入初始資料
    func loadInitialData() async {
        isLoading = true
        
        do {
            // 模擬向後端請求預設資料
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2秒延遲模擬網路請求
            
            // 檢查裝置是否曾經登入過
            await checkDeviceLoginHistory()
            
            // 獲取預設設定
            await fetchDefaultSettings()
            
        } catch {
            errorMessage = "載入初始資料失敗: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // 檢查裝置登入歷史
    private func checkDeviceLoginHistory() async {
        // 模擬 API 調用
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1秒延遲
            
            // 這裡應該是真實的 API 調用
            // 例如: let response = try await APIService.checkDeviceHistory(deviceId: getDeviceId())
            
            // 模擬結果
            deviceHasLoggedInBefore = Bool.random()
            print("裝置登入歷史檢查完成: \(deviceHasLoggedInBefore ? "曾經登入過" : "新裝置")")
        } catch {
            print("檢查裝置登入歷史失敗: \(error)")
        }
    }
    
    // 獲取預設設定
    private func fetchDefaultSettings() async {
        do {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5秒延遲
            
            // 模擬從後端獲取預設設定
            defaultSettings = [
                "theme": "light",
                "language": "zh-TW",
                "notifications": true,
                "autoLogin": deviceHasLoggedInBefore
            ]
            
            print("預設設定載入完成: \(defaultSettings)")
        } catch {
            print("獲取預設設定失敗: \(error)")
        }
    }
    
    // 登入功能
    func login(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            // 模擬 API 登入調用
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2秒延遲
            
            // 簡單的驗證邏輯 (實際應用中應該調用真實的 API)
            if email.contains("@") && password.count >= 6 {
                // 模擬成功登入
                isAuthenticated = true
                
                // 儲存登入狀態到本地
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set(email, forKey: "userEmail")
                
                print("登入成功: \(email)")
                isLoading = false
                return true
            } else {
                errorMessage = "請輸入有效的電子郵件和至少6位數的密碼"
                isLoading = false
                return false
            }
            
        } catch {
            errorMessage = "登入過程發生錯誤: \(error.localizedDescription)"
            isLoading = false
            return false
        }
        
       
    }
    
    // 登出功能
    func logout() {
        isAuthenticated = false
        
        // 清除本地存儲的登入資訊
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        
        print("已登出")
    }
    
    // 檢查本地存儲的登入狀態
    private func checkStoredAuthState() {
        isAuthenticated = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}

// MARK: - Custom Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(configuration.isPressed ? Color.blue.opacity(0.8) : Color.blue)
            )
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(configuration.isPressed ? Color.blue.opacity(0.1) : Color.clear)
                    )
            )
            .foregroundStyle(.blue)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct DangerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(configuration.isPressed ? Color.red.opacity(0.8) : Color.red)
            )
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
            )
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview{
    LoginView()
        .environmentObject(AuthenticationManager())
}

#Preview {
    MainView()
        .environmentObject(AuthenticationManager())
}

#Preview {
    ContentView()
}


