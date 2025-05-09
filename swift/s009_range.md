#### half-open range (open upper-bound)

使用 ..< 來決定 indexes 的範圍

```swift
var total = 0
for i in 0..<4 {
    total += i
}
print(total)
// Prints "6"
```