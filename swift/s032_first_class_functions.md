# first-class functions

在 Swift 中，函式被視為與整數、字串等資料類型地位相同。  
這通常為被稱為"一等函式"或"頭等函式"

這表示函式可以做到以下事情：

- 像值一樣被賦值給變數或常數： 就像下面範例中 operateNum = addNum 和 operateNum = multipleNum，可以把一個函式 "存" 在一個變數裡。
- 作為參數傳遞給其他函式： 可以寫一個函式，它的參數就是另一個函式。
- 作為返回值從其他函式中返回： 一個函式可以生成並返回另一個函式。

```swift
var operateNum: (Int, Int) -> Int

func addNum(_ x: Int, _ y: Int) -> Int {
    return x + y
}
operateNum = addNum
print(operateNum(2, 5))


func multipleNum(_ x: Int, _ y: Int) -> Int {
    return x * y
}
operateNum = multipleNum
print(operateNum(2, 5))
```

在這裡 (Int, Int) -> Int 就是一個函式型別 (function types)  
變數 operateNum 被稱為這種函式型別  
它只能存放符合這個簽名 (signature) 的函式
