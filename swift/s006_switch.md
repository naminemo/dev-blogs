# switch

```swift
let vegetable = "red pepper"
switch vegetable {
    case "celery":
        print("Add some raisins and make ants on a log.")
    case "cucumber", "watercress":
        print("That would make a good tea sandwich.")
    case let x where x.hasSuffix("pepper"):
        print("Is it a spicy \(x)?")
    default:
        print("Everything tastes good in soup.")
}
// Prints "Is it a spicy red pepper?"
```

法規名稱：勞工健康保護規則  
修正日期：民國 110 年 12 月 22 日
第 17 條
雇主對在職勞工，應依下列規定，定期實施一般健康檢查：

- 一、年滿六十五歲者，每年檢查一次。
- 二、四十歲以上未滿六十五歲者，每三年檢查一次。
- 三、未滿四十歲者，每五年檢查一次。

```swift
var age = 40
switch age {
    case 65...:
        print("年滿六十五歲者，每年檢查一次")
    case 40..<65:
        print("四十歲以上未滿六十五歲者，每三年檢查一次。")
    case ..<40:
        print("未滿四十歲者，每五年檢查一次。")
    default:
        print("這裡是 default")
}
```

也可以更嚴謹且更合理一些

```swift
var age = 40
switch age {
    case 65...150:
        print("年滿六十五歲者，每年檢查一次")
    case 40..<65:
        print("四十歲以上未滿六十五歲者，每三年檢查一次。")
    case 0..<40:
        print("未滿四十歲者，每五年檢查一次。")
    default:
        print("請輸入合理範圍")
}
```

這裡利用 default 來攔不合理的輸入範圍值。

而更好更安全的管控就是源頭管理，在一開始便限制使用者只能輸入 0~150 的數字。Swift 也能利用型別註記或型別宣告來限制輸入為數字。 
這樣可以更加避免無法預料的意外發生。

## 更進階的技巧

```swift
var num = 69
switch num {
    case _ where num % 2 == 0:
        print("Is even")
    default:
        print("Is odd")
}
```

## 配合 enum 使用

### 一般情況

下面這個範例列出了所有 case  
所以會有 default

```swift
enum Field {
    case a, b, c
}

// 假設我們有一個 Field 類型的值
let someField: Field = .a 

switch someField {
    case .a:
        print("這是 A 欄位")
    case .b:
        print("這是 B 欄位")
    case .c:
        print("這是 C 欄位")
}
```

在 Swift 中，switch 語句對於列舉通常需要窮舉所有可能的案例。

### 使用 default

```swift
enum Field {
    case a, b, c, d // 假設新增了 'd'
}

let anotherField: Field = .d

switch anotherField {
    case .a:
        print("這是 A 欄位")
    case .b:
        print("這是 B 欄位")
    default: // 處理所有其他未明確列出的案例
        print("這是其他欄位 (包含 C 或 D)")
}
```

## 使用 .none

但在實際開發時，應該盡量不要用 default
若真要寫 default，先在寫完你所認知的 case 後  
讓編譯器來檢查提醒你有沒有漏寫 case

不用 default 的好處：

- 編譯器會提醒你有沒有漏寫 case（保證完整性）
- 可讀性更好，每個 case 都能明確處理

只有在這些情況下才建議用 default：

- enum 有很多 case，不可能一一列出
- 你真的只在意部分 case，其他都一樣處理
- 在處理未知輸入，例如像 JSON 解析或錯誤容錯時

### .none 代表 Optional 沒有值

```swift
var name: String? = nil

if name == .none {
    print("是 nil")
}
// Prints: 是 nil
```

```swift
Optional.none == nil // ✅ 等價
```

## 在 switch 中使用 .none

這裡的 focusedField 是一個 Optional<Field>  
所以 .none 就是 nil，表示目前沒有任何欄位聚焦。

```swift
@FocusState private var focusedField: Field?
enum Field { case a, b, c }

switch focusedField {
case .a: inputA.append(digit)
case .b: inputB.append(digit)
case .c: inputC.append(digit)
case .none: break  // <- 這就是 Optional 為 nil 的情況
}
```

- case .none 是 Swift 標準的 Optional 匹配語法
- 從 Swift 1.x 就支援
- 它本質上就是「判斷是否為 nil」

簡單版

以下都是窮舉了所有情況  
所以不會有 default

```swift
enum Field { case a, b, c }
let value: Field? = .a
switch value {
case .a: print("A")
case .b: print("B")
case .c: print("C")
case .none: print("沒有值")  // 明確判斷 Optional.none
}
```

等同

```swift
enum Field { case a, b, c }
let value: Field? = .a
switch value {
case .a: print("A")
case .b: print("B")
case .c: print("C")
case nil: print("沒有值")  // 明確判斷 Optional.none
}
```

其實 .none 也是一個具體 case
