#### control flow - loop

```swift
let individualScores = [75, 43, 103, 87, 12]

var teamScore = 0

for score in individualScores {
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}

print(teamScore)
// Prints "11"
```
以 for-in 遍歷（遍尋）陣列的內容，score 為 區域常數，只存在於 for-in 的作用域中
其實這裡是 for score: Int in individualScores，但型別能由 individualScores 推斷出來


####  write if after the equal sign (=) of an assignment 

```swift
let scoreDecoration = if teamScore > 10 {
    "🎉"
} else {
    ""
}
print("Score:", teamScore, scoreDecoration)
// Prints "Score: 11 🎉"
```

