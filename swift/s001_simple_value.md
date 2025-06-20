#

## Simple Value

### 用  var 或 let 關鍵字來創造變數或常數

```swift
var myVariable = 42  
myVariable = 50
let myConstant = 42
```

### 型別推論

即使沒有明確指定型別，它還是依照值自動推論出型別出來

```swift
let implicitInteger = 70
let implicitDouble = 70.0
let explicitDouble: Double = 70
```

### 所需型別

值永遠不會自動轉換為另一種型別。
如果您需要將值轉換為其他型別，請明確地建立所需型別的實體 (instance) 。

```swift
let label = "The width is "
let width = 94
let widthLabel = label + String(width)    // String() 為 initializer 初始化方法
```

#### 實驗

嘗試從最後一行中刪除到 String 的轉換。 你得到了什麼錯誤？

```swift
let label = "The width is "
let width = 94
let widthLabel = label + width
// error: Binary operator '+' cannot be applied to operands of type 'String' and 'Int'
```
