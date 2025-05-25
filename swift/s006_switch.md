#### switch

```swift
let vegetable = "red pepper"
switch vegetable {
    case "celery":
        print("Add some raisins and make ants on a log.")
    case "cucumber", "watercress":
        print("That would make a good tea sandwich.")
    case let x where x.hasSuffix("pepper"):
        print("Is it a spicy \(x)?")
    default:
        print("Everything tastes good in soup.")
}
// Prints "Is it a spicy red pepper?"
```

法規名稱：	勞工健康保護規則
修正日期：	民國 110 年 12 月 22 日
第 17 條
雇主對在職勞工，應依下列規定，定期實施一般健康檢查：
 - 一、年滿六十五歲者，每年檢查一次。
 - 二、四十歲以上未滿六十五歲者，每三年檢查一次。
 - 三、未滿四十歲者，每五年檢查一次。


```swift
var age = 40
switch age {
    case 65...:
        print("年滿六十五歲者，每年檢查一次")
    case 40..<65:
        print("四十歲以上未滿六十五歲者，每三年檢查一次。")
    case ..<40:
        print("未滿四十歲者，每五年檢查一次。")
    default:
        print("這裡是 default")
}
```

也可以更嚴謹且更合理一些
```swift
var age = 40
switch age {
    case 65...150:
        print("年滿六十五歲者，每年檢查一次")
    case 40..<65:
        print("四十歲以上未滿六十五歲者，每三年檢查一次。")
    case 0..<40:
        print("未滿四十歲者，每五年檢查一次。")
    default:
        print("請輸入合理範圍")
}
```
這裡利用 default 來攔不合理的輸入範圍值。

而更好更安全的管控就是源頭管理，在一開始便限制使用者只能輸入 0~150 的數字。Swift 也能利用型別註記或型別宣告來限制輸入為數字。 
這樣可以更加避免無法預料的意外發生。
