

#### class
```swift
// 宣告 Shape 類別
class Shape {

    // 可讀可寫的"實體儲存屬性" (Instance Stored Property) 的宣告：形狀有幾邊
    var numberOfSides = 0

    // 方法：形狀有幾邊的敘述
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

```

#### create an instance
```swift
var shape = Shape()
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()
```