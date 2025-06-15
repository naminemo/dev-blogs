
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




在 Array、Set、Dictionary 中
Dictionary 和 Set 都必須遵循 Hashable 協定，但 Array 並不要求遵循 Hashable 協定。
Hashable 協定是 Set 中元素為了能夠被 Set 正確管理而必須遵循的條件。

Set：集合的特性是「元素唯一且無序」。為了快速判斷一個元素是否存在於集合中，以及快速添加或刪除元素，Set 需要對其包含的每個元素進行雜湊 (hashing) 運算，並使用雜湊值來確定元素在內部儲存中的位置。因此，Set 的元素必須是 Hashable 的。

Dictionary：字典的特性是「鍵值對 (key-value pair)，鍵唯一且無序」。字典需要快速查找給定鍵對應的值。同樣地，它會對鍵進行雜湊運算，以便快速定位到對應的值。因此，Dictionary 的鍵必須是 Hashable 的。

Hashable 協定要求類型能夠提供一個雜湊值 (hashValue)，並且能夠進行相等性比較 (==)。
