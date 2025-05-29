
## 關於狀態管理 (State Management) 的那些二三事 (一) 

### State 和 Binding (上)

我們知道使用 @State 和 @Binding 可以實現 SwiftUI 中的狀態管理。  
@State 用於在視圖內部管理狀態，而 @Binding 則用於將狀態從父視圖傳遞到子視圖。

通常都是父視圖傳遞到子視圖。  
現在來實驗加祖孫視圖或兄弟視圖的資料傳遞。

FirstView -> SecondView -> ThirdView   
FirstView -> ThirdView -> SecondView

這樣的資料流傳遞就形成了祖孫，而 Second 和 ThirdView 也能形成平輩資料互傳。

先來看看以前舊的寫法
```swift
import SwiftUI

// FirstView 擁有唯一的 @State
struct FirstView: View {
    
    @State private var sharedText: String = ""
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 20) {
                
                Text("FirstView: \(sharedText)")
                    .font(.title2)
                    .foregroundStyle(.indigo)
                
                TextField("在這裡輸入文字", text: $sharedText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // 傳遞 sharedText 的 Binding 給 SecondView
                NavigationLink(
                    destination: SecondView(sharedText: $sharedText)
                ) {
                    Text("前往 SecondView")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // 傳遞 sharedText 的 Binding 給 ThirdView
                NavigationLink(
                    destination: ThirdView(sharedText: $sharedText)
                ) {
                    Text("前往 ThirdView")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
            }
            .navigationTitle("第一個視圖")
        }
    }
}

#Preview {
    FirstView()
}
```

```swift
import SwiftUI

// SecondView 接收一個 Binding
struct SecondView: View {
    @Binding var sharedText: String // 接收 Binding
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("SecondView: \(sharedText)")
                .font(.title2)
                .foregroundStyle(.indigo)
            
            TextField("在 SecondView 修改", text: $sharedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // 傳遞 sharedText 的 Binding 給 ThirdView
            NavigationLink(
                destination: ThirdView(sharedText: $sharedText)
            ) {
                Text("前往 ThirdView")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button("返回上一頁") {
                dismiss()
            }
            .font(.headline)
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("第二個視圖")
    }
}

#Preview {
    SecondView(sharedText: .constant("12"))
}
```


```swift
import SwiftUI

// ThirdView 接收一個 Binding
struct ThirdView: View {
    @Binding var sharedText: String // 接收 Binding
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("ThirdView: \(sharedText)")
                .font(.title2)
                .foregroundStyle(.indigo)
            
            TextField("在 ThirdView 修改", text: $sharedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // 傳遞 sharedText 的 Binding 給 SecondView
            NavigationLink(
                destination: SecondView(sharedText: $sharedText)
            ) {
                Text("前往 SecondView")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button("返回上一頁") {
                dismiss()
            }
            .font(.headline)
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("第三個視圖")
    }
}

#Preview {
    ThirdView(sharedText: .constant("456"))
}
```

這個範例實現了 FirstView 能傳資料到 SecondView，SecondView 能傳資料到 ThirdView。
而且 SecondView 跟 ThirdView 的資料也能互傳。  

這裡有個非常顯眼的錯誤，就是我們使用了 NavigationView。
雖然目前這個程式執行起來好像也是能動的樣子。 

NavigationView 在 doc 有說明到 iOS 13.0–18.4 Deprecated。
也就是 iOS 13.0–18.4 仍然還是給你用，但未來會捨棄不用了。  
我想也是因為 NavigationView 它非預期的 bug 有點常遇到，  
所以早早出了 NavigationStack 來使用。

### 常會出現的錯誤 
"在 ThirdView 一輸入文字就跳回 SecondView"，這是一個 SwiftUI NavigationView 和 NavigationLink 常見的非預期行為，尤其是在 TextField 導致視圖更新時。

NavigationView 的舊行為導致 View 的重建，在舊版的 SwiftUI，NavigationView 的內部實作有時會因為子視圖的狀態變化而導致整個導航堆疊中的視圖被不必要地重建。當 TextField 的輸入導致 sharedText 變化，觸發 ThirdView 甚至其父級視圖的重新渲染時，就可能意外觸發導航堆疊的回彈。

"在更深的 View 層的 TextField 的輸入資料時，該視圖會被咬住，而無法繼續輸入"，這也是因為觸發其父級視圖的重新渲染，而造成 TextField 的焦點失焦而無法繼續輸入。

### 快速修正

把 NavigationView 改成 NavigationStack。
它從根本上改進了 SwiftUI 的導航機制，解決了許多 NavigationView 的問題。