### 變數遮蔽 (Variable Shadowing)
變數遮蔽發生在一個內部作用域中定義的變數與外部作用域中定義的變數具有相同名稱時。  
此時，內部作用域的變數會"遮蔽(shadow)"外部作用域的同名變數。  
這意味著在內部作用域中，當你使用該變數名稱時，你將會引用到內部作用域的變數，而不是外部作用域的變數。

```swift
let name = "外部作用域的名字" // 外部作用域的變數

func greet() {
    let name = "內部作用域的名字" // 內部作用域的變數，遮蔽了外部的 name
    print("你好，\(name)")       
}

greet()      // Prints: "你好，內部作用域的名字"
print(name)  // Prints: "外部作用域的名字"
```
在這個例子中，greet() 函數內部定義的 name 變數遮蔽了全域的 name 變數。   
在 greet() 函數內部使用 name 時，會優先使用函式內部定義的 name。


另外來看有傳入引數的函式  
在 Swift 中，函式的參數是常數 (let)，無法直接修改。
但我們能在函式內部定義一個同名的可變變數 (var)，並將參數的值賦給它，這樣就可以在函數內部修改這個局部副本 (local copy)。

```swift
func processValue(value: Int) {
    var value = value // 遮蔽了參數 value，現在這個 value 是可變的局部變數
    value += 10
    print("處理後的值: \(value)")
}

processValue(value: 5) // Prints: "處理後的值: 15"
```

雖然變數遮蔽在某些情況下很有用，但也可能導致程式碼閱讀困難，甚至引入潛在的錯誤，因為同一個名稱可能在不同上下文中指向不同的變數。因此，在使用變數遮蔽時需要謹慎，並確保程式碼意圖清晰。

其實上面的範例也就是跟下面的範例是一樣的意思
```swift
func processValue(value: Int) {
    var sum = 0
    sum = value + 10
    print("處理後的值: \(sum)")
}

processValue(value: 5) // Prints: "處理後的值: 15"
```
變數遮蔽則處理了當不同作用域中存在同名變數時的**命名衝突**問題，它允許**內部作用域的變數優先於外部作用域的同名變數**。
