# loop - dictionary

```swift
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]

var largest = 0

for (_, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}

print(largest)
// Prints "25"
```


# updateValue

```swift
var students: [String: Int] = [
    "foo": 18,
    "goo": 19,
    "hoo": 22,
]

students.updateValue(10, forKey: "foo")
print(students["foo"]!)

let oldValue1 = students.updateValue(0, forKey: "woo")
let oldValue2 = students.updateValue(0, forKey: "xoo")!
let oldValue3: Int? = students.updateValue(0, forKey: "hoo")

print(oldValue1)
print(oldValue2)
print(oldValue3)

```
