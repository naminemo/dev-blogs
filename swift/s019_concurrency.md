## Concurrency

### async
```swift
func fetchUserID(from server: String) async -> Int {

    // 以下模擬伺服器需要耗時的運作才能取得 UserID
    if server == "primary" {
        return 97
    }
    return 501
}
```


### await

```swift
func fetchUsername(from server: String) async -> String {
    
    let userID = await fetchUserID(from: server)
    
    if userID == 501 {
        return "John Appleseed"
    }
    return "Guest"
}

```


### async let

```swift
func connectUser(to server: String) async {

    async let userID = fetchUserID(from: server)
    async let username = fetchUsername(from: server)

    let greeting = await "Hello \(username), user ID \(userID)"

    print(greeting)
}
```

### Task

```swift
Task {
    await connectUser(to: "primary")
}
```

