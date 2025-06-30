# HStack, VStack

```swift
import SwiftUI

// 內容視圖，用於顯示表格
struct ContentView: View {
    let rows = 6 // 定義
    let columns = 3 // 定義

    var body: some View {
        // 使用 VStack 垂直堆疊行
        VStack(spacing: 15) { // row 之間的間距
            // 為每一行建立一個 HStack
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 5) { // 列之間的間距
                    // 為每一列建立一個 Text 視圖作為單元格
                    ForEach(0..<columns, id: \.self) { column in
                        Text("R\(row+1)C\(column+1)") // 顯示單元格內容 (例如: R1C1, R1C2...)
                            .font(.system(size: 14)) // 設定字體大小
                        // 設定單元格最小寬度和高度，並讓寬度自適應
                            .frame(minWidth: 10, maxWidth: .infinity, minHeight: 30)
                            .padding(8) // 單元格內邊距
                            .background(Color.blue.opacity(0.2)) // 單元格背景顏色
                            .cornerRadius(8) // 單元格圓角
                    }
                }
            }
        }
        .padding() // 整個表格的外邊距
    }
}

#Preview {
    ContentView()
}
```

![ss 2025-06-26 15-22-35](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-06-26%2015-22-35.jpg)

## Grid

```swift
import SwiftUI

struct ContentView: View {
    let rows = 6 // 定義資料 row
    let columns = 3 // 定義 colum
    
    var body: some View {
        // 使用 ScrollView 包裹 Grid，以便在內容超出螢幕時可以滾動
        ScrollView {
            // 使用 Grid 容器來創建表格佈局 (iOS 16+)
            // 將 horizontalSpacing 和 verticalSpacing 設為 0，透過單元格的邊框來建立視覺分隔
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                // MARK: - 表頭 row
                GridRow {
                    ForEach(0..<columns, id: \.self) { column in
                        Text("欄位 \(column+1)") // 表頭內容，例如 "欄位 1"
                            .font(.system(size: 14, weight: .bold)) // 表頭字體加粗
                        // 讓表頭高度略高
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 40)
                            .padding(8) // 內邊距
                            .background(Color.gray.opacity(0.3)) // 表頭背景色
                            .border(Color.gray, width: 1) // 表頭邊框
                    }
                }
                
                // MARK: - 資料
                ForEach(0..<rows, id: \.self) { row in
                    GridRow { // 每一行都使用 GridRow
                        // 迴圈創建列 (單元格)
                        ForEach(0..<columns, id: \.self) { column in
                            Text("R\(row+1)C\(column+1)") // 顯示單元格內容 (例如: R1C1, R1C2...)
                                .font(.system(size: 14)) // 設定字體大小
                            // 設定單元格最小寬度和高度，並讓寬度自適應
                                .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                                .padding(8) // 單元格內邊距
                                .background(Color.green.opacity(0.1)) // 單元格背景顏色
                                .border(Color.gray, width: 0.5) // 單元格邊框，比表頭細一些
                        }
                    }
                }
            }
            .padding() // 整個表格的外邊距
        }
    }
}

#Preview {
    ContentView()
}
```

![ss 2025-06-26 15-23-47](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-06-26%2015-23-47.jpg)

## Grid - 讓資料從 Array 傳入

```swift
import SwiftUI

// 內容視圖，使用 Grid 呈現表格並從二維陣列讀取資料
struct ContentView: View {
    // 定義一個二維陣列來存放表格的資料，第一列作為表頭
    @State private var tableData: [[String]] = [
        ["欄位1", "欄位2", "欄位3", "欄位4"], // 這是表頭資料
        ["Apple", "Banana", "Cherry", "Date"],
        ["Grape", "Honeydew", "Kiwi", "Lemon"],
        ["Orange", "Pear", "Quince", "Raspberry"],
        ["Ugli Fruit", "Quince", "Pear", "Xigua"],
        ["Alpha", "Beta", "Gamma", "Delta"],
        ["Eta", "Theta", "Iota", "Kappa"]
    ]

    // 從資料陣列推斷總行數和列數
    var totalRows: Int { tableData.count }
    var columns: Int { tableData.first?.count ?? 0 } // 如果沒有資料則為 0

    var body: some View {
        // 使用 ScrollView 包裹 Grid，以便在內容超出螢幕時可以滾動
        ScrollView {
            // 使用 Grid 容器來創建表格佈局 (iOS 16+)
            // 將 horizontalSpacing 和 verticalSpacing 設為 0，透過單元格的邊框來建立視覺分隔
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                // MARK: - 表頭行
                GridRow {
                    // 表頭資料從 tableData 的第一列 (索引為 0) 取得
                    ForEach(0..<columns, id: \.self) { column in
                        Text(tableData[0][column]) // 從 tableData[0] 讀取表頭內容
                            .font(.system(size: 14, weight: .bold)) // 表頭字體加粗
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 40) // 表頭高度略高
                            .padding(8) // 內邊距
                            .background(Color.gray.opacity(0.3)) // 表頭背景色
                            .border(Color.gray, width: 1) // 表頭邊框
                    }
                }

                // MARK: - 資料行
                // 資料行從 tableData 的第二列 (索引為 1) 開始循環
                ForEach(1..<totalRows, id: \.self) { row in // 注意這裡從 1 開始
                    GridRow { // 每一行都使用 GridRow
                        // 迴圈創建列 (單元格)
                        ForEach(0..<columns, id: \.self) { column in
                            // 確保索引沒有超出陣列範圍，如果超出則顯示空白
                            if row < tableData.count && column < tableData[row].count {
                                Text(tableData[row][column]) // 從二維陣列中讀取資料
                                    .font(.system(size: 14)) // 設定字體大小
                                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30) // 設定單元格最小寬度和高度，並讓寬度自適應
                                    .padding(8) // 單元格內邊距
                                    .background(Color.green.opacity(0.1)) // 單元格背景顏色
                                    .border(Color.gray, width: 0.5) // 單元格邊框，比表頭細一些
                            } else {
                                Text("") // 如果索引超出範圍則顯示空白單元格
                                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 30)
                                    .padding(8)
                                    .background(Color.red.opacity(0.1)) // 可以用不同顏色標示錯誤或空白
                                    .border(Color.gray, width: 0.5)
                            }
                        }
                    }
                }
            }
            .padding() // 整個表格的外邊距
        }
    }
}

#Preview {
    ContentView()
}
```
