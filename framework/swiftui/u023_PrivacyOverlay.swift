// 按 HOME 鍵能遮蔽目前畫面

import SwiftUI

// MARK: - 主要內容視圖
struct ContentView: View {
    // 監控應用狀態
    @State private var isAppInBackground = false
    
    var body: some View {
        ZStack {
            // 主要內容
            MainContentView()
            
            // 遮蔽層 - 當應用進入後台時顯示
            if isAppInBackground {
                PrivacyOverlayView()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: isAppInBackground)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            // 應用即將進入非活躍狀態（按 HOME 鍵或被其他應用覆蓋）
            withAnimation {
                isAppInBackground = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            // 應用重新變為活躍狀態
            withAnimation {
                isAppInBackground = false
            }
        }
    }
}

// MARK: - 隱私遮蔽視圖
struct PrivacyOverlayView: View {
    var body: some View {
        ZStack {
            // 可以選擇黑色或白色背景
            Color.black // 或使用 Color.white
                .ignoresSafeArea()
            
            // 可選：添加應用圖標或其他內容
            VStack {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.white) // 如果背景是黑色用白色，背景是白色用黑色
                
                Text("應用已鎖定")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.top, 16)
            }
        }
    }
}

// MARK: - 主要內容視圖（你的實際應用內容）
struct MainContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 首頁
            HomePageView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首頁")
                }
                .tag(0)
            
            // 第二頁
            SecondPageView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("統計")
                }
                .tag(1)
            
            // 第三頁
            ThirdPageView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("個人")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}

// MARK: - 首頁視圖
struct HomePageView: View {
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 歡迎區域
                    VStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundStyle(.orange)
                        
                        Text("歡迎回來！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("這裡是你的應用主要內容")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    
                    // 敏感資訊卡片
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "creditcard.fill")
                                .foregroundStyle(.green)
                            Text("帳戶資訊")
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("帳號:")
                                Spacer()
                                Text("1234-5678-9012")
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text("餘額:")
                                Spacer()
                                Text("NT$ 123,456")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // 快速操作按鈕
                    VStack(spacing: 16) {
                        Text("快速操作")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            ActionButton(icon: "arrow.up.circle.fill", title: "轉帳", color: .blue) {
                                showAlert = true
                            }
                            
                            ActionButton(icon: "arrow.down.circle.fill", title: "收款", color: .green) {
                                showAlert = true
                            }
                            
                            ActionButton(icon: "doc.text.fill", title: "帳單", color: .orange) {
                                showAlert = true
                            }
                            
                            ActionButton(icon: "gearshape.fill", title: "設定", color: .gray) {
                                showAlert = true
                            }
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("首頁")
            .alert("功能提示", isPresented: $showAlert) {
                Button("確定") { }
            } message: {
                Text("這是一個示範按鈕")
            }
        }
    }
}

// MARK: - 第二頁視圖（統計頁面）
struct SecondPageView: View {
    @State private var selectedPeriod = "本月"
    private let periods = ["本週", "本月", "本季", "本年"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 期間選擇
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundStyle(.blue)
                            Text("統計期間")
                                .font(.headline)
                            Spacer()
                        }
                        
                        Picker("期間", selection: $selectedPeriod) {
                            ForEach(periods, id: \.self) { period in
                                Text(period).tag(period)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // 統計卡片
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        StatCard(icon: "dollarsign.circle.fill", title: "總收入", value: "NT$ 85,600", color: .green)
                        StatCard(icon: "minus.circle.fill", title: "總支出", value: "NT$ 42,300", color: .red)
                        StatCard(icon: "chart.line.uptrend.xyaxis", title: "淨收益", value: "NT$ 43,300", color: .blue)
                        StatCard(icon: "percent", title: "儲蓄率", value: "50.6%", color: .orange)
                    }
                    
                    // 圖表區域
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "chart.bar.xaxis")
                                .foregroundStyle(.purple)
                            Text("支出分析")
                                .font(.headline)
                        }
                        
                        VStack(spacing: 12) {
                            ExpenseRow(category: "餐飲", amount: "NT$ 12,500", icon: "fork.knife", color: .orange)
                            ExpenseRow(category: "交通", amount: "NT$ 8,900", icon: "car.fill", color: .blue)
                            ExpenseRow(category: "購物", amount: "NT$ 15,600", icon: "bag.fill", color: .pink)
                            ExpenseRow(category: "娛樂", amount: "NT$ 5,300", icon: "gamecontroller.fill", color: .purple)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("統計分析")
        }
    }
}

// MARK: - 第三頁視圖（個人頁面）
struct ThirdPageView: View {
    @State private var notificationEnabled = true
    @State private var darkModeEnabled = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 個人資訊區域
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.blue)
                        
                        VStack(spacing: 4) {
                            Text("張小明")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("premium@example.com")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Button(action: {}) {
                            Text("編輯個人資料")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // 設定選項
                    VStack(spacing: 0) {
                        SettingRow(icon: "bell.fill", title: "推送通知", color: .orange) {
                            Toggle("", isOn: $notificationEnabled)
                        }
                        
                        Divider()
                        
                        SettingRow(icon: "moon.fill", title: "深色模式", color: .indigo) {
                            Toggle("", isOn: $darkModeEnabled)
                        }
                        
                        Divider()
                        
                        SettingRow(icon: "lock.fill", title: "安全設定", color: .green) {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                        
                        Divider()
                        
                        SettingRow(icon: "questionmark.circle.fill", title: "幫助中心", color: .blue) {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                        
                        Divider()
                        
                        SettingRow(icon: "info.circle.fill", title: "關於我們", color: .gray) {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
                    
                    // 登出按鈕
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("登出")
                        }
                        .font(.headline)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("個人中心")
            .alert("確認登出", isPresented: $showLogoutAlert) {
                Button("取消", role: .cancel) { }
                Button("登出", role: .destructive) { }
            } message: {
                Text("您確定要登出嗎？")
            }
        }
    }
}

// MARK: - 自定義組件

// 動作按鈕組件
struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

// 統計卡片組件
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}

// 支出行組件
struct ExpenseRow: View {
    let category: String
    let amount: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 20)
            
            Text(category)
                .font(.subheadline)
            
            Spacer()
            
            Text(amount)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

// 設定行組件
struct SettingRow<Content: View>: View {
    let icon: String
    let title: String
    let color: Color
    let content: () -> Content
    
    init(icon: String, title: String, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.icon = icon
        self.title = title
        self.color = color
        self.content = content
    }
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            content()
        }
        .padding()
    }
}

// MARK: - 進階版本：可自定義的遮蔽視圖
struct CustomizablePrivacyOverlay: View {
    enum OverlayStyle {
        case solid(Color)
        case blur
        case custom(AnyView)
    }
    
    let style: OverlayStyle
    
    init(style: OverlayStyle = .solid(.black)) {
        self.style = style
    }
    
    var body: some View {
        Group {
            switch style {
            case .solid(let color):
                color.ignoresSafeArea()
                
            case .blur:
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                
            case .custom(let view):
                view
            }
        }
    }
}

// MARK: - 使用進階版本的範例
struct AdvancedContentView: View {
    @State private var isAppInBackground = false
    
    var body: some View {
        ZStack {
            MainContentView()
            
            if isAppInBackground {
                // 使用不同的遮蔽樣式
                CustomizablePrivacyOverlay(style: .blur) // 或 .solid(.white)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: isAppInBackground)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            withAnimation {
                isAppInBackground = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            withAnimation {
                isAppInBackground = false
            }
        }
    }
}

