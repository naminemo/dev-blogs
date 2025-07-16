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


#### 範例 - 拿隨機字串

```swift
import UIKit

/// 生成一個指定長度的隨機字串
/// - Parameter length: 隨機字串的長度
/// - Returns: 生成的隨機字串
func generateRandomString(characters: String, length: Int) -> String {
    let characters =  characters// 定義所有可能的字元
    let charactersArray = Array(characters) // 將字串轉換為字元陣列
    var randomString = ""

    for _ in 0..<length {
        // 從字元陣列中隨機選取一個字元並追加到結果字串
        randomString.append(charactersArray.randomElement()!)
    }
    return randomString
}

let numberOfStrings = 20 // 陣列中字串的數量
let stringLength = 10 // 每個隨機字串的長度

var randomStringsArray: [String] = [] // 宣告一個空的字串陣列

// 定義所有可能的字元
let characters1: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

// 生成 110 個隨機字串並加入到陣列中
for _ in 0..<numberOfStrings {
    let randomString = generateRandomString(characters: characters1, length: stringLength)
    randomStringsArray.append(randomString)
}

// 輸出陣列中的前幾個字串，以驗證結果
print("生成的隨機字串數量: \(randomStringsArray.count)")
print("前五個隨機字串:")
for i in 0..<min(5, randomStringsArray.count) {
    print(randomStringsArray[i])
}

// 驗證第一個字串的長度
if let firstString = randomStringsArray.first {
    //print("第一個字串的長度: \(firstString.count)")
}

print(randomStringsArray)



let dictionarySize = 100 // 可以更改這個數字來決定 Dictionary 中鍵值對的數量

var randomStringDictionary: [String: String] = [:] // 宣告一個空的 [String: String] 字典

let characters2: String = "123456789"


// 填充字典
for _ in 0..<dictionarySize {
    let key = generateRandomString(characters: characters2, length: stringLength)
    let value = generateRandomString(characters: characters1, length: stringLength)
    randomStringDictionary[key] = value
}

// 輸出字典內容以驗證結果
print("生成的字典大小: \(randomStringDictionary.count) 個鍵值對")
print("字典內容:")
for (key, value) in randomStringDictionary {
    print("  Key: \(key), Value: \(value)")
}

print(randomStringDictionary)

```
