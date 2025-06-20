
# Properties

```swift
class NamedShape {

    var numberOfSides: Int = 0
    var name: String

    init(name: String) {
       self.name = name
    }

    func simpleDescription() -> String {
       return "A shape with \(numberOfSides) sides."
    }
}
```

## getter and setter (compute the property)

```swift
class EquilateralTriangle: NamedShape {
    
    /* 
    以下有兩個屬性繼承自父類別
    var numberOfSides: Int = 0
    var name: String
    */
    // 屬性用 var 宣告的，為可讀可寫；屬性如果用 let 宣告，單純可讀。
    // 單邊長度
    var sideLength: Double = 0.0

    // 注意：初始化方法必須確認為所有缺值的"儲存屬性"補值！（不必考慮計算屬性）
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }

    // 計算屬性：總長度。注意計算屬性只能用 var 宣告，不可使用 let 宣告
    var perimeter: Double {
        // 取值段 getter
        get {
             return 3.0 * sideLength
        }
        // 設定段 setter（不能設值到自己的屬性 perimeter，因為此屬性為計算屬性）
        set {
            // 設定段的實作只能存值到其他的儲存屬性（由接取到的總邊長回算單邊長度）
            // 設定段以預設的 newValue 常數名稱接取設定值
            sideLength = newValue / 3.0
        }
    }

    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}

var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(triangle.perimeter)
// Prints "9.3"

triangle.perimeter = 9.9
print(triangle.sideLength)
// Prints "3.3000000000000003"
```

### Property Observer

```swift
// 下面的類別確保了其三角形的邊長始終與其正方形的邊長相同。
// 定義"三角形與正方形"類別
class TriangleAndSquare {

    var triangle: EquilateralTriangle {
        willSet {
            square.sideLength = newValue.sideLength
        }
    }

    var square: Square {
        willSet {
            triangle.sideLength = newValue.sideLength
        }
    }

    init(size: Double, name: String) {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}

var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
print(triangleAndSquare.square.sideLength)
// Prints "10.0"

print(triangleAndSquare.triangle.sideLength)
// Prints "10.0"

triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
print(triangleAndSquare.triangle.sideLength)
// Prints "50.0"

```
