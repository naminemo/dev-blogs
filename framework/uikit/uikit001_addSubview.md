
# addSubview

```swift
import UIKit // 引入 UIKit 框架，這是所有 iOS app 都需要的基礎庫

class ViewController: UIViewController { // 定義一個名為 ViewController 的類別，它繼承自 UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        // 在視圖載入記憶體後呼叫，通常在這裡進行初始化設定

        let viewArea = CGRect(x: 20, y: 20, width: 300, height: 300)
        // 建立一個 CGRect 結構體，用來定義視圖的矩形區域。
        // x: 20, y: 20 代表視圖左上角的座標，
        // width: 300, height: 300 代表視圖的寬度和高度。

        var uiView: UIView!
        uiView = UIView(frame: viewArea)
        // 宣告並初始化一個 UIView 物件，並將其 frame 設為剛剛定義的 viewArea

        uiView.backgroundColor = .yellow
        // 將 uiView 的背景顏色設定為黃色

        self.view.addSubview(uiView)
        // 將剛剛建立的 uiView 添加到當前 ViewController 的主視圖上，使其得以顯示
    }
}
```

## print information

```swift
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewArea = CGRect(x: 20, y: 20, width: 300, height: 300)
        
        var uiView: UIView!
        uiView = UIView(frame: viewArea)
        uiView.backgroundColor = .yellow
        
        printInfo(uiView)

        self.view.addSubview(uiView)
        
        printInfo(uiView)
    }

    func printInfo(_ ui: UIView) {
        print(ui.frame.origin.x)
        print(ui.frame.origin.y)
        print(ui.frame.size.width)
        print(ui.frame.size.height)
        print(ui.center.x)
        print(ui.center.y)
    }

    func printInfo2(_ ui: UIView) {
        print(ui.frame.minX)
        print(ui.frame.minY)
        
        print(ui.frame.midX)
        print(ui.frame.midY)
        
        print(ui.frame.maxX)
        print(ui.frame.maxY)
        
        print(ui.frame.width)
        print(ui.frame.height)
    }
}
```

# set Position and Size

```swift
import UIKit

class ViewController: UIViewController {

    // 使用 ! 表示：我知道 ui 現在沒有值，但沒關係，我保證之後會給。
    // 這個 UI 視圖會在 viewDidLoad() 中被初始化。
    var ui: UIView!
    
    // 這個方法在視圖載入記憶體後被呼叫，適合用來進行一次性的初始化設定。
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // --- 1. 初始化 ui 變數 ---
        // 建立一個初始的 CGRect 來定義 ui 的位置和大小。
        let initialFrame = CGRect(x: 20, y: 20, width: 300, height: 300)
        ui = UIView(frame: initialFrame)
        
        // --- 2. 設定 ui 的初始屬性 ---
        // 將 ui 的背景顏色設定為 systemIndigo，方便您看到它。
        ui.backgroundColor = .systemIndigo
        
        // --- 3. 將 ui 添加到主視圖上 ---
        // 必須將 ui 加入到當前視圖控制器的主視圖上，它才會被渲染顯示。
        self.view.addSubview(ui)
    }

    // 這個方法在視圖已經顯示在畫面上之後被呼叫，適合用來進行動態的調整或動畫。
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 在這裡，您可以改變 ui 的位置和大小，並觀察它的變化。
        // 這兩行程式碼會將 ui 的左上角移動到 (100, 200)。
        ui.frame.origin.x = 100
        ui.frame.origin.y = 200
        
        // 這兩行程式碼會將 ui 的寬度設為 100，高度設為 200。
        ui.frame.size.width = 100
        ui.frame.size.height = 200
    }
}
```

# 常見 iPhone 型號在垂直方向（Portrait）下，view 的 frame 寬度和高度

```swift
import UIKit

class ViewController: UIViewController {

    // 這個方法在視圖載入記憶體後被呼叫，適合用來進行一次性的初始化設定。
    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.frame.width, view.frame.height) // iPhone 16 Pro: 402, 874
        
     
//        iPhone 型號                   螢幕寬度    螢幕高度   備註
//                                     (width)    (height)
//
//        iPhone 16 Pro Max             440         956
//        iPhone 16 Plus                430         932
//        iPhone 16 Pro                 402         874
//        iPhone 16                     393         852
//        iPhone 15 Pro Max             430         932    動態島
//        iPhone 15 Pro /               393         852    動態島
//        iPhone 15 / 14 / 13 / 12      390         844    動態島/瀏海
//        iPhone 15 Plus / 14 Plus      430         932    動態島/瀏海
//        iPhone 14 Pro                 393         852    動態島
//        iPhone 13 Pro                 390         844    瀏海
//        iPhone SE (3rd generation)    375         667    無瀏海/傳統Home鍵
//        iPhone 8 Plus                 414         736    無瀏海/傳統Home鍵
    }

    // 這個方法在視圖已經顯示在畫面上之後被呼叫，適合用來進行動態的調整或動畫。
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}
```
