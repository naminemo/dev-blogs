
# 點擊挖空區域後顯示隱藏文字

點擊挖空區域後顯示隱藏文字。

## 學習重點

- Text 元件
- State 狀態變數
- onTapGesture 修飾器
- Help function 輔助函式

## 實作範例

```swift
import SwiftUI

struct ContentView: View {
    // 使用 @State 追蹤每個挖空文字的顯示狀態
    @State private var showHiddenText1 = false
    @State private var showHiddenText2 = false
    @State private var showHiddenText3 = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("事業單位勞工人數未滿") + 
            // 使用輔助函式處理挖空文字
            Text(hiddenText(text: "三十", isHidden: showHiddenText1)) 
                .onTapGesture {
                    showHiddenText1.toggle() // 點擊時切換顯示狀態
                } + 
            Text("人者，雇主或其代理人經職業安全衛生業務主管安全衛生教育訓練合格，") + 
            Text("得擔任該事業單位職業安全衛生業務主管。但屬第二類及第三類事業之事業單位，且勞工人數在") + 
            Text(hiddenText(text: "五", isHidden: showHiddenText2))
                .onTapGesture {
                    showHiddenText2.toggle()
                } + 
            Text("人以下者，得由經職業安全衛生教育訓練規則第三條附表一所列") + 
            Text(hiddenText(text: "丁種", isHidden: showHiddenText3))
                .onTapGesture {
                    showHiddenText3.toggle()
                } + 
            Text("職業安全衛生業務主管教育訓練合格之雇主或其代理人擔任。")
        }
        .padding()
    }

    // 輔助函式：根據 isHidden 參數返回顯示或隱藏的 Text
    private func hiddenText(text: String, isHidden: Bool) -> Text {
        if isHidden {
            return Text(text)
                .bold() // 顯示時可以加粗或其他樣式來區分
                .foregroundStyle(.blue) // 顯示時可以改變顏色
        } else {
            return Text("_______") // 挖空時顯示底線或其他符號
                .foregroundStyle(.gray) // 挖空時可以改變顏色
        }
    }
}

#Preview {
    ContentView()
}
```

### @State 變數

我們需要為每個隱藏/顯示的文字段落都創建了一個獨立的 @State 變數，  
例如：showHiddenText1、showHiddenText2、showHiddenText3。這些變數是布林值，  
用於追蹤該段文字當前是隱藏還是顯示狀態。  
當 @State 變數的值改變時，SwiftUI 會自動重新渲染受其影響的視圖，從而達到文字顯示或隱藏的效果。

### Text 串接

在 SwiftUI 中，可以使用 + 運算符來串接多個 Text 元件，形成一個完整的文字段落。  
這樣可以讓我們精確地控制每個小段文字的顯示行為。

### onTapGesture 修飾器

將 .onTapGesture 修飾符應用於每個代表挖空區域的 Text 視圖上。
當使用者點擊該區域時，閉包內部的程式碼會執行，並呼叫 .toggle() 方法來切換對應 @State 變數的布林值，true 變 false，false 變 true。

### 輔助方法 hiddenText(text:isHidden:)

為了避免重複程式碼，我們創建了一個名為 hiddenText 的輔助方法。
這個方法接收兩個參數，text 原始文字內容 和 isHidden 是否隱藏。  

根據 isHidden 的值，它會返回兩種不同的 Text 視圖。

- 如果 isHidden 為 true，則顯示原始文字，也可以選擇性地添加樣式。例如 .bold() 或 .foregroundStyle(.blue) 來使其在顯示時更突出。
- 如果 isHidden 為 false，則顯示挖空後的提示，例如 "_______"；也可以添加樣式，例如 .foregroundStyle(.gray)。

