
```swift
var numbers = [20, 19, 7, 12]
```

#### closure
```swift
numbers.map({ (number: Int) -> Int in
    let result = 3 * number
    return result
})
```

Type inference: If a closure doesn’t specify a parameter list or return type because they can be inferred from context.


#### refer to parameters by number instead of by name
```swift
let sortedNumbers = numbers.sorted { $0 > $1 }
print(sortedNumbers)
// Prints "[20, 19, 12, 7]"
```