# String

## reversed()

```swift
let originalString = "anbiron"
let reversedString = String(originalString.reversed())

print(reversedString) // 輸出: noribna
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
