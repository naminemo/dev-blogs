
# 仿 foodpanda 主頁面風格

```swift
import SwiftUI

// PreferenceKey 用於獲取 ScrollView 內容的 Y 偏移量
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// 元件 A (頂部固定搜尋框)
struct ComponentAView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.blue.opacity(0.2))
            .frame(height: 50)
            .overlay(Text("元件 A (常駐)").foregroundColor(.blue))
    }
}

// 元件 B (可摺疊廣告區)
struct ComponentBView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.green.opacity(0.2))
            .overlay(Text("元件 B (摺疊)").foregroundColor(.green))
    }
}

// 元件 C (可滾動主內容區)
struct ComponentCContentView: View {
    var body: some View {
        VStack {
            ForEach(0..<50) { i in
                Text("元件 C 內容 \(i)")
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(i % 2 == 0 ? Color.gray.opacity(0.1) : Color.clear)
            }
        }
        .padding()
    }
}

struct CollapsibleHeaderLayout: View {
    // 儲存 ScrollView 內容的實際 Y 偏移量 (未滾動時為 0，向上滾動時為負數)
    @State private var scrollViewContentOffset: CGFloat = 0
    
    let componentAHeight: CGFloat = 50
    let componentBHeightRatio: CGFloat = 0.25 // 元件 B 的高度比例
    
    // 元件 B 的初始實際高度
    @State private var componentBInitialHeight: CGFloat = 0

    var body: some View {
        GeometryReader { fullViewGeometry in
            ZStack(alignment: .top) { // 使用 ZStack 來層疊視圖
                // ScrollView 的內容區域
                ScrollView {
                    // 整個可滾動內容的 VStack
                    VStack(spacing: 0) {
                        // 這個 GeometryReader 用來監測 ScrollView 內容的偏移量
                        // 它作為內容的第一個元素，監測它的 minY 就能得到滾動偏移
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
                        }
                        .frame(width: 0, height: 0) // 確保這個錨點不佔用佈局空間

                        // 元件 B (現在是 ScrollView 內容的一部分)
                        // 它的高度會根據滾動偏移量動態變化
                        // 這裡使用 `bHeightToUse` 確保在 `componentBInitialHeight` 尚未初始化時使用預期值
                        let bHeightToUse = componentBInitialHeight == 0 ? fullViewGeometry.size.height * componentBHeightRatio : componentBInitialHeight
                        
                        let rawScrollOffset = max(0, min(-scrollViewContentOffset, bHeightToUse))
                        let currentBHeight = max(0, bHeightToUse - rawScrollOffset)
                        
                        ComponentBView()
                            .frame(height: currentBHeight)
                            .opacity(max(0.0, 1.0 - (rawScrollOffset / (bHeightToUse == 0 ? 1 : bHeightToUse))))
                            .clipped() // 裁剪，確保超出邊界的內容不顯示

                        // 元件 C 的內容緊隨元件 B
                        ComponentCContentView()
                    }
                }
                .coordinateSpace(name: "scroll") // 為 ScrollView 內容定義座標空間
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollViewContentOffset = value
                    
                    // 除錯輸出 (可以取消註釋來觀察)
                     print("ContentOffset: \(scrollViewContentOffset.formatted()), InitialBHeight: \(componentBInitialHeight.formatted()), rawScrollOffset: \(max(0, min(-scrollViewContentOffset, componentBInitialHeight)).formatted()), Current B Height: \(max(0, componentBInitialHeight - max(0, min(-scrollViewContentOffset, componentBInitialHeight))).formatted())")
                }
                // *** 關鍵調整：ScrollView 的內容起始點 ***
                // 我們讓 ScrollView 的內容從元件 A 的下方開始
                .padding(.top, componentAHeight)
                
                // 1. 元件 A (常駐頂部) - 放在 ZStack 的最上層
                ComponentAView()
                    .frame(height: componentAHeight)
                    .background(Color.white) // 提供背景色，避免內容從下方透出
                    .zIndex(2) // 確保在最上層
            }
            // *** 關鍵修改：使用 onAppear 來初始化 componentBInitialHeight ***
            // 這會在視圖第一次出現在螢幕上時觸發，確保在渲染內容前就有了正確的高度
            .onAppear {
                if componentBInitialHeight == 0 { // 避免重複設定
                    componentBInitialHeight = fullViewGeometry.size.height * componentBHeightRatio
                    print("onAppear: componentBInitialHeight initialized to \(componentBInitialHeight)")
                }
            }
            // onChange 依然保留，以防視圖尺寸在運行時發生變化 (例如設備旋轉)
            .onChange(of: fullViewGeometry.size.height) { oldHeight, newHeight in
                let newCalculatedHeight = newHeight * componentBHeightRatio
                if componentBInitialHeight != newCalculatedHeight {
                    componentBInitialHeight = newCalculatedHeight
                    print("onChange: componentBInitialHeight updated to \(componentBInitialHeight)")
                }
            }
        }
    }
}

#Preview {
    CollapsibleHeaderLayout()
}
```

入口點

```swift
import SwiftUI

@main
struct Drinker4App: App {
    var body: some Scene {
        WindowGroup {
            CollapsibleHeaderLayout()
        }
    }
}
```

![ss 2025-06-24 09-18-48](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-06-24%2009-18-48.jpg)
