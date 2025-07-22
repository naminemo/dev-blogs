
macOS 
command Line

# 輸入一個數字

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

# 猜數字

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

# 

```swift
let label = """
輸入兩個整數，本程式將為你計算"和"、"差"、"積"、"商"
"""
print(label)

var x: Int
var y: Int

print("第一數")
x = Int(readLine()!)!
print("第二數")
y = Int(readLine()!)!

print("你輸入了 \(x) 和 \(y)")
var result: Int = x + y

print("兩數之和：\(result)")
print("兩數之差：\(x - y)")
print("兩數之積：\(x * y)")
print("兩數之商：\(Float(x / y))")
```

#

```swift
var name: String
var age: Int
var height: Int
var weight: Float

print("請輸入你的名字:")
name = readLine()!

print("請輸入你的年齡:")
age = Int(readLine()!)!

print("請輸入你的體重：")
weight = Float(readLine()!)!

print("喔! \(name), 你好. 原來現在你 \(age) 歲啦! \(weight) 公斤重喔")
```
