# 狀態管理

## 關於狀態管理 (State Management) 的那些二三事 (三)

### Injection

Dependency Injection (依賴注入) 是一個廣泛的軟體設計模式，指的是將一個物件 (依賴) 提供給另一個物件 (被依賴者) 使用，而不是讓被依賴者自己創建或查找依賴。這樣做可以降低程式碼的耦合度，提高模組的獨立性和可測試性。

Environment Object (環境物件) 是 SwiftUI 中專門用來實現依賴注入的一種機制。  
它允許你在視圖層級結構的某個點注入一個 ObservableObject 實例，然後其下的任何子視圖都可以透過 @EnvironmentObject 屬性包裝器來訪問這個實例，而不需要手動將它作為參數一層一層地傳遞。

### Environment Object

在 SwiftUI 中要實現這種多視圖之間同步資料更新的需求，最標準且推薦的做法是使用 環境物件 (EnvironmentObject) 或 可觀察物件 (ObservableObject)。

"在 ThirdView 改值，同步 SecondView 及 FirstView 也會變"，這表示資料需要在多個視圖之間共享且同步。  

以下使用 ObservableObject 和 @EnvironmentObject 的組合來實現，這是一種在 SwiftUI 中管理共享應用程式狀態。

### 概念

- ObservableObject: 創建一個遵循 ObservableObject 協定的類別，用於持有共享的資料。當這個類別的屬性 (用 @Published 標記的) 發生變化時，會自動通知所有觀察 (或者可說為訂閱) 它的視圖進行更新。
- @EnvironmentObject: 在需要訪問共享資料的視圖中，使用 @EnvironmentObject 屬性包裝器來注入這個 ObservableObject 實例。這使得我們不需要手動傳遞資料到每個子視圖，SwiftUI 會在環境中查找並提供它。

#### 1. 定義一個共享資料的 ObservableObject

創建一個 SharedData 類別，它必須符合 ObservableObject 協定規範。
必須在共享的資料加上 @Published 這個 Property Wrapper，  
這也就是所謂的發佈者，每當我本身資料有變動時，發佈者會發出通知給訂閱者。  

查閱 apple doc 中的ObservableObject 協定，會發現  
protocol ObservableObject: AnyObject  
代表它也必須符合 AnyObject 協定，所以只有類別能適用 ObservableObject 協定  

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

#### 2. 在 App 進入點注入 EnvironmentObject

在你的應用程式的主結構 (通常是 YourApp.swift) 中，將 SharedData 的實例注入到環境 (整個系統) 中。  
這樣所有子視圖都可以訪問到它。

這樣的方式形成了一個全域資料流。

```swift
// YourApp.swift (通常是專案名稱App.swift)
import SwiftUI

@main
struct YourApp: App {
    // 創建 SharedData 的實例，並使用 @StateObject 讓其生命週期與 App 保持一致。
    // @StateObject 會在 App 第一次被建立時初始化，並在 App 運行期間保持存在。
    // 即使 YourApp 結構體本身因為某些原因被重新初始化，雖然在 @main 這種情況下不常見，
    // @StateObject 會確保其包裝的對象的狀態不會丟失，除非應用程式終止。
    @StateObject private var sharedData = SharedData()

    var body: some Scene {
        WindowGroup {
            FirstView()
                // 將已經創建並被 @StateObject 管理的 sharedData 實例注入到環境中
                // 此環境指的就是 FirstView 及其所有的子視圖
                // 任何 FirstView 及其子孫視圖都可以使用 @EnvironmentObject 訪問它
                .environmentObject(sharedData)
        }
    }
}
```

#### ObservableObject 協定 與 @StateObject

@StateObject 是 SwiftUI 框架中一個非常重要的屬性包裝器 (Property Wrapper)，它主要用於管理和持有遵循 ObservableObject 協定的引用類型數據，並且確保這個數據實例在視圖的生命週期內只被創建一次。

一旦 ObservableObject 實例被 @StateObject 初始化，它就會被**綁定**到擁有它的視圖的生命週期。這意味著視圖重新繪製 (re-render) 時，實例不會被重複創建。  
這是與 @ObservedObject 的主要區別。即使父視圖的狀態發生變化導致子視圖重新繪製，@StateObject 包裹的仍然是同一個實例，它的狀態會被保留。

在 2019 (WWDC2019) 年，@ObservedObject 與 SwiftUI 同步推出，運行於 iOS13
在 2020 (WWDC2020) 年，@StateObject 加入，運行於 iOS14

另外，@StateObject 與 @ObservedObject 的功能非常類似。
但兩者之者還是有一些些微的差異，，那就是當包含 @ObservedObject 的視圖被重新繪製時，如果 ObservedObject 的初始化是在視圖的 body 中進行的，那麼 ObservedObject 所引用的對象可能會被重新創建。  
這會導致數據丟失，或者導致不必要的性能開銷，因為每次重繪都會創建一個新的數據實例，這也是 @ObservedObject 一個潛在的問題。

補充：  
在 WWDC2023，@Observable 加入，運行於 iOS17  
主要功用為更新 SwiftUI 以回應類別屬性的變化  

#### 3.修改想要共享資料的 View

每個 View 都會使用 @EnvironmentObject 來訪問 SharedData 實例。

```swift
// FirstView.swift
import SwiftUI

struct FirstView: View {
    // 在需要訪問共享資料的視圖中，使用 @EnvironmentObject 注入
    // 注意：這裡不初始化，因為在源頭就初始化了，它會從環境中取得
    @EnvironmentObject var sharedData: SharedData

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
                NavigationLink(destination: SecondView()) { 
                    Text("前往 SecondView")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // 第三個 View
                NavigationLink(destination: ThirdView()) { 
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
```

```swift
// SecondView.swift
import SwiftUI

struct SecondView: View {
    @EnvironmentObject var sharedData: SharedData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SecondView: \(sharedData.sharedText)")
            
            // 在這裡也可以修改共享的值
            TextField("在 SecondView 修改", text: $sharedData.sharedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // 第三個 View
            NavigationLink(destination: ThirdView()) {
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
        // 如果前一個頁面未設標題，則用 Back 字面取代
        .navigationBarBackButtonHidden(false)
    }
}
```

```swift
// ThirdView.swift
import SwiftUI

struct ThirdView: View {
    @EnvironmentObject var sharedData: SharedData
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
            NavigationLink(destination: SecondView()) {
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
```

在這個例子中，SharedData 是依賴 (Dependency) ，而 FirstView 及其子孫視圖是被依賴者。  

這裡沒有讓每個視圖自己去創建 SharedData，而是從外部 (WindowGroup 層) 注射給它。

### Navigation

- Hierarchical Navigation
- Flat Navigation
- Content-Driven Navigation
