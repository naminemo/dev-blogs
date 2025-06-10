#### function can return function

```swift
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }    
    return addOne  
}

var increment = makeIncrementer()
increment(7)
```

#### function as arguments
```swift
func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}
var numbers = [20, 19, 7, 12]
hasAnyMatches(list: numbers, condition: lessThanTen)
```


### parameter name vs argument label

參數名稱 (Parameter Name)

- 用途：這是在函式/方法內部用來指代傳入值的名稱。它是給函式實作（implementer）看的，也就是在函式內部使用。
- 位置：在函式定義中，寫在引數標籤的後面 (如果有的話)。

引數標籤 (Argument Label)
- 用途：這是在呼叫函式/方法時，用來標識傳入值的名稱。它是給函式呼叫者 (caller) 看的，讓呼叫時的語句更像自然語言，提高程式碼可讀性。
- 位置：在函式定義中，寫在參數名稱的前面。
- 預設行為：如果沒有明確指定引數標籤，Swift 會預設使用參數名稱作為引數標籤。

```swift
func greet(person name: String, from hometown: String) {
    // name 和 hometown 是參數名稱，用於函式內部
    print("Hello \(name)! Glad you're from \(hometown).")
}

// 函式呼叫
greet(person: "Alice", from: "Taipei")
//      ^       ^       ^       ^
//      |       |       |       |
//   引數標籤    值    引數標籤    值
```

如果一個參數沒有明確指定引數標籤，Swift 會預設使用參數名稱作為引數標籤。

