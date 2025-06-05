#### arrays and dictionaries

```swift
var fruits = ["strawberries", "limes", "tangerines"]
fruits[1] = "grapes"

var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
 ]
occupations["Jayne"] = "Public Relations"

```


#### add elements
```swift
fruits.append("blueberries")
print(fruits)
// Prints "["strawberries", "grapes", "tangerines", "blueberries"]"
```

####  empty array or dictionary
```swift
fruits = []
occupations = [:]
```

#### an empty array or dictionary to a new variable
```swift
let emptyArray: [String] = []
let emptyDictionary: [String: Float] = [:]

```


### for-in loop
```swift
var fruits = ["strawberries", "limes", "tangerines"]

for fruit in fruits {
    print(fruit)
}

print("=====")

for (index, value) in fruits.enumerated() {
    print(fruits[index], value)
}
```