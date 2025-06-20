## 好用的字串功能

#### 字串插值

```swift
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples + oranges) pieces of fruit."
```

#### 三個雙引號

```swift
let quotation = """
        Even though there's whitespace to the left,
        the actual lines aren't indented.
            Except for this line.
        Double quotes (") can appear without being escaped.

        I still have \(apples + oranges) pieces of fruit.
        """
```

#### split

```swift
let dataString = "蘋果,香蕉,橘子,梨子,葡萄,芒果,鳳梨,西瓜,哈密瓜,草莓,藍莓,火龍果,奇異果"
let fruitsArray = dataString.split(separator: ",", maxSplits: 3)
print(fruitsArray)
// ["蘋果", "香蕉", "橘子", "梨子,葡萄,芒果,鳳梨,西瓜,哈密瓜,草莓,藍莓,火龍果,奇異果"]
```

```swift
let messyString = "  Hello   World  ! "
let cleanedParts = messyString.split(separator: " ", omittingEmptySubsequences: true)
let rawParts = messyString.split(separator: " ", omittingEmptySubsequences: false)

print(cleanedParts)
// ["Hello", "World", "!"]
print(rawParts)
// ["", "", "Hello", "", "", "World", "", "!", ""]
```
