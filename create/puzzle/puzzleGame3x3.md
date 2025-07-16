# puzzle game 3 x 3

```swift
// ContentView.swift
import SwiftUI

// MARK: 主視圖，應用程式的入口點
struct ContentView: View {
    var body: some View {
        // ZStack 允許視圖疊加，這裡用於背景和遊戲內容的疊加
        ZStack {
            // 設定黑色透明度為 0.8 的背景，並忽略安全區域，使其佔滿整個螢幕
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
            
            // VStack 用於垂直堆疊內容
            VStack {
                // 遊戲標題
                Text(
                    "Puzzle Game\n\(Text("SwiftUI").foregroundStyle(.blue))"
                ) // 顯示 "Puzzle Game" 和藍色的 "SwiftUI"
                    .foregroundStyle(.green) // 標題文字顏色為綠色
                    .font(.system(size: 35)) // 設定字體大小為 35
                    .multilineTextAlignment(.center) // 多行文字置中對齊
                    .kerning(-1) // 調整字元間距，使其更緊湊
                
                Spacer() // 將標題推到頂部，使其與 PuzzleView 分開
            }
            // 嵌入拼圖遊戲的核心視圖
            PuzzleView()
        }
    }
}

// MARK: 拼圖小塊的資料模型
// 符合 Identifiable 協定以便在 ForEach 中使用
struct PuzzlePiece: Identifiable {
    var id = UUID() // 每個拼圖小塊的唯一識別符
    var image: Image // 拼圖小塊的圖片
    var correctPosition: CGPoint // 拼圖小塊的正確位置
    var currentPosition: CGPoint // 拼圖小塊目前的拖曳位置
}

// MARK: 拼圖遊戲的主視圖
struct PuzzleView: View {
    @State private var pieces: [PuzzlePiece] = [] // 儲存所有拼圖小塊的狀態
    @State private var isCompleted: Bool = false // 遊戲是否完成的狀態
    
    var gridSize = 3 // 拼圖的網格大小（例如 3x3）
    var pieceSize: CGFloat = 100 // 每個拼圖小塊的尺寸
    
    var body: some View {
        // GeometryReader 允許我們獲取父視圖的尺寸資訊
        GeometryReader { geometry in
            ZStack {
                // 背景參考圖片（低透明度），用於輔助玩家拼圖
                if let referenceImage = UIImage(named: "cat") { // 嘗試載入名為 "cat" 的圖片
                    Image(uiImage: referenceImage) // 使用載入的 UIImage 建立 Image 視圖
                        .resizable() // 圖片可調整大小
                        .aspectRatio(contentMode: .fit) // 保持圖片比例並適應框架
                        .frame(width: pieceSize * CGFloat(gridSize), // 設定參考圖片的寬度
                               height: pieceSize * CGFloat(gridSize)) // 設定參考圖片的高度
                        .opacity(0.2) // 設定透明度為 0.2
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // 將參考圖片置中
                }
                
                // 遍歷所有拼圖小塊並顯示它們
                ForEach($pieces) { piece in // 使用 $pieces 綁定，以便在 PuzzlePieceView 中修改 piece 的狀態
                    PuzzlePieceView(
                        piece: piece, // 傳遞單個拼圖小塊的綁定
                        pieceSize: pieceSize, // 傳遞拼圖小塊的尺寸
                        pieces: $pieces, // 傳遞所有拼圖小塊的綁定，用於檢查完成狀態
                        isCompleted: $isCompleted // 傳遞遊戲完成狀態的綁定
                    )
                    // 調整每個拼圖小塊的偏移量，使其位於拼圖區域的中心
                    .offset(x: geometry.size.width / 2 - pieceSize * CGFloat(gridSize) / 2,
                            y: geometry.size.height / 2 - pieceSize * CGFloat(gridSize) / 2)
                }
            }
            // 當視圖出現時，設定拼圖
            .onAppear {
                setupPuzzle(screenSize: geometry.size) // 根據螢幕尺寸初始化拼圖
            }
            // 當 isCompleted 為 true 時顯示完成提示框
            .alert(isPresented: $isCompleted) {
                Alert(title: Text("Congratulations!"), // 提示框標題
                      message: Text("Puzzle completed."), // 提示框訊息
                      dismissButton: .default(Text("OK"))) // 預設的關閉按鈕
            }
        }
    }

    // 準備拼圖遊戲的函數
    func setupPuzzle(screenSize: CGSize) {
        guard let uiImage = UIImage(named: "cat") else { return } // 確保 "cat" 圖片存在

        // 將原始圖片分割成小塊
        let images = splitImageIntoPieces(image: uiImage, gridSize: gridSize)
        pieces = [] // 清空現有的拼圖小塊陣列
        
        // 計算拼圖區域的寬度和高度
        let puzzleAreaWidth = pieceSize * CGFloat(gridSize)
        let puzzleAreaHeight = pieceSize * CGFloat(gridSize)

        // 計算拼圖區域的左上角座標
        let minX = (screenSize.width - puzzleAreaWidth) / 2
        let minY = (screenSize.height - puzzleAreaHeight) / 2

        // 建立每個拼圖小塊
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                // 計算每個小塊的正確位置（基於網格）
                let correctPosition = CGPoint(
                    x: CGFloat(col) * pieceSize + pieceSize / 2,
                    y: CGFloat(row) * pieceSize + pieceSize / 2
                )

                // 將拼圖小塊隨機放置在拼圖區域內
                let currentPosition = CGPoint(
                    x: CGFloat.random(in: minX...(minX + puzzleAreaWidth - pieceSize)), // 隨機 X 座標
                    y: CGFloat.random(in: minY...(minY + puzzleAreaHeight - pieceSize)) // 隨機 Y 座標
                )
                
                // 建立 PuzzlePiece 物件並添加到陣列中
                let piece = PuzzlePiece(
                    image: Image(uiImage: images[row * gridSize + col]), // 取得對應的圖片小塊
                    correctPosition: correctPosition, // 設定正確位置
                    currentPosition: currentPosition // 設定初始隨機位置
                )
                pieces.append(piece)
            }
        }
        // 打亂拼圖小塊的順序，使其初始位置是隨機的
        pieces.shuffle()
    }
    
    // MARK: Helper function
    // 將圖片分割成多個小塊的輔助函數
    // (這個函數應該放在 PuzzleView 之外或作為擴展，這裡假設它已經在某處定義)
    // 為了程式碼的完整性，目前將其添加到此處，此 function 在原始程式碼中可能不存在
    func splitImageIntoPieces(image: UIImage, gridSize: Int) -> [UIImage] {
        var images: [UIImage] = []
        guard let cgImage = image.cgImage else { return [] }
        
        let width = cgImage.width
        let height = cgImage.height
        let pieceWidth = width / gridSize
        let pieceHeight = height / gridSize
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let rect = CGRect(
                    x: col * pieceWidth,
                    y: row * pieceHeight,
                    width: pieceWidth,
                    height: pieceHeight
                )
                if let croppedCGImage = cgImage.cropping(to: rect) {
                    images.append(UIImage(cgImage: croppedCGImage))
                }
            }
        }
        return images
    }
}

// MARK: 單個拼圖小塊的視圖
struct PuzzlePieceView: View {
    @Binding var piece: PuzzlePiece // 綁定單個拼圖小塊的資料，以便修改其位置
    let pieceSize: CGFloat // 拼圖小塊的尺寸
    @GestureState private var dragOffset = CGSize.zero // 拖曳時的偏移量

    @Binding var pieces: [PuzzlePiece] // 綁定所有拼圖小塊的陣列，用於檢查完成狀態
    @Binding var isCompleted: Bool // 綁定遊戲完成狀態

    var body: some View {
        piece.image // 顯示拼圖小塊的圖片
            .resizable() // 圖片可調整大小
            .frame(width: pieceSize, height: pieceSize) // 設定小塊的尺寸
            // 根據目前位置和拖曳偏移量設定小塊的位置
            .position(x: piece.currentPosition.x + dragOffset.width,
                      y: piece.currentPosition.y + dragOffset.height)
            .gesture( // 添加拖曳手勢
                DragGesture()
                    // 更新拖曳偏移量，使小塊跟隨手指移動
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    // 當拖曳結束時
                    .onEnded { value in
                        // 更新小塊的目前位置
                        piece.currentPosition.x += value.translation.width
                        piece.currentPosition.y += value.translation.height
                        checkIfInCorrectPosition() // 檢查小塊是否在正確位置
                    }
            )
    }

    // 檢查拼圖小塊是否已移動到正確位置附近
    func checkIfInCorrectPosition() {
        // 如果目前位置與正確位置的距離小於 pieceSize / 2，則認為其在正確位置
        if abs(piece.currentPosition.x - piece.correctPosition.x) < pieceSize / 2 &&
           abs(piece.currentPosition.y - piece.correctPosition.y) < pieceSize / 2 {
            
            piece.currentPosition = piece.correctPosition // 將小塊吸附到正確位置
            checkIfPuzzleCompleted() // 檢查整個拼圖是否完成
        }
    }

    // 檢查所有拼圖小塊是否都已在正確位置
    func checkIfPuzzleCompleted() {
        // 使用 allSatisfy 檢查所有拼圖小塊是否都滿足在正確位置的條件
        let allCorrect = pieces.allSatisfy {
            abs($0.currentPosition.x - $0.correctPosition.x) < pieceSize / 2 &&
            abs($0.currentPosition.y - $0.correctPosition.y) < pieceSize / 2
        }
        if allCorrect {
            isCompleted = true // 如果所有小塊都在正確位置，則設定遊戲完成
        }
    }
}

// Preview Provider，用於在 Xcode 的預覽畫布中顯示 ContentView
#Preview {
    ContentView()
}
```


