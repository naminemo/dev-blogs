### gurad
```swift
import Foundation

var puzzle: [(String, Int)] = []
func isNumber(word: String, number: Int?) -> Bool {
    guard let number = number else {
        return false
    }
    puzzle.append((word, number))
    return true
}

let bool = isNumber(word: "A", number: nil)
let bool2 = isNumber(word: "B",number: 2)

print(bool)
print(bool2)
print(puzzle)
// Prints: false
// Prints: true
// Prints: ["B", 2]
```