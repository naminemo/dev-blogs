
# 點擊挖空區域後顯示隱藏文字

點擊挖空區域後顯示隱藏文字。

## 預計實現範例

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
            hiddenText(text: "三十", isHidden: showHiddenText1) 
                .onTapGesture {
                    showHiddenText1.toggle() // 點擊時切換顯示狀態
                } + 
            Text("人者，雇主或其代理人經職業安全衛生業務主管安全衛生教育訓練合格，") + 
            Text("得擔任該事業單位職業安全衛生業務主管。但屬第二類及第三類事業之事業單位，且勞工人數在") + 
            hiddenText(text: "五", isHidden: showHiddenText2)
                .onTapGesture {
                    showHiddenText2.toggle()
                } + 
            Text("人以下者，得由經職業安全衛生教育訓練規則第三條附表一所列") + 
            hiddenText(text: "丁種", isHidden: showHiddenText3)
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

注意： 
此時程式是無法成功啟動的，但若你把有 onTapGesture 修飾器的程式碼拿掉，它就能成功啟動。

```swift
struct ContentView: View {

    @State private var showHiddenText1 = false
    @State private var showHiddenText2 = false
    @State private var showHiddenText3 = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("事業單位勞工人數未滿") +
            // 使用輔助函式處理挖空文字
            hiddenText(text: "三十", isHidden: showHiddenText1) +
            Text("人者，雇主或其代理人經職業安全衛生業務主管安全衛生教育訓練合格，") +
            Text("得擔任該事業單位職業安全衛生業務主管。但屬第二類及第三類事業之事業單位，且勞工人數在") +
            hiddenText(text: "五", isHidden: showHiddenText2) +
            Text("人以下者，得由經職業安全衛生教育訓練規則第三條附表一所列") +
            hiddenText(text: "丁種", isHidden: showHiddenText3) +
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
            return Text("＿＿") // 挖空時顯示底線或其他符號
                .foregroundStyle(.gray) // 挖空時可以改變顏色
        }
    }
}
```

### 輔助方法 hiddenText(text:isHidden:)

為了避免重複程式碼，我們創建了一個名為 hiddenText 的輔助方法。
這個方法接收兩個參數，text 原始文字內容 和 isHidden 是否隱藏。  

根據 isHidden 的值，它會返回兩種不同的 Text 視圖。

- 如果 isHidden 為 true，則顯示原始文字，也可以選擇性地添加樣式。例如 .bold() 或 .foregroundStyle(.blue) 來使其在顯示時更突出。
- 如果 isHidden 為 false，則顯示挖空後的提示，例如 "_______"；也可以添加樣式，例如 .foregroundStyle(.gray)。

## 理解 SwiftUI Text 串接的型別限制

SwiftUI 的視圖系統非常注重型別。  
Text("abc") + Text("123") 這樣的語法之所以能夠工作，  
是因為 Text 結構體內部為 Text 與 Text 之間的相加操作重載了 + 運算符。  
這個重載方法的返回值仍然是 Text 型別。

目前會有個問題，那就是 Text(...) + Text(...)  
當使用 + 號來做串接時，要相同型別才可以  
下面這樣是可以的

```swift
Text("abc") +
Text("123")
    .bold()
    .font(.title)
```

但下面這樣就不行了  
Xcode 會報錯  
Cannot convert value of type 'some View' to expected argument type 'Text'  
它指出了 Text 型別無法與 some View 做串接  
一旦加了 .onTapGesture，這個 Text 就被包裝成一個新的、更複雜的視圖型別 some View，  
而不再是純粹的 Text 型別，  
所以不能跟 Text 相加，  
使用 + 串接只支援 Text + Text。

```swift
Text("abc") +
Text("123")
    .bold()
    .font(.title)
    .onTapGesture {
        print("tap me")
    }
```

## 關於排列

由於 SwiftUI 預設是由容器來控制 Layout  
但目前並沒有類似 FlowLayout 這樣的元件  
如果使用 HStack 的話，由於 HStack 的作用，當分段一多，會造成了內容水平均分了  

```swift
HStack(spacing: 0) { 
    Text("abc")
    Text("123")
        .bold()
        .font(.title)
        .onTapGesture {
            print("tap me")
        }
}
```

如果使用 VStack 的話，就變成垂直排列而已，遇到"填空區"直接變成了斷行，文字不會連在一起  

