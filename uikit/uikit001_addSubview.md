
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

