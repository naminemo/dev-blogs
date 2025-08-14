# terminal 如何使用 log show

log show 是一個命令列工具，用於從系統的日誌儲存中檢視已儲存的日誌。
它非常適合在終端機中進行快速查詢和篩選。

打開終端機（Terminal）應用程式，然後輸入以下指令

## 查看最近 5 分鐘的日誌

```bash
log show --last 5m
```

## 查看特定日誌子系統（subsystem）的日誌

以下會顯示你的 App 在過去 1 小時內的所有日誌。

```shell
log show --predicate 'subsystem == "com.company.app"' --last 1h
```

## 篩選特定日誌等級

messageType 可以是 info, debug, error, fault 等。

```bash
log show --predicate 'subsystem == "com.company.app" and messageType == info' --last 1h
```

log show 的強大之處在於它的過濾功能，可以用 --predicate 來建立複雜的查詢，精準地找到你需要的日誌。
predicate 這個詞，可以將它理解為「一個用來判斷或描述的條件」。


# swift 使用 Logger

```swift
import Foundation
import OSLog

// 定義一個包含所有日誌的靜態結構
struct Trace {
    
    // 建立一個專門用於網路相關的日誌實例
    static let networking = Logger(subsystem: "com.company.app", category: "networking")
    
    // 建立一個專門用於 UI 相關的日誌實例
    static let ui = Logger(subsystem: "com.company.app", category: "ui")
    
    // 建立一個專門用於資料庫相關的日誌實例
    static let database = Logger(subsystem: "com.company.app", category: "database")
    
    // 動作
    static let action = Logger(subsystem: "com.company.app", category: "action")

    // 如果其他的分類，也可以在這裡增加
    // ...
}
```

## 使用方法

在程式碼中，就可以直接呼叫這個已經設定好的日誌實例：

```Swift
// 網路相關
Trace.networking.fault("使用者已登入成功") 
Trace.networking.error("無法連線到伺服器")

// UI 相關
Trace.ui.info("使用者點擊了登入按鈕")

// 資料庫相關
Trace.database.debug("成功從快取中讀取資料")
```

## 使用範例

```swift
import SwiftUI
import OSLog

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear() {
            
            // 網路相關
            Trace.networking.fault("使用者已登入成功") // 背景紅
            Trace.networking.error("無法連線到伺服器") // 背景黃

            // UI 相關
            Trace.ui.info("使用者點擊了登入按鈕")

            // 資料庫相關
            Trace.database.debug("成功從快取中讀取資料")
            
        }
    }
}


// 定義一個追蹤者的靜態結構
// 日誌追蹤（Log Trace）：在系統日誌中尋找特定的事件紀錄，以分析系統的行為或問題。
struct Trace {
    
    // 建立一個專門用於網路相關的日誌實例
    static let networking = Logger(subsystem: "com.company.app", category: "networking")
    
    // 建立一個專門用於 UI 相關的日誌實例
    static let ui = Logger(subsystem: "com.company.app", category: "ui")
    
    // 建立一個專門用於資料庫相關的日誌實例
    static let database = Logger(subsystem: "com.company.app", category: "database")
    
    // 動作
    static let action = Logger(subsystem: "com.company.app", category: "action")
    
    // 如果其他的分類，也可以在這裡增加
    // ...
    
}
```


## Logger 級別

| 級別 | 用途 | 預設是否持久化儲存 | 視覺化顯示（在 Console） |
| :--- | :--- | :--- | :--- |
| **debug** | 偵錯用細節資訊 | 否 | 預設 |
| **info** | 追蹤程式流程 | 否 | 預設 |
| **notice** | 值得注意的事件 | 是 | 預設 |
| **warning** | 潛在問題 | 是 | 黃色背景 |
| **error** | 可恢復的錯誤 | 是 | 黃色背景 |
| **fault** / **critical** | 嚴重、致命錯誤 | 是 | 紅色背景 |


## 不同模式下的輸出

```swift
#if DEBUG
    print("debug \(getAppVersion())")
#else
    print("release \(getAppVersion())")
#endif
```