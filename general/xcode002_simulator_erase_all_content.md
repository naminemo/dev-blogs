
#

## 清除模擬器上的資料

### 1. 開啟 Xcode

### 2.在上方選單列選擇

```bash
Xcode > Open Developer Tool > Simulator
```

### 3. 等 Simulator 開啟後，點選模擬器上方選單

```bash
Device > Erase All Content and Settings...
```

### 4. 出現提示對話框後，點選 Erase

這會清除整個模擬器的所有資料，包括 SwiftData 資料庫、App 安裝紀錄等。

模擬器會自動重開並恢復出廠狀態。  

---

## 清除所有模擬器的 Derived Data 快取資料

cmd + option + K
實際上是執行 Product > Clean Build Folder

它會移除 Xcode 為專案產生的 暫存編譯檔案

舊的 SwiftData / Core Data model 快取  
這對 migration 非常重要

可能還包括 Xcode 編譯器記憶的其他資訊等
