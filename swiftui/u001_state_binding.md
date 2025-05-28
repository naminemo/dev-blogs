
### 關於 State 和 Binding 的那些二三事

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

