# thread


## global

```swift
/*
 Globle 佇列（Concurrent佇列）
 Globle 佇列又稱 Concurrent 佇列，每個 App 都有六種不同優先權的 Globle 佇列，
 分別為
 userInteractive、userInitiated、default(預設優先權)、
 utility、background(背景優先權)、unspecified。
 其中的"背景優先權"，是指這個佇列的程式碼所需要的 CPU 資源比較低，
 所以比較適合在背景執行，並不是指"背景優先權"只能在背景執行。
 
 利用 async() 非同步函式或 sync() 同步函式，可以將『程式碼區段』放到 Globle 佇列中。
 注意：
 1. Globle佇列可以容納"多個執行緒"，透過呼叫 async() 非同步函式，
    就會讓iOS產生一個新的執行緒來執行『程式碼區段』。
 2. 如果利用 sync() 同步函式來將『程式碼區段』放到 Globle 佇列中，
    iOS 則會視實際的運行狀況來決定是否要產生新的執行緒。
   （當沒有新的執行緒，就不能保證可以跟別人同時運行）
*/

// 觀察主要佇列的名稱
print("主執行緒：\(Thread.current)")

// 以背景優先權取得 global 佇列
let global = DispatchQueue.global(qos: .background)

// 以下程式碼區段因為使用背景優先權，所以 cpu 比較忙碌時，會較慢執行
global.async {
    print("自己的區段一：\(Thread.current)")
}

// 觀察主要佇列的名稱
print("主執行緒：\(Thread.current)")

// 轉換到global佇列執行同步程式，觀察目前的佇列名稱
DispatchQueue.global().sync {
    print("區段一.2(同步)：\(Thread.current)")
}
// 注意：
// 當使用同步函式將程式碼區段丟入 global 佇列執行時，
// 可能會被系統轉回主要執行緒執行！
```

Prints:

```bash
主執行緒：<_NSMainThread: 0x600001708000>{number = 1, name = main}
自己的區段一：<NSThread: 0x600001705540>{number = 5, name = (null)}
主執行緒：<_NSMainThread: 0x600001708000>{number = 1, name = main}
區段一.2(同步)：<_NSMainThread: 0x600001708000>{number = 1, name = main}
```

```swift
// 以下範例將三個程式碼區段放到 Globle 佇列中，
// "程式碼區段1" 使用 sync() 同步函式，
// "程式碼區段2" 和 "程式碼區段3" 則使用 async() 非同步函式，
// 所以會先等待 "程式碼區段1" 執行完畢之後，
// 才會"同時"去執行 "程式碼區段2" 和 "程式碼區段3"。

// 取得Globle佇列，並且指定為『預設優先權』
let globalQueue = DispatchQueue.global(qos: .default)
globalQueue.sync {
    print("程式碼區段1(同步)：\(Thread.current)")
}

globalQueue.async {
    print("程式碼區段2(非同步)：\(Thread.current)")
    for i in 1..<51 {
        print(i)
    }
}

globalQueue.async {
    print("程式碼區段3(非同步)：\(Thread.current)")
    for j in 100..<151 {
        print(j)
    }
}
```

```bash
程式碼區段1(同步)：<_NSMainThread: 0x600001708100>{number = 1, name = main}
程式碼區段2(非同步)：<NSThread: 0x600001738200>{number = 5, name = (null)}
程式碼區段3(非同步)：<NSThread: 0x60000170ccc0>{number = 6, name = (null)}
1
100
101
2
102
3
103
104
4
105
5
106
6
107
7
108
8
109
9
...
```

