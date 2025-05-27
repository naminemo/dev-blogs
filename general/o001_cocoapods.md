### CocoaPods
[CocoaPods](https://cocoapods.org/) 是一個針對 Swift 和 Objective-C Cocoa 專案的依賴管理工具 (Dependency Manager)。
簡單來說，它幫助你輕鬆地將第三方函式庫 (Libraries) 整合到你的 iOS/macOS 應用程式中。

在以前的開發，手動整合第三方函式庫可能非常繁瑣，你需要：

  - 手動下載原始碼。
  - 將專案檔案拖曳到你的 Xcode 專案中。
  - 配置 Build Settings，例如 Framework Search Paths 等。
  - 處理函式庫之間的依賴關係。

這些步驟不僅耗時，而且容易出錯，尤其當函式庫有更新或你的專案需要多個函式庫時。


#### 核心功能
CocoaPods 解決了這些問題，它提供了以下核心功能：

1. 自動化整合： CocoaPods 會自動下載、配置並連結你所需的函式庫，並處理它們之間的依賴關係。
2. 版本管理： 你可以指定所需的函式庫版本，確保專案使用的函式庫版本一致且穩定。
3. 集中管理： 所有第三方函式庫的資訊都集中在一個名為 Podfile 的檔案中，方便團隊協作和版本控制。
4. 易於更新： 當函式庫發布新版本時，你只需簡單地執行一個命令，CocoaPods 就會自動更新。
5. 生態系統： CocoaPods 擁有龐大的社群和豐富的函式庫資源，幾乎所有流行的 iOS/macOS 函式庫都可以在 CocoaPods 上找到。


#### 名詞說明
  - Podfile： 這是你用來定義專案所需函式庫的檔案。你可以在其中列出函式庫名稱和版本。
  - Pods： 這是 CocoaPods 下載的函式庫的統稱。
  - pod install： 這是你執行來安裝函式庫的命令。它會讀取 Podfile，下載函式庫，並為你的專案生成一個 .xcworkspace 檔案。
  - .xcworkspace： 安裝 CocoaPods 後，你將不再開啟原來的 .xcodeproj 檔案，而是開啟這個 .xcworkspace 檔案。它包含了你的主專案和所有 Pods 的專案。

  

---
### CocoaPods 應用範例：整合 Kingfisher 函式庫

#### 1. 安裝 CocoaPods
```bash
$ gem install cocoapods
```
或者
```bash
$ brew install cocoapods
```
這可能需要一些時間。

#### 2. 建立或進入你的 Xcode 專案目錄
首先，在 Xcode 中建立一個新的 iOS 專案（例如，名為 PodsExample），或者進入你已經存在的專案目錄。

在終端機中，使用 cd 命令進入你的 Xcode 專案的根目錄。這個目錄是包含你 .xcodeproj 檔案的目錄。
```bash
$ cd /path/to/YourProjectName 
# 例如: cd ~/Developer/temp/PodsExample
```

#### 3. 初始化 Podfile
在專案根目錄中，執行以下命令來初始化 Podfile：
```bash
$ pod init
$ code .
```
這將會在你的專案目錄中建立一個名為 Podfile 的檔案。


#### 4. 編輯 Podfile
使用任何文字編輯器（例如 Xcode、Sublime Text、VS Code 或 nano）開啟 Podfile。

你會看到一個類似這樣的檔案：
```ruby
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PodsExample' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PodsExample

end
```

在 target 'YourProjectName' do ... end 區塊中，添加你想要整合的函式庫。

```ruby
# Uncomment the next line to define a global platform for your project
  platform :ios, '18.4'

target 'PodsExample' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PodsExample
  # pod 'Kingfisher', '~> 7.0' # 導入 Kingfisher 函式庫，指定版本範圍
  pod 'Kingfisher'

end
```

#### 5. 安裝 Pods
儲存 Podfile 後，回到終端機，確保你還在專案根目錄，然後執行以下命令：
```bash
$ pod install
```

執行等他跑一下時間通常看到到如下訊息：  
以下為使用 pod 'Kingfisher', '~> 7.0' 跑出來的訊息  
```terminal
Analyzing dependencies
Downloading dependencies
Installing Kingfisher (7.12.0)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `PodsExample.xcworkspace` for this project from now on.
Pod installation complete! There is 1 dependency from the Podfile and 1 total pod installed.
```

若使用 pod 'Kingfisher' 的話跑出來的訊息為：  
```terminal
Analyzing dependencies
Downloading dependencies
Installing Kingfisher (8.3.2)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `PodsExample.xcworkspace` for this project from now on.
Pod installation complete! There is 1 dependency from the Podfile and 1 total pod installed.
```

#### 6. 開啟 .xcworkspace 檔案

> 注意：  
從現在開始，你不再開啟原來的 .xcodeproj 檔案，而是開啟由 CocoaPods 生成的 .xcworkspace 檔案。

先關閉原本開啓的 Xcode
雙擊 .xcworkspace 檔案或在終端機中執行下列指令

```bash
$ open PodsExample.xcworkspace
```
此時 Xcode 開啟看到畫面如下：
![ss 2025-05-27 11-09-20](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-05-27%2011-09-20.jpg)


#### 7. 測試原本的 Hello World 是否能跑的起來

在由 PodsExample.xcworkspace 開啟整個專案之後，先測試模擬器是否跑的起來。

若無法成功啟動，先清除 Xcode 中的快取後再重新啟動

```bash
cd ~/Developer/temp/PodsExample/ 
rm -rf Pods/
rm Podfile.lock
rm -rf PodsExample.xcworkspace
rm -rf ~/Library/Developer/Xcode/DerivedData/ # 清理所有 DerivedData
pod deintegrate # 確保完全移除 Pods 整合
pod cache clean --all # 清理所有 Pods 快取
```

執行
```bash
pod install
```

通常會遇到這個錯誤：  

Sandbox: rsync(11431) deny(1) file-write-create /Users/song_env/Library/Developer/Xcode/DerivedData/PodsExample-frhxqcpyrgsbozcidkyszwfndcaf/Build/Products/Debug-iphonesimulator/PodsExample.app/Frameworks/Kingfisher.framework/Kingfisher.bundle  

這是因為 Sandbox 的安全性限制  
把 User Script Sandboxing 從 Yes 設成 No 即可修正
![ss 2025-05-27 12-23-08](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-05-27%2012-23-08.jpg)


#### 8. 使用 Kingfisher

現在，可以在 Swift 程式碼中導入並使用 Kingfisher 了。

例如，在 ConcentView.swift 中：

```swift
import SwiftUI
import Kingfisher

struct ContentView: View {
    var body: some View {
        
        KFImage(URL(
            string: "https://placehold.co/400x750.png?text=Hello+Kingfisher"))

        /*
        let imageUrl = URL(
         string: "https://placehold.co/400x750.png?text=Hello+Kingfisher")!
        
        VStack {
            
            Text("Hello, KFImage!")
            
            // 使用 KFImage 載入圖片
            KFImage(imageUrl)
                .resizable() // 讓圖片可調整大小
                .placeholder { // 圖片載入時的佔位符
                    ProgressView() // 顯示進度指示器
                }
                .onFailure { e in // 載入失敗的處理
                    print("Error loading image: \(e)")
                }
                .cacheOriginalImage() // 快取原始圖片
                .fade(duration: 0.25) // 圖片載入完成時淡入
                .aspectRatio(contentMode: .fit) // 保持圖片比例
                .frame(width: 300, height: 200) // 設定圖片框架大小
                .cornerRadius(10) // 圓角
                .shadow(radius: 5) // 陰影
        }
        .padding()
         */
    }
}

#Preview {
    ContentView()
}
```
