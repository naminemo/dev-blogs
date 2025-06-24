
import SwiftUI

// 這個元件固定在螢幕頂部，不隨下方內容滾動。
struct SearchBarView: View {
    @State private var searchText: String = "" // State to hold the text entered by the user
    @FocusState private var isSearchFieldFocused: Bool // To control focus and show/hide clear button
    
    var body: some View {
        HStack {
            // Magnifying glass icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            // The main TextField for search input
            TextField("搜尋...", text: $searchText)
                .padding(.vertical, 8) // Add vertical padding for better touch area
                .focused($isSearchFieldFocused) // Bind focus state
            
            // Clear button (only visible when text is not empty and field is focused)
            if !searchText.isEmpty || isSearchFieldFocused {
                Button(action: {
                    searchText = "" // Clear the text
                    // Optional: Resign focus after clearing
                    // isSearchFieldFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
                .transition(.opacity) // Add a fade transition for appearance/disappearance
            }
        }
        .background(Color(.systemGray6)) // Light gray background for the search bar
        .cornerRadius(10) // Rounded corners
        .padding(.horizontal) // Horizontal padding from the screen edges
        .animation(.default, value: searchText.isEmpty || isSearchFieldFocused) // Animate changes
    }
}

//---
// 這個元件在初始狀態下可見，並會被元件 C 滾動時覆蓋。
struct ComponentBView: View {
    
    // 高度由外面傳進來，預設為全螢幕的 25 %
    @State var height: CGFloat? = 100
    
    var body: some View {
        Image("kfc2") // 你的圖片
            .resizable()
            .scaledToFill()
            .frame(height: height) // 圖片的內容尺寸與矩形相同
            .cornerRadius(10)
            .padding(.horizontal, 20)
        //.padding(.vertical, 15)
        //.border(Color.purple, width: 2)
        
    }
    
}

//---
// 包含大量的可滾動內容，其背景會在滾動時覆蓋元件 B。
/*
struct ComponentCContentView: View {
    
    var body: some View {
        // 使用 VStack(spacing: 0) 確保內容之間沒有額外間距，
        // 這樣可以精確控制內容與上方 Spacer 的連接。
        VStack(spacing: 0) {
            ForEach(0..<50) { i in
                Text("元件 C 內容 \(i)")
                    .padding(.vertical, 5) // 為每個內容項目提供垂直間距
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(i % 2 == 0 ? Color.gray.opacity(0.1) : Color.clear)
            }
        }
        // 這裡不再需要最外層的 .padding()，以避免與元件 B 產生不必要的留白。
        // 如果需要左右邊距，會在外部的 ScrollView 內容中添加。
    }
}
 */

//---
// 該視圖負責協調元件 A、B、C 的位置和疊層行為。
struct OverlayHeaderLayout: View {
    let componentAHeight: CGFloat = 50
    let componentBHeightRatio: CGFloat = 0.25
    
    var body: some View {
        // GeometryReader 用於獲取整個視圖的尺寸，以便動態計算元件 B 的高度。
        GeometryReader { fullViewGeometry in
            // 頂層 ZStack 負責管理所有元件的疊加順序和相對位置。
            // `alignment: .top` 確保所有內容從頂部開始對齊。
            //      ZStack(alignment: .top) {
            // 第一層 (ZStack 預設 zIndex 為 0)：主要內容區 (包含 B 和可滾動的 C)
            // 這個 ZStack 內部會疊加元件 B 和 ScrollView，並由其父級 ZStack 決定其整體位置。
            ZStack(alignment: .top) {
                // 元件 B：作為 ScrollView 的初始視覺背景。
                // 它位於這個子 ZStack 的最底層 (zIndex: 0)。
                ComponentBView(height: fullViewGeometry.size.height * componentBHeightRatio)
                //.frame(height: fullViewGeometry.size.height * componentBHeightRatio)
                // `.background` 僅用於調試觀察 B 的區域，實際應用中可移除。
                //.background(Color.yellow.opacity(0.1))
                    .zIndex(0) // 確保 B 在 ScrollView 下方
                
                // ScrollView：包含元件 C 的內容，負責滾動和覆蓋效果。
                // 位於這個子 ZStack 的上層 (zIndex: 1)。
                ScrollView {
                    // "元件 D" 的概念：一個透明的 Spacer。
                    // 它佔據與元件 B 相同的高度。
                    // 作用：
                    // 1. 初始時，由於其透明度 (.opacity(0))，元件 B 可以透過它被看見。
                    // 2. 它推開了 ComponentCContentView，使得 C 的內容從 B 的正下方開始顯示。
                    // 3. 當 ScrollView 向上滾動時，這個 Spacer 會首先移出視圖，
                    //    隨後 ComponentCContentView 的內容會開始覆蓋 B。
                    Spacer()
                        .frame(height: fullViewGeometry.size.height * componentBHeightRatio)
                        .opacity(0) // 設定為完全透明
                    
                    // 元件 C 的實際內容。
                    //ComponentCContentView()
                    RestaurantListView()
                    // 為元件 C 的內容添加底部空間，確保向下滾動時，可以看到最後一筆資料。
                        .padding(.bottom, 130)
                    // 為元件 C 的內容添加水平內邊距，使其與螢幕邊緣保持距離。
                       // .padding(30)
                    // 設定元件 C 內容的背景色。當 C 滾動上來時，會以這個背景色覆蓋 B。
                        .background(Color.white) // 這裡通常是設定為 .white 或其他實色
                }
                // 讓 ScrollView 佔滿其父級 ZStack 的剩餘空間。
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(1) // 確保 ScrollView 在元件 B 的上方，這樣滾動時才能覆蓋 B。
                // 此方案不再需要 ScrollView 上的 .offset 或 .background(.clear)，
                // 因為透明 Spacer 和 ScrollView 自身的背景已經處理了視覺效果。
            }
            // 將這個子 ZStack (包含 B 和 C) 整體向下偏移元件 A 的高度。
            // 這確保了 B 和 C 的區域從元件 A 的正下方開始。
            .offset(y: componentAHeight)
            // 確保這個子 ZStack 佔滿除了元件 A 之外的所有可用空間。
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // 設定子 ZStack 的背景為透明，防止它引入不必要的背景色。
            .background(Color.clear)
            
            // 第二層 (ZStack 預設 zIndex 為 0，但此處設定為 2)：元件 A
            // 元件 A 直接放在頂層 ZStack 中，並設置最高的 zIndex。
            // 這確保元件 A 始終固定在螢幕頂部，不會被下方任何內容覆蓋。
            SearchBarView()
                .frame(height: componentAHeight)
                .zIndex(2) // 確保在所有內容的最上層
            //      }
            //.padding(.horizontal) // Horizontal padding from the screen edges
        }
    }
}


struct DrinkerView: View {
    
    @State private var searchText = ""
    //@State private var searchResult: [Restaurant] = []
    @State private var isSearchActive = false
    
    var body: some View {
        OverlayHeaderLayout()
        
    }
}


#Preview {
    DrinkerView()
}
