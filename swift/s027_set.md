
在 Array 中，它能由字面量來型別推斷
例如

```swift
var arr = ["a", "b", "c"]
print(type(of: arr))
// Print: Array<String>
```

但在 Set 中，無法使用這樣的方式來做型別推論
必須在多一個註記為 Set，然後再由它推論論型別  

```swift
var set: Set = ["a", "b", "c"]
print(type(of: set))
// Print: Set<String>
```


在 Array 中


