// Swift Package

# Swift Package

Swift Package 是一種用於分享程式碼和資源的工具。
它將程式碼和相關檔案打包成一個獨立的、可重複使用的單元。
你可以把 Swift Package 想成是一個專門為 Swift 語言設計的框架或函式庫。

通常，一個純粹的 Swift Package 是不需要 .xcodeproj 檔案的

## 起步走

我們將創建兩個獨立的專案：
 - Tutorial01：一個 SwiftUI 應用程式，這是我們的主專案。
 - Tools：一個 Swift 套件，裡面有一個簡單的函式供 Tutorial01 呼叫。

### 第一步：建立 Swift 套件 Tools

1. 打開 Xcode，選擇 File -> New -> Package...。
2. 選擇 Multiplatform -> Library 的 Library
3. 有跳出 Testing System 選 None
4. Save As：輸入 Tools。
5. Source Control: 不勾選
6. 選擇一個你方便存放的資料夾，點擊 Create。

現在，你就有了一個名為 Tools 的新 Xcode 視窗。
它的 icon 是一個咖啡色的紙箱

它目錄結構可能如下：

Tools/
├── Package.swift         
└── Sources/          
    └── Tools/
        ├── UtilA.swift
        └── UtilB.swift


```範例複製用                
│   ├── Alamofire/
│   ├── SnapKit/
│   └── ...
│   ├── project.pbxproj
│   └── ...
├── Podfile 
```

在專案導覽器（左側）中，打開 tools -> Sources -> Tools 資料夾。
新增兩支檔案。

```swift
import Foundation

public struct UtilA {

    public init() {
        
    }

    public func printMessage() {
        print("This is from UtilA")
    }
}
```

另外再新增一支 Utils.swift
```swift
import Foundation

public struct UtilB {

    public init() {
        
    }

    public func printMessage() {
        print("This is from UtilB")
    }
}
```

好了之後按 cmd + B 編譯一下



### 第二步：建立 SwiftUI 應用程式 Tutorial01

1. 關閉 Tools 的 Xcode 視窗。
2. 再次打開 Xcode，選擇 File -> New -> Project...。
3. 選擇 iOS 標籤，點擊 App，然後點擊 Next。
4. 在設定視窗中：
  - Product Name：輸入 Tutorial01。
  - Interface：選擇 SwiftUI。
  - Language：選擇 Swift。
5. 點擊 Next，選擇一個資料夾來存放你的專案，然後點擊 Create。

現在，你就有了一個獨立的 Tutorial01 專案。


### 第三步：將 Tools 套件加入 Tutorial01 專案

這一步就是關鍵，我們將 tools 變成 Tutorial01 的依賴項。

1. 在 Tutorial01 專案的 Xcode 視窗中，點擊左側的專案檔（Tutorial01）。
2. 在主視窗中，選擇 PROJECT Tutorial01。
3. 切換到上方的 Package Dependencies 頁籤。
4. 點擊左下角的 加號 (+) 按鈕。
5. 在彈出的視窗中，點擊 Add Local...。
6. 瀏覽到你存放 Tools 套件的資料夾，選擇 Tools 資料夾本身，然後點擊 Add Package。
7. Xcode 會自動偵測到 Tools 裡的產品。在下一個視窗中，確保 Tools 被勾選在 Target Tutorial01 的下方。
8. 點擊 Add Package。

現在，你會在專案導覽器中看到一個咖啡色紙箱圖標，上面寫著 tools。
而且後面還有著 local 文字
這代表 Tutorial01 已經成功引用了 tools 套件。


### 第四步：在 Tutorial01 中呼叫 tools 的函式

1. 在 Tutorial01 的專案導覽器中，打開 Tutorial01 資料夾，點擊 ContentView.swift。
2. 在 import SwiftUI 之後，添加 import tools。
3. 在 ContentView 的 body 內，添加按鈕來呼叫 printFromB()。

```Swift
import SwiftUI
import Tools

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Tap me") {
                let instance = UtilA()
                instance.printMessage()
            }
            .padding(10)
            .background(.indigo)
            .buttonBorderShape(.capsule)
            
            
            Button("Tap me 2") {
                let instance = UtilB()
                instance.printMessage()
            }
        }
        .padding()       
    }
}
```

4. 點擊 Command + R (Run) 執行你的應用程式。
5. 當模擬器或裝置上的 App 運行時，點擊 Call B 按鈕。
6. 在 Xcode 的下方主控台（Console）中，你會看到輸出結果：

This is from UtilA
This is from UtilB

這樣，你就成功地在主專案 Tutorial01 中呼叫了來自獨立套件 Tools 的程式碼。

### 備註

loacl 的 Swift Package Dependencies 可直接修改程式
