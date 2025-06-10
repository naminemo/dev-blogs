#

## Array 進階用法

### map

map(_:) 轉換陣列中的每個元素
對陣列中的每個元素應用一個轉換閉包（closure），並返回一個包含轉換後元素的新陣列。
它不會修改原陣列。返回的新陣列可以包含與原陣列不同類型的元素。

#### map 範例1 - 數字平方

使用明確的參數定義

```swift
let numbers = [2, 3, 5]

// 明確定義參數名 (例如: 'number')
let squaredNumbers = numbers.map { (number: Int) -> Int in
    return number * number
}
print(numbers)
// [2, 3, 5]

print(squaredNumbers)
// [4, 9, 25]
```

簡寫參數名 (Shorthand Argument Names)

```swift
let numbers = [2, 3, 5]
let squaredNumbers = numbers.map { $0 * $0 }
print(squaredNumbers) 
```

#### 函數式程式設計思想 (Functional Programming)

從更高的層次來看，map 函數本身是函數式程式設計的一個核心概念。它是一種高階函數，接受一個函數 (閉包) 作為參數，並對集合中的每個元素應用這個函數，最終返回一個新的集合，而不改變原有的集合。

這種風格強調：

- 不可變性 (Immutability)：原來的 numbers 陣列沒有被改變。
- 數據轉換 (Data Transformation)：將一個集合轉換為另一個集合。

#### map 範例2 - 字串轉大寫

```swift
let names = ["Alice", "Bob", "Charlie"]
let uppercasedNames = names.map { $0.uppercased() }
print(uppercasedNames) 
// ["ALICE", "BOB", "CHARLIE"]
```

#### map 範例3 - 從物件陣件提取指定屬性為單一簡單型別陣列

```swift
struct Product {
    let name: String
    let price: Double
}
let products = [
    Product(name: "Apple", price: 1.2),
    Product(name: "Banana", price: 0.8),
    Product(name: "Orange", price: 1.5)
]
// 只拿出產品名稱並組合為字串陣列
let productNames = products.map { $0.name }
print(productNames) 
// ["Apple", "Banana", "Orange"]
print(type(of: productNames))
// Array<String>
```

#### map 範例4 - 對元素作型別轉換

```swift
let numbers = [2, 3, 5]
// 將 Int 轉換為 Double
let doubles = numbers.map(Double.init) 
print(doubles) 
// [2.0, 3.0, 5.0]
```

### filter

filter(_:) 根據條件篩選元素  
對陣列中的每個元素應用一個判斷閉包，並返回一個包含所有滿足條件元素的新陣列。  
它不會修改到原陣列

#### filter 範例1 - 挑出偶數

```swift
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let evenNumbers = numbers.filter { $0 % 2 == 0 }
print(evenNumbers) 
// [2, 4, 6, 8, 10]
```

#### filter 範例2 - 過濾出特定長度的單字

```swift
let words = ["gogoro", "banana", "cat", "dog", "yamaha"]
let shortWords = words.filter { $0.count <= 4 }
print(shortWords) 
// ["cat", "dog"]
```

#### filter 範例3 - 過濾出及格的分數

```swift
let scores = [75, 45, 90, 55, 88]
let passingScores = scores.filter { $0 >= 60 }
print(scores)
// [75, 45, 90, 55, 88]
print(passingScores) 
// [75, 90, 88]
```

### reduce

reduce(_:_:) 將陣列元素聚合為一個單一值
將陣列中的所有元素結合 (聚合) 成一個單一的返回值。  
它需要一個初始值和一個用於結合元素與目前聚合結果的閉包。
主要用於計算總和、連接字串、扁平化陣列等。

#### reduce 範例1 - 計算數字和

```swift
let numbers = [1, 2, 3, 4, 5]
let sum = numbers.reduce(0) { currentSum, number in
    currentSum + number
}
print(sum)
```

#### reduce 範例2 - 將字串陣列連接成一個單一字串

```swift
let words = ["Hello", " ", "Swift", "!"]
let greeting = words.reduce("") { combinedString, word in
    combinedString + word
}
print(greeting)
// Hello Swift!
```

#### reduce 範例3 - 計算購物車的總價

```swift
struct Item {
    let name: String
    let price: Double
    let quantity: Int
}
let cart = [
    Item(name: "Milk", price: 2.5, quantity: 2),
    Item(name: "Bread", price: 3.0, quantity: 1),
    Item(name: "Eggs", price: 4.0, quantity: 12)
]
let totalCost = cart.reduce(0.0) { total, item in
    total + (item.price * Double(item.quantity))
}
print("購物車總價：\(totalCost)") 
// 輸出: 購物車總價：56.0
```

#### reduce 範例4 - 將多個陣列扁平化 (flatten)

```swift
let nestedArrays = [[1, 2], [3, 4, 5], [6]]
let flatArray = nestedArrays.reduce([]) { result, array in
    result + array
}
print("扁平化後的陣列：\(flatArray)") 
// 輸出: 扁平化後的陣列：[1, 2, 3, 4, 5, 6]
```

### sort vs sorted

sort

- 原地排列
- 直接修改原陣列，使其按照指定的順序排序。  

sorted  

- 返回新陣列，使其按照指定的順序排序。
- 不直接修改原陣列

```swift
var numbers = [3, 11, 42, 18, 51, 9, 2, 6]
numbers.sort()
print(numbers)
// [2, 3, 6, 9, 11, 18, 42, 51]
numbers.sort(by: >)
print(numbers)
// [51, 42, 18, 11, 9, 6, 3, 2]
```

```swift
var numbers = [3, 11, 42, 18, 51, 9, 2, 6]
numbers.sorted()
print(numbers.sorted())
// [2, 3, 6, 9, 11, 18, 42, 51]
print(numbers)
// [3, 11, 42, 18, 51, 9, 2, 6]
numbers.sorted(by: >)
print(numbers.sorted(by: >))
// [51, 42, 18, 11, 9, 6, 3, 2]
print(numbers)
// [3, 11, 42, 18, 51, 9, 2, 6]
```

在 apple design guidelines 裡也有提到  
什麼是 Mutating 以及什麼是 Nonmutating

直接使用動詞的命令式來表達對其變異
例如
array.append("x")
array.sort()

使用動詞的過去式或進行式來表達不可變異
也就是使用後綴字加上"ed"或"ing"的方式
既然本身是不可變異
那代表使用了該方法會回傳一個新的變異後的值
newArray = array.sorted()