### enumeration

```swift
enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king


    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}
let ace = Rank.ace
let aceRawValue = ace.rawValue
```

使用 enum 關鍵字來定義 enumeration，並且它帶有 raw value，type 為 Int。
它是一個撲克牌點數，只會有 1 到 13 點這樣的點數。

raw value 為 Int 時，若未指定起算值，預設為從 0 開始；有自定起算值的話，依序往下加 1。

而當列舉有 raw value 時，可以使用 Failable Initializers 來取得列舉的 instance。


### Failable Initializer
```swift
if let convertedRank = Rank(rawValue: 3) {
    let threeDescription = convertedRank.simpleDescription()
}
```


### without raw value

```swift
// 定義撲克牌的花色列舉
enum Suit {
    // 黑桃、紅心、方塊、梅花
    case spades, hearts, diamonds, clubs

    func simpleDescription() -> String {
        switch self {
        case .spades:
            return "spades"
        case .hearts:
            return "hearts"
        case .diamonds:
            return "diamonds"
        case .clubs:
            return "clubs"
        }
    }
}

// 當列舉不帶原始值時，沒有 Failable Initializers 
let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()
```


### values associated with the cas
```swift
enum ServerResponse {
    case result(String, String) 
    case failure(String)      
}

let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")

switch success {
    case let .result(sunrise, sunset):
        print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
    case let .failure(message):
        print("Failure...  \(message)")
}
// Prints "Sunrise is at 6:00 am and sunset is at 8:09 pm."
```


