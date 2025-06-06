### randomElement
從陣列隨機取得一個元素
.randomElement() 會回傳 optional type
所以如果確定能取得元素的話，就要使用 ! 來 unwrap
```swift
var arr = ["q", "w", "e", "n"]

print(arr.randomElement()!)

print(arr.count)
```

但如果陣列為空，又對它裡頭取隨機元素的話，是沒有回傳值的
既然沒有回傳資料，又對它 unwarp ，程式會發行執行階段錯誤
所謂的陣列為空，就是陣列裡頭沒有任何元素 
```swift
var arr: [String] = []
arr.randomElement()!
//erros: 
```

#### isEmpty
我們能使用 isEmpty 來判斷是不是空集合  
在這個範例中  
當 arr.isEmpty 返回 true 時，表示陣列 arr 中沒有任何元素  
也就是 [] 
```swift
var arr: [String] = []

if(arr.isEmpty){
    print("此陣列中沒有任何元素")
}
```

#### count
每個集合型別 (Array, Set, Dictionary) 都具有 count 屬性  
來取得集合元素的數量
```swift
var arr: [String] = []

if(arr.isEmpty){
    print(arr.count)
}
// Prints: 0
```


#### 最終寫法
```swift
var arr = ["q", "w", "e", "n"]
if !arr.isEmpty {
    print(arr.randomElement()!)
}
print(arr.count)
```


### 闗於陣列的 CRUD


#### 遍歷所有資料

```swift
var fruits = ["strawberries", "limes", "tangerines"]
for fruits in fruits {
    print(fruits)
}
```

#### 新增資料
```swift
fruits += ["apple"]
fruits.append("banana")
print(fruits)
fruits.insert("Guava", at: 3)
print(fruits)
```

#### 讀取資料
```swift
print(fruits[2])
// Prints: tangerines
```

#### 修改資料
```swift
fruits[2] = "papaya"
print(fruits[2])
// Prints: papaya
```


#### 刪除資料
```swift
let removedFruit = fruits.remove(at: 2)
print(fruits) 
print(removedFruit) 
```
