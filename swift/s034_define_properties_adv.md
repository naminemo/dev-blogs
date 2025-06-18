# Swift 中兩種常見的屬性初始化與定義方式 (Two Common Ways to Initialize and Define Properties in Swift)

先來看看兩段程式碼

```swift
    let linkText: AttributedString = {
        var attributedLink = AttributedString("訪問我的網站")
        attributedLink.link = URL(string: "https://www.apple.com")
        attributedLink.foregroundColor = .blue
        attributedLink.underlineStyle = .single
        return attributedLink
    }()
```

```swift
    var styledText: AttributedString {
        var result = AttributedString()

        var helloPart = AttributedString("Hello")
        helloPart.foregroundColor = .red
        helloPart.font = Font.title.bold()
        result += helloPart

        result += AttributedString(" ")

        var worldPart = AttributedString("World")
        // 注意並不是使用 foregroundStyle
        worldPart.foregroundColor = .blue
        worldPart.font = Font.headline.italic()
        result += worldPart

        return result
    }
```

這兩段程式碼的結果類似，都產出一個 AttributedString，但在寫法上有所不同。

## 第一種它是立即執行的閉包 (Immediately Executed Closure)

它定義了一個常數 linkText，它的值是在定義時，透過執行一個 "立即執行的閉包" 來決定的。

{ ... } 是一個閉包（Closure）。  
它就像一個小型、匿名的函式，裡面包含了設定 AttributedString 的所有步驟。  
這個閉包會執行這些步驟，最終回傳一個完整設定好的 AttributedString 物件。
閉包後面的這對括號 () 非常重要。它表示 "立即執行" 前面定義的閉包。  
就像呼叫一個函式一樣，加上 () 就會讓它馬上跑起來，並把跑完的回傳值賦給 linkText。

這種方式常用於初始化常數 (let)，因為常數一旦被賦值就不能再改變。
當屬性初始化邏輯比較複雜，需要多行程式碼來設定時，但又想讓它在第一次定義時就完成所有設定，並且只執行一次。
這確保了 linkText 在被使用時，已經是一個完全設定好且不可變的 AttributedString。

## 第二種是計算屬性 (Computed Property)

它定義了一個變數 styledText，是一個計算型屬性 (Computed Property)。

它宣告了一個名為 styledText 的變數，其型別為 AttributedString。
{ ... } 大括號裡面的程式碼定義了這個屬性的 "取值器" (getter)。  
每次存取 (讀取) styledText 的時候，這段大括號裡面的程式碼都會被重新執行一遍，  
然後回傳一個全新的 AttributedString 物件作為它的值。

用途
通常用於變數 (var)，因為它的值是動態計算的。
當屬性的值不應該被儲存，而是需要每次被讀取時都重新計算時。
例如，如果 styledText 的內容會因為其他變數的改變而變化，那麼每次存取它時重新計算就能保證你得到的是最新的結果。
它不接受額外的括號 ()，因為它本身就是屬性定義的一部分，它的「執行」發生在你存取它時，而不是在定義時。  
