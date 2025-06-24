
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1 // 初始選中的 Tab 索引

    let myTabItems: [(name: String, icon: String)] = [
        ("Home", "house.fill"),
        ("Drinks", "cup.and.saucer.fill"),
        ("Scan", "qrcode.viewfinder"),
        ("Profile", "person.fill"),
        ("Settings", "gearshape.fill")
    ]

    var body: some View {
        CustomTabBarView(selectedTab: $selectedTab, tabItems: myTabItems) {
            // Tab 0 content
            Color.blue.opacity(0.2).overlay(Text("首頁"))
                .tag(0)

            // Tab 1 content
            DrinkerView()
            //Color.indigo.opacity(0.2).overlay(Text("飲料"))
                .tag(1)
            
            // Tab 2 content
            Color.green.opacity(0.2).overlay(Text("掃碼內容"))
                .tag(2)

            // Tab 3 content
            Color.yellow.opacity(0.2).overlay(Text("個人內容"))
                .tag(3)

            // Tab 4 content (if you have 5 tabs)
            Color.indigo.opacity(0.2).overlay(Text("設定內容"))
                .tag(4)
        }
    }
}

// 預覽
#Preview {
    ContentView()
}
