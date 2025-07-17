
# 點擊到按鈕背景顏色卻無作用

這是一個常遇見的問題，它把這些按鈕的觸摸範圍僅限於按鈕的文本內容，而我們是希望點擊按鈕的整個背景區域都能觸發動作。  
這在 SwiftUI 中是一個常見的小細節，通常是透過在 Button 的 label 內容上應用 contentShape 修飾符來解決。

例如以下這樣點擊到按鈕背景顏色是無作用的

```swift
Button("返回") {
    // 重置遊戲狀態，返回遊戲選擇頁面
    gameStarted = false
}
.font(.headline)
.foregroundStyle(.white)
.frame(maxWidth: .infinity)
.frame(height: 50)
.background(Color.blue)
.cornerRadius(12)
.contentShape(Rectangle())
.padding(.horizontal)
```

替換成以下寫法即可

```swift
Button {
    // 重置遊戲狀態，返回遊戲選擇頁面
    gameStarted = false
} label: {
    Text("返回")
        .font(.headline)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.blue)
        .cornerRadius(12)
}
.contentShape(Rectangle())
.padding(.horizontal)
```
