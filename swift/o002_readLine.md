
macOS 
command Line

```swift
print("請輸入一個數字")

var result: Float

result = Float(readLine()!)!

if result > 0 {
    print("你輸入了正數")
}

if result < 0 {
    print("你輸入了負數")
}

if result == 0 {
    print("你輸入了0")
}

print("----OVER----")

```



```swift
import Foundation

print("---------猜數字遊戲---------")

print("請猜猜一個介於 0 至 9 之間的整數")

var 答案: Int = 6
var 玩家猜的: Int = Int(readLine()!)!

var 撒花: String = """
恭喜你答對了
｡:.ﾟヽ(*´∀`)ﾉﾟ.:｡
"""

var 殘念: String = """
可惜你答錯了
(T_T)
"""

if 答案 == 玩家猜的 {
    print(撒花)
} else {
    print(殘念)
}

print("---------GAME OVER---------")

```