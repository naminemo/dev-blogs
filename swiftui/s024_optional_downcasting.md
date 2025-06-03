


```swift
let ages: [Any] = ["Amy", 18, "Sam", 22, "Jim", 19]

var result = 0

for item in ages {
    if item is String {
        print("Adding \(item)'s age...")
    } else if let item = item as? Int {
        result += item
    }
}
print(result)
```

### Type Checking
在 if item is String 這段程式碼中  
is 運算符是一個型別檢查(Type Checking)   
也就是說，它只檢查是不是這種型別，然後回傳 true 或 false


### Optional Downcasting / Conditional Downcasting
#### as? (可選向下轉型 / 條件向下轉型)

在 Swift 中，as? 運算符用於可選向下轉型 (Optional Downcasting)，也稱為條件向下轉型 (Conditional Downcasting)。  
它會嘗試將一個類型的實例轉型成一個更具體的類型。  
如果轉型成功，它會返回一個目標類型的可選值 (Optional Value)；  
如果轉型失敗，因為該實例實際上不是目標類型，它會返回 nil。
因為 as? 返回的是一個可選值，所以通常需要 unwrap 這個結果才能使用轉型後的值

as? 是一種"安全"的嘗試轉型方式，因為即使轉型無效，它也不會導致程式崩潰。



### 區分 as? 和 as! 

 - as? (可選向下轉型)： 安全。返回一個可選值。失敗時返回 nil。
 - as! (強制向下轉型)： 不安全。強制進行向下轉型。如果轉型失敗，會觸發執行時錯誤 (Runtime Error) (導致你的應用程式崩潰)。只有在你百分之百確定向下轉型會成功時，才應該使用 as!。


使用 as! 的範例 (除非你百分之百確定，否則請勿這樣做！)：

```swift
let someValue: Any = 123
let myInt = someValue as! Int // 這會成功，因為 someValue 確實是 Int

let anotherValue: Any = "Hello"
// let myInt2 = anotherValue as! Int 
// errors: 'anotherValue' 是 String，不是 Int
```

總之，當你不確定轉換是否會成功時，as? 是你安全地嘗試將實例轉換為更具體類型的首選運算符。


### 練習

來小改一下原來的範例，判斷下對 as! 的熟悉度

```swift
import Foundation

let ages: [Any] = ["Amy", 18, "Sam", 22, "Jim", 19]

var result = 0

for item in ages {
  if item is String {
    print("Adding \(item)'s age...")
  } else  {
    let item = item as! Int
    result += item
  }
}
print(result)
```
目前這樣是不會出錯的，因為跑到 else 裡的剛好都是 Int 型別
不過如果把數字 18 改成 18.5 就會出錯了


```swift
import Foundation

let ages: [Any] = ["Amy", 18.5, "Sam", 22, "Jim", 19]

var result = 0

for item in ages {
  if item is String {
    print("Adding \(item)'s age...")
  } else  {
    let item = item as! Int
    result += item
  }
}
print(result)
```
