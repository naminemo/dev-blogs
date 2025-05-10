

### class
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

### create an instance
```swift
var shape = Shape()
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()
```
 
 ### use init to create an initializer
 ```swift
class NamedShape {

    var numberOfSides: Int = 0
    var name: String   // 注意：這裡並沒有給初始值

    init(name: String) {
       self.name = name
    }

    func simpleDescription() -> String {
       return "A shape with \(numberOfSides) sides."
    }
}
 ```
由於屬性 name 並沒有給初始值，這在開發上會出錯，可在初始化方法上完成賦予初始值。
並且注意到是如何使用 self 來區分傳入的 argument 帶到 property。

### deinit
```swift
class NamedShape {

    var numberOfSides: Int = 0
    var name: String   // 注意：這裡並沒有給初始值

    init(name: String) {
       self.name = name
    }

    // 宣告反初始化方法（使用 deinit 關鍵字）
    deinit {
        // 在此可以執行一些清理作業
        print("\(name)記憶體被釋放！")
    }

    func simpleDescription() -> String {
       return "A shape with \(numberOfSides) sides."
    }
}

var namedShape: NamedShape? = NamedShape(name: "3D")

namedShape = nil
```

#### give it a shot
若把上面 namedShape 的 type annotation 拿掉，會有什麼變化?



