#### functions

```swift
func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet(person: "Bob", day: "Tuesday")
```

使用 func 關鍵字來宣告 function
使用 -> 來分隔 parameter names and types 和回傳 Type
函式的回傳是沒有名字的，只有 Type
像上面這個例子就是回傳 String Type


#### argument label

```swift
func greet(_ person: String, on day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet("John", on: "Wednesday")\
```

可以不鍵入 parameter names 或加入 argument label
不想鍵入 parameter names 在前面加入 _
想客製  argument label 就加入自己的命名

####  return multiple values from a function

```swift
func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0

    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }

    return (min, max, sum)
}

let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
print(statistics.sum)
// Prints "120"

print(statistics.2)
// Prints "120"
```


#### nested function
```swift
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()
```
