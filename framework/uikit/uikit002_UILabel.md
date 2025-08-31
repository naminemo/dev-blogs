
# UILabel

## 單行顯示

```swift
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    // 這個方法在視圖載入記憶體後被呼叫，適合用來進行一次性的初始化設定。
    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.frame.width, view.frame.height)
        
        myLabel.text = "Hello, World!\nUIKit"
        myLabel.textColor = .red
        myLabel.textAlignment = .center
        myLabel.backgroundColor = .yellow
        myLabel.font = UIFont(name: "Arail", size: 30)
        
    }

}
```


## 多行顯示

```swift
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    // 這個方法在視圖載入記憶體後被呼叫，適合用來進行一次性的初始化設定。
    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.frame.width, view.frame.height)
        
        myLabel.text = "Hello, World!\nUIKit"
        myLabel.numberOfLines = 0
        myLabel.textColor = .red
        myLabel.textAlignment = .center
        myLabel.backgroundColor = .yellow
        myLabel.font = UIFont(name: "Arail", size: 30)
        
    }

}
```
