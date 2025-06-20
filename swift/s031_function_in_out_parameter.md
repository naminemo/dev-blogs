# in-out parameter

```swift
var name = "Jim"
func renameToHelen(_ name: String) {
    name = "Helen" 
    // 函式裡面的 name 是常數，無法再重新指定值
    // error: cannot assign to value: 'name' is a let constant
}
print(name)
```

```swift
var name = "Jim"
func renameToHelen(_ name: inout String) {
    name = "Helen"
}
print(name)
// Prints: Jim
```

```swift
var name = "Jim"
func renameToHelen(_ value: inout String) {
    value = "Helen"
}
renameToHelen(&name)
print(name)
// Prints: Helen
```
