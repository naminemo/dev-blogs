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