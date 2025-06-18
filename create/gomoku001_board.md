## 畫出五子棋的棋盤

#### 先做出一個背景色 

```swift
import SwiftUI

struct GoBoardView: View {
    
    var body: some View {
        
        VStack {
            
            GeometryReader { geometry in
                let minSize = min(
                    geometry.size.width, geometry.size.height)
                
                ZStack {
                    
                    // 背景色
                    Rectangle()
                        .fill(Color.brown)
                        .frame(width: minSize, height: minSize)
                    
                }// end of ZStack
                .frame(width: minSize, height: minSize)
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
                                
            }
            
        } // end of VStack
        .padding()
        
    }
}

#Preview {
    GoBoardView()
}

```

![ss 2025-05-09 10-02-22](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-05-09%2010-02-22.jpg)
棋盤底色

這邊使用了 Rectangle() 來製作棋盤底色
```swift
Rectangle()
    .fill(Color.brown)
    .frame(width: minSize, height: minSize)
```



#### 製作棋盤橫線



```swift
struct GoBoardView: View {
    
    let boardSize: Int = 13
    let gridLineColor: Color = .black
    let edgePaddingRatio: CGFloat = 0.06
    
    var body: some View {
        
        VStack {
            
            GeometryReader { geometry in
                let minSize = min( geometry.size.width, geometry.size.height)
                
                let boardContentSize = minSize * (1 - 2 * edgePaddingRatio)
                
                let cellSize = boardContentSize / CGFloat(boardSize - 1)
                
                let edgePadding = minSize * edgePaddingRatio
                
                ZStack {
                    
                    // 製作棋盤底色
                    Rectangle()
                        .fill(Color.brown)
                        .frame(width: minSize, height: minSize)
                    
                    // 畫棋盤格線
                    ForEach(0..<boardSize, id: \.self) { i in
                                                
                        Path { path in
                            
                            // 畫棋盤橫線
                            let startPointHorizontal = CGPoint(
                                x: edgePadding,
                                y: edgePadding + CGFloat(i) * cellSize
                            )
                            let endPointHorizontal = CGPoint(
                                x: edgePadding + boardContentSize,
                                y: edgePadding + CGFloat(i) * cellSize
                            )
                            path.move(to: startPointHorizontal)
                            path.addLine(to: endPointHorizontal)
                            
                        }
                        .stroke(gridLineColor, lineWidth: 1)

                    }
                    
                    
                }// end of ZStack
                .frame(width: minSize, height: minSize)
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
                
            }
            
        } // end of VStack
        .padding()
        
    }
}
```


![ss 2025-05-09 11-22-03](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-05-09%2011-22-03.jpg)
畫好可以在預覽畫面看到


接著繼續在 ZStack { ... } 裡完成棋盤的直線

畫棋盤直線
```swift
// 畫棋盤直線
let startPointVertical = CGPoint(
    x: edgePadding + CGFloat(i) * cellSize,
    y: edgePadding
)
let endPointVertical = CGPoint(
    x: edgePadding + CGFloat(i) * cellSize,
    y: edgePadding + boardContentSize
)
path.move(to: startPointVertical)
path.addLine(to: endPointVertical)
```

![ss 2025-05-09 11-41-37](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-05-09%2011-41-37.jpg)
最後棋盤圖



