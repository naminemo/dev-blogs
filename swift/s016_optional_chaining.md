### Optional-Chaining

```swift
let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength 
```

#### give it a shot
```swift
var optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
optionalSquare = nil
let sideLength = optionalSquare?.sideLength
print(sideLength) 
```

#### give it a shot
```swift
let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let unwrsppedSideLength = optionalSquare!.sideLength 
```