# String

## reversed()

```swift
let originalString = "anbiron"
let reversedString = String(originalString.reversed())

print(reversedString) // 輸出: noribna
print(originalString) // 輸出: anbiron
```

## 字串相加

直接用字串相加的方式就可以了

```swift
var greeting = "Hello, playground"

var result = ""

for s in greeting {
    print(type(of: s)) // Character
    result = String(s) + result
}

print(result)
// dnuorgyalp ,olleH
```

## 使用 reduce

跟字串相加其實都是相同的原理

```swift
var s = "hello"

var result = s.reduce("") { first, second in
    String(second) + String(first)
}

print(result)
```

## 使用 endIndex

```swift
var str = "hello"
var reversedStr = ""

// endIndex
// A string’s “past the end” position—that is, 
// the position one greater than the last valid subscript argument.
// 字串的「結尾之後」的位置，即比最後一個有效下標參數大一的位置。
var currentIndex = str.endIndex
print(str.endIndex)   // 5
print(str.startIndex) // 0

// 迴圈直到 currentIndex 到達字串的開頭
while currentIndex > str.startIndex {
    // 將 currentIndex 向前移動一位，這樣它會指向當前要處理的字元
    currentIndex = str.index(before: currentIndex)
    print("currentIndex:\(currentIndex)")
    // 取得當前索引的字元並添加到結果字串
    reversedStr.append(str[currentIndex])
}

print(reversedStr) // 輸出: olleh
```
