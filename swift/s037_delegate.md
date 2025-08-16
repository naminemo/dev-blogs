# protocel and delegate

```swift
import UIKit

// 1. 定義協議 (Protocol) - 委託的工作內容
// `protocol` 就像一份合約，定義了某人或某物需要執行的「任務清單」。
// 這裡的 MoneyDelegate 協議定義了兩項任務：
//   - `make$4Boss()`: 為老闆賺錢
//   - `make$4Self()`: 為自己賺錢
protocol MoneyDelegate {
    func make$4Boss()
    func make$4Self()
}

// 2. 實作協議 (Conform to Protocol) - 執行任務的人
// `class Worker: MoneyDelegate` 表示 `Worker` 這個類別簽署了 `MoneyDelegate` 這份合約。
// 因此，它必須實作（implement）合約中定義的所有方法。
class Worker: MoneyDelegate {
    func make$4Boss() {
        print("make $$$$ Boss") // 實作「為老闆賺錢」
    }
    func make$4Self() {
        print("make $ Self") // 實作「為自己賺錢」
    }
}

// 3. 委託者 (Delegator) - 擁有工作，並將其委託給別人
// `Boss` 類別就是委託者。它本身有個工作（賺錢），但它不想親自做。
class Boss {
    // 這裡的 `delegate` 屬性是委託模式的核心。
    // 它是一個可選型別（Optional），因為老闆在剛開始時可能還沒有僱用員工。
    // 這個屬性的型別是 `MoneyDelegate`，這意味著它只能持有符合該協議的實例。
    var delegate: MoneyDelegate?
    
    // `hireStaffMakeMoney()` 是老闆的「啟動任務」方法。
    // 它不會親自執行任務，而是呼叫它的委託者（員工）來執行。
    // `delegate?.make$4Boss()` 使用了可選鏈結（Optional Chaining），
    // 確保只有在 delegate 存在時，才會呼叫 `make$4Boss()` 方法。
    func hireStaffMakeMoney() {
        delegate?.make$4Boss()
    }
}

// 4. 創建實例並建立連結
// 創建一個 Worker 實例，這個 Worker 具備賺錢的能力。
let worker = Worker()
// 直接呼叫 `make$4Self()` 證明 worker 可以為自己賺錢。
worker.make$4Self()

// 創建一個 Boss 實例，此時它還沒有員工。
let boss = Boss()

// 5. 設定委託關係
// 將 worker 實例指派給 boss 的 delegate 屬性。
// 這就建立了「委託」關係：老闆將賺錢的任務委託給了員工。
boss.delegate = worker

// 6. 執行任務
// 老闆呼叫 `hireStaffMakeMoney()`。
// 由於委託關係已經設定好，`boss` 會透過 `delegate` 屬性，
// 去呼叫 `worker` 實例中的 `make$4Boss()` 方法。
boss.hireStaffMakeMoney()
```

## delegate 模式的核心概念

這個範例完美地展示了 Delegate 模式的精髓：

1. 分離職責 (Separation of Concerns)：Boss（委託者）不用知道 Worker（委託者）是如何工作的，它只知道 Worker 能夠完成 MoneyDelegate 協議中定義的任務。
2. 鬆耦合 (Loose Coupling)：Boss 和 Worker 之間沒有直接的依賴關係。如果未來你想換一個 CFO 類別來執行 make$4Boss()，你只需要讓 CFO 也遵循 MoneyDelegate 協議，然後將 boss.delegate 設為 CFO 的實例即可。
3. 單一職責原則 (Single Responsibility Principle)：每個類別只負責自己的任務。Boss 只負責「委派」，而 Worker 只負責「執行」。

這個模式在 iOS 開發中非常常見，例如表格視圖（UITableView）的資料來源（dataSource）和代理（delegate），就是使用這個模式來讓控制器（Controller）管理視圖的行為和資料。
