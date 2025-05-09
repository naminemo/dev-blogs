
## SwiftUI 載入 gif 檔

先在專案底下新增一個 Resources 資料夾
在此資料夾底下放入 witch.gif 檔


#### 方法一：使用 WebKit

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
        if let gifURL = Bundle.main.url(forResource: "witch", withExtension: "gif") {
            AnimatedGIFView(url: gifURL)
                .frame(width: 300, height: 350)
        } else {
            // 處理 GIF 檔案找不到的情況
            Text("找不到 GIF 檔案！")
                .foregroundColor(.red)
        }
    }
}
```

#### 方法二：使用 SDWebImage

```swift
import SwiftUI
import SDWebImageSwiftUI

struct ContentView2: View {
    var body: some View {
        VStack {
        
            AnimatedImage(name: "witch.gif")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
        }
    }
}
```
