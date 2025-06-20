### 變數作用域 (Variable Scope)

變數作用域指的是一個變數在程式碼的哪些部分是可用的、可被訪問的。  
在 Swift 中，作用域通常由以下結構定義：

  - 全域作用域 (Global Scope):  
  在任何函數、類別或結構之外定義的變數，可以在整個模組 (檔案) 中被訪問。
  - 模組作用域 (Module Scope):  
  一個 Swift 檔案本身就是一個模組，在該檔案中定義的全域變數屬於模組作用域。
  - 函數作用域 (Function Scope):  
  在函數內部定義的變數，只能在該函數內部被訪問。當函數執行結束時，這些變數通常會被銷毀。
  - 區塊作用域 (Block Scope):  
  在控制流程語句 (如 if 語句、for 迴圈、while 迴圈) 或閉包 (closure) 內部定義的變數，其作用域僅限於該語句塊或閉包內部。

```swift
let globalVariable = "我在全域作用域" // 全域變數

func myFunction() {

    let functionVariable = "我在函數作用域" // 函數作用域變數
    print(globalVariable)                  // 可以訪問全域變數

    if true {
        let blockVariable = "我在區塊作用域" // 區塊作用域變數
        print(functionVariable)             // 可以訪問函數作用域變數
        print(blockVariable)                // 可以訪問區塊作用域變數
    }

    // print(blockVariable) // errors: blockVariable 不在此作用域
}

// print(functionVariable) // errors: functionVariable 不在此作用域
myFunction() 
```

變數作用域定義了變數的**生存範圍**，不在該範圍則失效。
