### structure
```swift
struct Card {

    var rank: Rank    // 牌數
    var suit: Suit    // 花色

    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }

}


let threeOfSpades = Card(rank: .three, suit: .spades)  

let threeOfSpadesDescription = threeOfSpades.simpleDescription()  

Card(rank: .jack, suit: .diamonds).simpleDescription() 
```