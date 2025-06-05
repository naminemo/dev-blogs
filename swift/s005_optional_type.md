#### optional type
```swift
var optionalString: String? = "Hello"
print(optionalString == nil)
// Prints "false"

var optionalName: String? = "John Appleseed"
var greeting = "Hello"
if let name = optionalName {
    greeting = "Hello, \(name)"
}
```

在以前傳統的作法，當遇到值為 nil，會做反向處理

```swift
if optionalName != nil {
    greeting = "Hello, \(optionalName!)"
}
```

在 swift 中，optional types 用來表示一個變數可能有一個值，也可能沒有值 (nil) 。
當一個變數被宣告為 optional types 時，它可以在任何時候被賦值為 nil 。


#### 實驗
將 optionalName 更改為nil。你得到了什麼問候？如果 optionalName 為 nil 請新增一個 else 子句，設定不同的問候語。
```swift
var optionalName: String? = nil
var greeting = "Hello"
if let name = optionalName {
    greeting = "Hello, \(name)"
} else {
     greeting = "Hello, everyone!"
}
```


#### ?? operator

```swift
let nickname: String? = nil
let fullName: String = "John Appleseed"
let informalGreeting = "Hi \(nickname ?? fullName)"
```

#### a shorter spelling to unwrap a value
```swift
if let nickname {
    print("Hey, \(nickname)")
}
// Doesn't print anything, because nickname is nil.
```


注意：
當我們使用驚嘆號的地方不對的話很有可能會造成系統當機。
也就是說，執行到驚嘆號出錯的地方會瑣住讓系統動不了。

為了避免此錯誤發生我們常有以下的寫法

```swift
if 帶有驚嘆號的變數 {
    有拿到
} esle {
    如果拿不到
}
```


###  猜猜什麼型別?
```swift
let myConstant = Int("42")
print(type(of: myConstant))
// Prints: Int?
```


```swift
func divide(_ number: Int, by divisor: Int) -> Int? {
    guard divisor != 0 else {
        return nil
    }
    return number / divisor
}

let divisionResult = divide(5, by: 0)
print(type(of: divisionResult))
// Prints: Int?
```