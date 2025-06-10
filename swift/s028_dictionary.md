### dictionary
```swift
var words: [String:Int] = ["A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6]
words["X"] = 1 
let oldWord = words.updateValue(5, forKey: "A")!
print(oldWord)
// Prints: 1
print(words)
// Pirnt: 這裡是隨機取出，順序通常會不一樣了
```

```swift
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
print(type(of: airports["YYZ"]))
// Optional<String>
print(airports)
// ["DUB": "Dublin", "YYZ": "Toronto Pearson"]
airports["YYZ"] = nil
print(airports)
// ["DUB": "Dublin"]

// 移除並不存在的元素不會出錯
airports.removeValue(forKey: "我是沒有的key")
print(airports)
// ["DUB": "Dublin"]
```

#### 快速把鍵或值轉成陣列
```swift
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
let airportCodes = [String](airports.keys)
print(airportCodes)
// airportCodes is ["LHR", "YYZ"]

let airportNames = [String](airports.values)
print(airportNames)
// airportNames is ["London Heathrow", "Toronto Pearson"]
```