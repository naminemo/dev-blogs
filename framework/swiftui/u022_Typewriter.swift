import SwiftUI

struct TypewriterText: View {
    let text: String
    let speed: Double
    @State private var displayedText = ""
    @State private var currentIndex = 0
    
    init(_ text: String, speed: Double = 0.1) {
        self.text = text
        self.speed = speed
    }
    
    var body: some View {
        Text(displayedText)
            .font(.title2)
            .onAppear {
                startTypewriting()
            }
    }
    
    private func startTypewriting() {
        displayedText = ""
        currentIndex = 0
        typeNextCharacter()
    }
    
    private func typeNextCharacter() {
        guard currentIndex < text.count else { return }
        
        let index = text.index(text.startIndex, offsetBy: currentIndex)
        displayedText += String(text[index])
        currentIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
            typeNextCharacter()
        }
    }
}

struct TypewriterEffectView: View {
    @State private var showFirstText = false
    @State private var showSecondText = false
    @State private var showThirdText = false
    @State private var resetTrigger = false
    
    let texts = [
        "歡迎來到打字機效果展示！",
        "這個效果會讓文字逐一顯示出來",
        "就像真的在打字一樣！✨"
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("SwiftUI 打字機效果")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            VStack(alignment: .leading, spacing: 20) {
                if showFirstText {
                    TypewriterText(texts[0], speed: 0.08)
                        .foregroundColor(.blue)
                }
                
                if showSecondText {
                    TypewriterText(texts[1], speed: 0.06)
                        .foregroundColor(.green)
                }
                
                if showThirdText {
                    TypewriterText(texts[2], speed: 0.1)
                        .foregroundColor(.purple)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .frame(height: 200)
            
            Spacer()
            
            VStack(spacing: 15) {
                Button("開始演示") {
                    startDemo()
                }
                .buttonStyle(.borderedProminent)
                .font(.title3)
                
                Button("重新開始") {
                    resetDemo()
                }
                .buttonStyle(.bordered)
                .font(.title3)
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            // 自動開始第一次演示
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                startDemo()
            }
        }
    }
    
    private func startDemo() {
        showFirstText = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(texts[0].count) * 0.08 + 0.5) {
            showSecondText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(texts[0].count) * 0.08 + Double(texts[1].count) * 0.06 + 1.0) {
            showThirdText = true
        }
    }
    
    private func resetDemo() {
        showFirstText = false
        showSecondText = false
        showThirdText = false
    }
}

// 進階版本：支援游標閃爍效果
struct TypewriterWithCursor: View {
    let text: String
    let speed: Double
    let cursor: String
    let keepCursorAfterComplete: Bool
    @State private var displayedText = ""
    @State private var currentIndex = 0
    @State private var showCursor = true
    @State private var isTypingComplete = false
    @State private var cursorTimer: Timer?
    
    init(_ text: String, speed: Double = 0.1, cursor: String = "_", keepCursorAfterComplete: Bool = true) {
        self.text = text
        self.speed = speed
        self.cursor = cursor
        self.keepCursorAfterComplete = keepCursorAfterComplete
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(displayedText)
                .font(.title2)
            
            Text(cursor)
                .font(.title2)
                .opacity(showCursor ? 1 : 0)
        }
        .onAppear {
            resetAndStart()
        }
        .onDisappear {
            stopCursorBlinking()
        }
    }
    
    private func resetAndStart() {
        // 停止之前的計時器
        stopCursorBlinking()
        
        // 重置所有狀態
        displayedText = ""
        currentIndex = 0
        showCursor = true
        isTypingComplete = false
        
        startTypewriting()
        startCursorBlinking()
    }
    
    private func startTypewriting() {
        typeNextCharacter()
    }
    
    private func typeNextCharacter() {
        guard currentIndex < text.count else {
            isTypingComplete = true
            handleTypingComplete()
            return
        }
        
        let index = text.index(text.startIndex, offsetBy: currentIndex)
        displayedText += String(text[index])
        currentIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
            typeNextCharacter()
        }
    }
    
    private func handleTypingComplete() {
        if keepCursorAfterComplete {
            // 繼續閃爍游標
            return
        } else {
            // 游標閃爍2秒後消失
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                stopCursorBlinking()
                showCursor = false
            }
        }
    }
    
    private func startCursorBlinking() {
        cursorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            showCursor.toggle()
        }
    }
    
    private func stopCursorBlinking() {
        cursorTimer?.invalidate()
        cursorTimer = nil
    }
}

struct AdvancedTypewriterView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("進階打字機效果")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("游標持續閃爍：")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TypewriterWithCursor("預設游標（下劃線）", speed: 0.08)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("游標會消失：")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TypewriterWithCursor("使用豎線游標", speed: 0.08, cursor: "|", keepCursorAfterComplete: false)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("方塊游標持續閃爍：")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TypewriterWithCursor("使用方塊游標", speed: 0.08, cursor: "█", keepCursorAfterComplete: true)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("自訂游標會消失：")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TypewriterWithCursor("自訂游標效果 ▊", speed: 0.06, cursor: "▊", keepCursorAfterComplete: false)
                        .foregroundColor(.purple)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
    }
}

//
// MARK: 結構層次
//
// ContentView
// ├── TypewriterEffectView (基本效果頁面)
// └── AdvancedTypewriterView (進階效果頁面)
//     ├── TypewriterWithCursor (游標持續閃爍)
//     ├── TypewriterWithCursor (游標會消失)
//     ├── TypewriterWithCursor (方塊游標)
//     └── TypewriterWithCursor (自訂游標)

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TypewriterEffectView()
                .tabItem {
                    Image(systemName: "text.cursor")
                    Text("基本效果")
                }
                .tag(0)
            
            AdvancedTypewriterView()
                .tabItem {
                    Image(systemName: "cursor.rays")
                    Text("進階效果")
                }
                .tag(1)
        }
    }
}
