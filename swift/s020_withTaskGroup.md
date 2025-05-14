### withTaskGroup

```swift
let userIDs = await withTaskGroup(of: Int.self) { group in

    for server in ["primary", "secondary", "development"] {

        group.addTask {
            return await fetchUserID(from: server)
        }
    }

    var results: [Int] = []

    for await result in group {
        results.append(result)
    }

    return results
}
```
