# GCD

透過 C 語言的 Grand Central Dispatch（GCD）函式來撰寫多執行緒（thread）程式，
可以將程式碼區段（Closure/Block）放到指定的『派遣佇列』（dispatch queue）中，
讓作業系統依照佇列的特性，來決定是否要建立執行緒，以及如何執行這些程式碼區段。  

PS.目前已經 swift 將 "派遣佇列" 封裝成 DispatchQueue 類別  

派遣佇列分為三種：
Main 佇列、Global 佇列（Concurrent佇列）、Private佇列（Serial佇列）

## Main

```swift
/*
 Main 佇列 ～
 
 每個應用程式只有一個 Main 佇列，也就是預設佇列。
 Main 佇列只會在 "同一個執行緒" 中，按照先進先出（FIFO）的方式依序執行（只能同步執行）。
 此外，Main 佇列還需要在使用者觸發 UI 元件上的各種事件時，呼叫對應的處理函式，
 因此 Main 佇列只能透過 async() 非同步函式，將程式碼區段放到佇列中。

 PS.非同步 asynchronous：可以跟其他程式碼同時執行
    同步 synchronous：不可以跟其他程式碼同時執行
 */


// 以下範例將『程式碼區段1』和『程式碼區段2』放到Main佇列中，
// 但都位於同一個執行緒，所以會先執行『程式碼區段1』，再執行『程式碼區段2』。
// 取得 Main 佇列（其中只有一個 main thread）
let mainQueue = DispatchQueue.main

// 把要執行的『程式碼區段1』以"非同步"的方式放置到Main佇列中
mainQueue.async {
    // 通常處理與 UI 相關的執行
    print("程式碼區段1")
    for i in 0..<10 {
        print(i)
    }
}

//把要執行的『程式碼區段2』以"非同步"的方式放置到Main佇列中
mainQueue.async {
    print("程式碼區段2")
    for j in 100..<110 {
        print(j)
    }
}

/*
 注意：
 在Main佇列使用async()函式，可能會導致使用者在操作UI元件時，出現反應延遲的現象。
 async()非同步函式會將一個『程式碼區段』放到佇列中，並且在呼叫之後就立刻返回（return）。
 另一個sync()同步函式則需等到裡面的『程式碼區段』執行完畢後才會返回，因此sync()函式不能用在Main佇列。
*/


// 如果像下列程式一樣，以"同步執行"的方式將『程式碼區段』放置到Main佇列中，
// 會阻斷主執行緒的執行，導致應用程式觸發執行階段錯誤。
// 所有透過 GCD 提送給 Main 佇列的『程式碼區段』都必須以非同步(asynchronously)的方式提送。
//
// mainQueue.sync {
//     print("程式碼區段3")
// }   //Excution Error
```

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

// 取得 Globle 佇列，並且指定為 "預設優先權"
let globalQueue = DispatchQueue.global(qos: .default)
globalQueue.sync {
    print("程式碼區段1(同步)：\(Thread.current)")
}

globalQueue.async {
    print("程式碼區段2(非同步)：\(Thread.current)")
    for i in 1..<21 {
        print(i)
    }
}

globalQueue.async {
    print("程式碼區段3(非同步)：\(Thread.current)")
    for j in 100..<121 {
        print(j)
    }
}
// 以下指令可以讓先前由Globle佇列所產生的『預設優先權執行緒』暫停二秒
globalQueue.async {
//    Thread.sleep(forTimeInterval: 2.0)
    print("還沒暫停兩秒")
    sleep(2)
    print("暫停後的程式碼區段")
}
```

```bash
程式碼區段1(同步)：<_NSMainThread: 0x600001704100>{number = 1, name = main}
程式碼區段2(非同步)：<NSThread: 0x60000170cac0>{number = 5, name = (null)}
程式碼區段3(非同步)：<NSThread: 0x600001716180>{number = 3, name = (null)}
還沒暫停兩秒
1
100
101
2
102
3
103
4
104
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
110
10
111
11
112
12
113
13
114
14
115
15
116
16
117
17
118
18
119
19
120
20
暫停後的程式碼區段
```

## private

```swift
/*
 Private 佇列（Serial佇列）～
 
 Private 佇列又稱 Serial 佇列，
 是自己建立佇列 (自己呼叫 DispatchQueue 的初始化方法)，
 建立 Private 佇列時需要指定一個參考標籤（此標籤僅供參考），
 每一個私有佇列的記憶體配置空間視為獨立，即使其標籤相同。
 "同一個" Private 佇列中只會有一個執行緒，
 所以在 "同一個" Private 佇列中的『程式碼區段』是以 FIFO 的方式依序執行。
 如果將『程式碼區段』放置在 "不同" 的 Private 佇列中，則這些『程式碼區段』就有機會被"同時"執行。
 利用 DispatchQueue 類別的初始化函式（帶 label 參數），可以建立 Private 佇列。
 利用 async() 非同步函式或 sync() 同步函式，
 可以把『程式碼區段』放到 "同一個 Private 佇列" 中執行，
 但不論使用哪一個函式，"同一個 Private 佇列"都只能以 FIFO 的方式依序執行。
 */
//建立兩個Private佇列，自行給定佇列的識別碼
let queue1 = DispatchQueue(label: "q1")
let queue2 = DispatchQueue(label: "q2")
//『程式碼區段1』和『程式碼區段2』將以FIFO的方式被執行
queue1.async {
    print("程式碼區段1(私有佇列5)：\(Thread.current)")
    sleep(5)    
}

queue1.async {
    print("程式碼區段2(私有佇列10)：\(Thread.current)")
    sleep(10)
}

//但在同一時間，『程式碼區段3』會同時被執行
queue2.async {
    print("程式碼區段3(私有佇列)\(Thread.current)")
}
```

## GCD 典型用法

以下兩種情境是 GCD 最典型的用法：

1. 如果你想要使用 GCD 進行非UI相關的任務，在不是 Main 佇列的佇列上使用 sync() 函式或 async() 函式。
2. 如果你想要進行UI相關的任務，則必須確保你操作UI的程式碼區段是位於 Main 佇列。
 (注意：若在 global queue 或private queue進行UI相關的任務，會觸發執行階段錯誤)

## 執行緒暫停

```swift
//============讓執行緒暫停============
//以下指令可以讓『主執行緒』暫停一秒
Thread.sleep(forTimeInterval: 1.0)
sleep(1)
```