```swift
// UIImage+Split
import UIKit

// 為 UIImage 類別添加一個擴展 (Extension)，以增加新的功能
extension UIImage {
    // 定義一個名為 `split` 的方法，用於將圖片分割成指定行數和列數的小圖片
    // 參數：rows (Int) - 分割後的列數
    // 參數：columns (Int) - 分割後的行數
    // 返回值：[UIImage] - 包含所有分割後小圖片的陣列
    func split(intoRows rows: Int, columns: Int) -> [UIImage] {
        var grid: [UIImage] = [] // 初始化一個空的 UIImage 陣列，用於儲存分割後的小圖片
        
        // 計算每個分割小塊的寬度
        // 將原始圖片的寬度除以指定的列數
        let width = self.size.width / CGFloat(columns)
        // 計算每個分割小塊的高度
        // 將原始圖片的高度除以指定的行數
        let height = self.size.height / CGFloat(rows)

        // 雙重迴圈遍歷每一行和每一列，以生成每個小圖片
        for row in 0..<rows { // 外層迴圈遍歷行
            for col in 0..<columns { // 內層迴圈遍歷列
                // 根據當前行和列計算每個小圖片的裁剪矩形 (CGRect)
                let rect = CGRect(x: CGFloat(col) * width, // 小圖片的 X 座標
                                  y: CGFloat(row) * height, // 小圖片的 Y 座標
                                  width: width, // 小圖片的寬度
                                  height: height) // 小圖片的高度
                
                // 嘗試從原始圖片的 CGImage 中裁剪出指定矩形區域
                // `cgImage` 是 UIImage 的底層 Core Graphics 圖像表示
                // `cropping(to:)` 方法會返回一個新的 CGImage (如果裁剪成功)
                if let cropped = self.cgImage?.cropping(to: rect) {
                    // 如果裁剪成功，則使用裁剪後的 CGImage 創建一個新的 UIImage
                    // 並將其添加到 `grid` 陣列中
                    grid.append(UIImage(cgImage: cropped))
                }
            }
        }
        return grid // 返回包含所有分割後小圖片的陣列
    }
}

// 定義一個獨立的函數 `splitImageIntoPieces`，用於將圖片分割成指定網格大小的小塊
// 這個函數主要是作為 `UIImage` 擴展中 `split` 方法的一個便利包裝
// 參數：image (UIImage) - 要分割的原始圖片
// 參數：gridSize (Int) - 網格的尺寸 (例如，如果 gridSize 為 3，則表示 3x3 的網格)
// 返回值：[UIImage] - 包含所有分割後小圖片的陣列
func splitImageIntoPieces(image: UIImage, gridSize: Int) -> [UIImage] {
    // 直接呼叫 UIImage 擴展中定義的 `split` 方法，將行數和列數都設定為 `gridSize`
    return image.split(intoRows: gridSize, columns: gridSize)
}
```

