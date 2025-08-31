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


## .toolbarVisibility(.hidden, for: .tabBar)

在 iOS 13+ 可以用 .toolbar(.hidden, for: .tabBar)
在 iOS 16+ 可以用 .toolbarVisibility(.hidden, for: .tabBar)  

這兩者基本上功能是等效的

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
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("個人資料")
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
    @State private var showFullScreenView = false
    @State private var showPhotoView = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("首頁")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Button("全螢幕檢視") {
                    showFullScreenView = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Button("照片檢視器") {
                    showPhotoView = true
                }
                .buttonStyle(.bordered)
                .padding()
                
                NavigationLink("導航到編輯頁面", destination: EditView())
                    .buttonStyle(.bordered)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("首頁")
            .fullScreenCover(isPresented: $showFullScreenView) {
                FullScreenView()
            }
            .sheet(isPresented: $showPhotoView) {
                PhotoViewerView()
            }
        }
    }
}

struct FullScreenView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("全螢幕模式")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding()
                
                Text("TabBar 已完全隱藏")
                    .foregroundStyle(.gray)
                    .padding()
                
                Spacer()
                
                Button("關閉") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar) // 隱藏 TabBar
        .toolbarVisibility(.hidden, for: .navigationBar) // 同時隱藏導航欄
    }
}

struct PhotoViewerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentImageIndex = 0
    
    let images = ["photo", "camera", "video", "globe", "star"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Image(systemName: images[currentImageIndex])
                        .font(.system(size: 100))
                        .foregroundStyle(.white)
                        .padding()
                    
                    Text("照片 \(currentImageIndex + 1) / \(images.count)")
                        .foregroundStyle(.white)
                        .padding()
                    
                    Spacer()
                    
                    HStack(spacing: 50) {
                        Button(action: previousImage) {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                        }
                        .disabled(currentImageIndex == 0)
                        
                        Button(action: nextImage) {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                        }
                        .disabled(currentImageIndex == images.count - 1)
                    }
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("照片檢視器")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarVisibility(.hidden, for: .tabBar) // 隱藏 TabBar
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
    
    private func previousImage() {
        if currentImageIndex > 0 {
            currentImageIndex -= 1
        }
    }
    
    private func nextImage() {
        if currentImageIndex < images.count - 1 {
            currentImageIndex += 1
        }
    }
}

struct EditView: View {
    @State private var title = ""
    @State private var content = ""
    @State private var isEditing = false
    
    var body: some View {
        Form {
            Section("標題") {
                TextField("輸入標題", text: $title)
                    .textFieldStyle(.roundedBorder)
            }
            
            Section("內容") {
                TextEditor(text: $content)
                    .frame(minHeight: 200)
            }
            
            Section {
                Button("開始編輯") {
                    isEditing.toggle()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("編輯頁面")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(isEditing ? .hidden : .visible, for: .tabBar) // 動態控制 TabBar 顯示
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "完成" : "編輯") {
                    isEditing.toggle()
                }
            }
        }
    }
}

struct ProfileView: View {
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.blue)
                    .padding()
                
                Text("使用者名稱")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Button("更換大頭貼") {
                    showImagePicker = true
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
            .navigationTitle("個人資料")
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView()
            }
        }
    }
}

struct ImagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("圖片選擇器")
                    .font(.largeTitle)
                    .padding()
                
                Text("在圖片選擇模式下，TabBar 被隱藏")
                    .foregroundStyle(.secondary)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("選擇圖片")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarVisibility(.hidden, for: .tabBar) // 隱藏 TabBar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("選擇") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("顯示設定") {
                    NavigationLink("主題設定", destination: ThemeSettingsView())
                    NavigationLink("字體設定", destination: FontSettingsView())
                }
                
                Section("隱私設定") {
                    NavigationLink("帳號設定", destination: AccountSettingsView())
                }
            }
            .navigationTitle("設定")
        }
    }
}

struct ThemeSettingsView: View {
    @State private var selectedTheme = "系統"
    let themes = ["淺色", "深色", "系統"]
    
    var body: some View {
        List {
            ForEach(themes, id: \.self) { theme in
                HStack {
                    Text(theme)
                    Spacer()
                    if selectedTheme == theme {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedTheme = theme
                }
            }
        }
        .navigationTitle("主題設定")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar) // 深層設定頁面隱藏 TabBar
    }
}

struct FontSettingsView: View {
    @State private var fontSize: Double = 16
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("字體大小預覽")
                .font(.system(size: fontSize))
                .padding()
            
            VStack(alignment: .leading) {
                Text("字體大小: \(Int(fontSize))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Slider(value: $fontSize, in: 12...24, step: 1)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("字體設定")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar) // 深層設定頁面隱藏 TabBar
    }
}

struct AccountSettingsView: View {
    var body: some View {
        List {
            Section("帳號資訊") {
                Text("使用者名稱: user@example.com")
                Text("註冊時間: 2024年1月")
            }
            
            Section("安全設定") {
                Button("更改密碼") {
                    // 更改密碼功能
                }
                Button("兩步驟驗證") {
                    // 兩步驟驗證功能
                }
            }
        }
        .navigationTitle("帳號設定")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar) // 深層設定頁面隱藏 TabBar
    }
}

#Preview {
    ContentView()
}
```

### 主要功能展示

1. 全螢幕模式 (FullScreenView): 完全隱藏 TabBar 和導航欄
2. 照片檢視器 (PhotoViewerView): 沈浸式體驗，隱藏 TabBar
3. 編輯模式 (EditView): 動態控制 TabBar 顯示/隱藏
4. 深層設定頁面: 導航到較深層級時隱藏 TabBar

### 關鍵特點

- .toolbarVisibility(.hidden, for: .tabBar): 隱藏 TabBar
- .toolbarVisibility(.visible, for: .tabBar): 顯示 TabBar
- 動態控制: 可以根據狀態動態切換顯示/隱藏
- 組合使用: 可以同時控制多個 toolbar 的顯示狀態

### 適用場景

- 全螢幕媒體播放
- 圖片/影片檢視器
- 編輯模式或專注模式
- 深層導航頁面
- Modal 呈現的內容
