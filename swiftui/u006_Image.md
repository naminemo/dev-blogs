### Image

基本上能直接使用 Image 元件來顯示 .png 及 .jpg 圖片

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("u006_hello")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
```

這裡我的原始圖片為  
u006_hello.jpg (無去背)  
u006_hello.png (去背)  
然後把想要的顯示圖片拖拉到 Assets 裡，
這裡要注意的是放入 Image 只需要檔案名稱，不需要副檔名  
既然只需要檔案名稱，這樣表示 u006_hello.jpg 及 u006_hello.png 會視為同一個名稱  
所以這裡 u006_hello.jpg 及 u006_hello.png 只能挑一張放進去 Assets 裡

### .gif

接下來想顯示副檔名為 .gif 的動畫。
Image 元件本身 不直接支援 顯示 .gif 動畫。Image 只能顯示靜態圖片，例如 .png、.jpeg 等。

這裡透過但你可以透過 WKWebView 包裝到 UIViewRepresentable 中來實現。

對於高效且功能豐富的 GIF 播放，也能使用像 Kingfisher 或 SDWebImage 這樣的第三方函式庫。

```swift
import SwiftUI
import WebKit

struct AnimatedGIFView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct ContentView: View {
    var body: some View {
        
        // 使用 if-let 來安全地 unwrap Optional 的 URL
        if let gifURL = Bundle.main.url(
            forResource: "u006_witch",
            withExtension: "gif"
        ) {
            AnimatedGIFView(url: gifURL)
                .frame(width: 200, height: 250)
                .border(.blue)
        } else {
            // 處理 GIF 檔案找不到的情況
            Text("找不到 GIF 檔案！")
                .foregroundColor(.red)
        }
    }
}

#Preview {
    ContentView()
}
```
注意這邊 u06_witch.gif 檔案不能丟到 Assets 裡，直接丟在專案裡即可。
通常會在專案底下新增一個資料夾 Resources
然後再把 u06_witch.gif 丟到此資料夾底下  

### SDWebImageSwiftU

對著專案名稱按右鍵，選擇 Add Package Dependences...
找到 SDWebImageSwiftUI
![ss 2025-06-12 11-11-24](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-06-12%2011-11-24.jpg)

按下右下的  Add Package 按鈕

成功後看到如下畫面
![ss 2025-06-12 11-16-06](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-06-12%2011-16-06.jpg)

```swift
import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    var body: some View {
        
        AnimatedImage(name: "u006_witch.gif")
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 300)
            .border(.blue)
    }
}

#Preview {
    ContentView()
}
```

![ss 2025-06-12 11-23-47](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-06-12%2011-23-47.jpg)
