


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