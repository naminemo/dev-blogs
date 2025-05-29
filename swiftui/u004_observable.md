
## 關於狀態管理 (State Management) 的那些二三事 (四) 

在講 @Observable 之前，先來看看一些相似的 Property Wrapper 的出現時間。

  - WWDC 2019 (iOS 13)： @ObservedObject 首次推出。
  - WWDC 2020 (iOS 14)： @StateObject 推出，解決 @ObservedObject 的生命週期問題。
  - WWDC 2023 (iOS 17)： @Observable 推出，作為新 Observation 框架的一部分，旨在簡化和改進原有的 ObservableObject 機制。


### @ObservedObject

  - @ObservedObject 是在 SwiftUI 首次推出時就存在的，也就是在 WWDC 2019 上與 iOS 13 一同發布。
  - 它是最初用於在 SwiftUI 視圖中觀察遵循 ObservableObject 協定（protocol）的參考型別 (reference type) 的方式。
  - 用途： 主要用於接收外部傳入的 ObservableObject 實例。它的生命週期不由視圖擁有，而是由外部管理。這意味著如果擁有該 ObservedObject 的視圖被重新創建，ObservedObject 也可能被重新創建，導致狀態丟失 (這也是 @StateObject 出現的原因)。



### @StateObject

  - @StateObject 是在 WWDC 2020 上推出的，作為 iOS 14 的一部分。
  - 它的引入是為了解決 @ObservedObject 在某些情況下會導致 ObservableObject 被意外重新創建的問題。
  - 用途： 用於在 SwiftUI 視圖中創建並擁有一個遵循 ObservableObject 協定的參考型別實例。@StateObject 確保了該物件的生命週期與其所在的視圖的生命週期綁定，即使視圖本身因為某些原因被重新創建，@StateObject 所包裝的物件也會被保留下來，確保狀態的持久性。



### @Observable

  - @Observable 是一個較新的特性，是在 WWDC 2023 上推出的，作為 iOS 17 的一部分。
  - 它是 Apple 全新的 Observation 框架的核心部分，旨在簡化和改進 SwiftUI 中的狀態管理，並提升效能。它使用了 Swift 5.9 中引入的 Macro (巨集) 技術。
  - 用途： 旨在取代 ObservableObject 協定和 @Published 屬性包裝器。你只需要將 class 或 actor 標記為 @Observable，它的屬性就會自動變得可觀察，而無需為每個屬性添加 @Published。使用 @Observable 時，通常會結合 @State 或 @Bindable 來管理物件的生命週期和雙向綁定。



#### 1. 定義一個共享資料的 ObservableObject
創建一個 SharedData 類別。
在類別前面加上 @Observable 。

```swift
// SharedData.swift
import Foundation

@Observable
class SharedData {
    var sharedText: String = ""
}
```


與 ObservableObject 協定比較

```swift
// SharedData.swift
import Foundation

// 創建一個遵循 ObservableObject 協定的類別
class SharedData: ObservableObject {
    // 使用 @Published 標記你希望在視圖之間共享並能觸發更新的屬性
    // 當我資料有異動時，我會發佈出去
    @Published var sharedText: String = ""
}
```

#### 2. 對第一個進入點使用 @State 來宣告並初始化

```swift
import SwiftUI

struct FirstView: View {
    
    @State var sharedData = SharedData()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                // 顯示共享的值
                Text("FirstView: \(sharedData.sharedText)")

                // 綁定 TextField 到 sharedData.sharedText
                TextField("在這裡輸入文字", text: $sharedData.sharedText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // 第二個 View
                NavigationLink(destination: SecondView(sharedData: sharedData)) {
                    Text("前往 SecondView")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // 第三個 View
                NavigationLink(destination: ThirdView(sharedData: sharedData)) {
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

#### 使用 Bindable 來達成資料傳遞

```swift
// SecondView.swift
import SwiftUI

struct SecondView: View {
    @Bindable var sharedData: SharedData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SecondView: \(sharedData.sharedText)")
            
            // 在這裡也可以修改共享的值
            TextField("在 SecondView 修改", text: $sharedData.sharedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // 第三個 View
            NavigationLink(destination: ThirdView(sharedData: sharedData)) {
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
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        //.navigationTitle("第二個視圖")
        // 不隱藏返回 (Back) 按鈕
        // 如果前一個頁面未設標題，預設會由 Back 字面取代
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    SecondView(sharedData: SharedData())
}
```



```swift
import SwiftUI

struct ThirdView: View {
    @Bindable var sharedData: SharedData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ThirdView: \(sharedData.sharedText)")
            
            // 這裡 TextField 綁定到 sharedData.sharedText
            // 在這裡輸入或修改，會同步更新 FirstView 和 SecondView
            TextField("在 ThirdView 修改", text: $sharedData.sharedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // 第二個 View
            NavigationLink(destination: SecondView(sharedData: sharedData)) {
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
        //.navigationTitle("第三個視圖")
        .navigationBarBackButtonHidden(true) // 隱藏返回按鈕
    }
}

#Preview {
    ThirdView(sharedData: SharedData())
}
```

