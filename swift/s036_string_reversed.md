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
