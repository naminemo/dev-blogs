# TabView

這是預設的 TabView 畫面

```swift
import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Int = 1
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            // 第一個 Tab 內容：紅色
            Color.red
                .tabItem {
                    Label("首頁", systemImage: "house.fill")
                }
                .overlay(content: {
                    Text("首頁")
                })
                .tag(0)
            
            // 第二個 Tab 內容：綠色
            Color.green
                .tabItem {
                    Label("搜尋", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            // 第三個 Tab 內容：藍色
            Color.blue
                .tabItem {
                    Label("個人", systemImage: "person.fill")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
```

![ss 2025-06-24 09-52-02](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-06-24%2009-52-02.jpg)

## .toolbar(.hidden, for: .tabBar)

這裡的 hidden 並不是本身 tabBar 的隱藏  
也就是說，它並不是指對於 TabView 的隱藏

```swift
TabView {
    HomeView()
        .tabItem {
            Image(systemName: "house")
            Text("首頁")
        }
    
    SettingsView()
        .tabItem {
            Image(systemName: "gear")
            Text("設定")
        }
}
.toolbar(.hidden, for: .tabBar) // 並不是指這樣的隱藏
```

它通常用於深層導航時，讓使用者更專注於目前頁面內容上

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("首頁")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("設定")
                }
        }
    }
}

struct HomeView: View {
    @State private var showDetailView = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("這是首頁")
                    .font(.largeTitle)
                    .padding()
                
                Button("前往詳細頁面") {
                    showDetailView = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("首頁")
            .sheet(isPresented: $showDetailView) {
                DetailView()
            }
        }
    }
}

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("詳細頁面")
                    .font(.largeTitle)
                    .padding()
                
                Text("在這個頁面中，TabBar 被隱藏了")
                    .foregroundStyle(.secondary)
                    .padding()
                
                Spacer()
                
                Button("關閉") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                .padding()
            }
            .navigationTitle("詳細內容")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar) // 隱藏 TabBar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("一般設定") {
                    HStack {
                        Image(systemName: "bell")
                        Text("通知")
                    }
                    HStack {
                        Image(systemName: "moon")
                        Text("深色模式")
                    }
                }
                
                Section("進階設定") {
                    NavigationLink(destination: AdvancedSettingsView()) {
                        HStack {
                            Image(systemName: "wrench")
                            Text("進階選項")
                        }
                    }
                }
            }
            .navigationTitle("設定")
        }
    }
}

struct AdvancedSettingsView: View {
    var body: some View {
        List {
            Text("這是進階設定頁面")
            Text("TabBar 在這裡也會被隱藏")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("進階設定")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar) // 在導航到深層頁面時隱藏 TabBar
    }
}

#Preview {
    ContentView()
}
```

此範例展示了常用的場景  
- Modal Sheet 中隱藏 TabBar: 在 DetailView 中，當以 sheet 方式呈現時，TabBar 會被隱藏
- 深層導航時隱藏 TabBar: 在 AdvancedSettingsView 中，當用戶導航到較深的層級時，TabBar 會被隱藏

此設計模式在許多 iOS 應用中都很常見，例如當使用者進入編輯模式或查看詳細內容時。

注意：
如果這裡的 NavigationStack 換為 NavigationView 會有錯誤  
會發生深層導航的頁面 tabBar 被隱藏了  
但回到上層會仍是隱藏的無法顯示
