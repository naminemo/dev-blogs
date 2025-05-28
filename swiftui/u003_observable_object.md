### Injection

Dependency Injection (依賴注入) 是一個廣泛的軟體設計模式，指的是將一個物件 (依賴) 提供給另一個物件 (被依賴者) 使用，而不是讓被依賴者自己創建或查找依賴。這樣做可以降低程式碼的耦合度，提高模組的獨立性和可測試性。

Environment Object (環境物件): 這是 SwiftUI 中專門用來實現依賴注入的一種機制。  
它允許你在視圖層級結構的某個點注入一個 ObservableObject 實例，然後其下的任何子視圖都可以透過 @EnvironmentObject 屬性包裝器來訪問這個實例，而不需要手動將它作為參數一層一層地傳遞。


在 SwiftUI 中要實現這種多視圖之間同步資料更新的需求，最標準且推薦的做法是使用 環境物件 (EnvironmentObject) 或 可觀察物件 (ObservableObject)。

"在 ThirdView 改值，同步 SecondView 及 FirstView 也會變"，這表示資料需要在多個視圖之間共享且同步。  

以下使用 ObservableObject 和 @EnvironmentObject 的組合來實現，這是一種在 SwiftUI 中管理共享應用程式狀態。

### 概念

  - ObservableObject: 創建一個遵循 ObservableObject 協定的類別，用於持有共享的資料。當這個類別的屬性 (用 @Published 標記的) 發生變化時，會自動通知所有觀察它的視圖進行更新。
  - @EnvironmentObject: 在需要訪問共享資料的視圖中，使用 @EnvironmentObject 屬性包裝器來注入這個 ObservableObject 實例。這使得你不需要手動傳遞資料到每個子視圖，SwiftUI 會在環境中查找並提供它。
  - @State 和 @Binding: 在單個視圖內部，@State 用於管理局部狀態。當你需要將 @State 的值傳遞給子視圖進行雙向綁定時，使用 $state 名稱 把它轉化為 @Binding。


#### 1. 定義一個共享資料的 ObservableObject
創建一個 SharedData.swift

```swift
// SharedData.swift
import Foundation

// 創建一個遵循 ObservableObject 協定的類別
class SharedData: ObservableObject {
    // 使用 @Published 標記你希望在視圖之間共享並能觸發更新的屬性
    @Published var sharedText: String = ""
}
```

#### 2. 在 App 進入點注入 EnvironmentObject
在你的應用程式的主結構 (通常是 YourApp.swift) 中，將 SharedData 的實例注入到環境中。  
這樣所有子視圖都可以訪問到它。

```swift
// YourApp.swift (通常是專案名稱App.swift)
import SwiftUI

@main
struct YourApp: App {
    // 創建 SharedData 的實例，並使用 @StateObject 讓其生命週期與 App 保持一致
    // @StateObject 會在 App 第一次被建立時初始化，並在 App 存在期間保持
    @StateObject private var sharedData = SharedData()

    var body: some Scene {
        WindowGroup {
            FirstView()
                // 將 sharedData 實例注入到環境中
                // 任何 FirstView 及其子孫視圖都可以使用 @EnvironmentObject 訪問它
                .environmentObject(sharedData)
        }
    }
}
```



#### 3.修改想要共享資料的 View
每個 View 都會使用 @EnvironmentObject 來訪問 SharedData 實例。
```swift
// FirstView.swift
import SwiftUI

struct FirstView: View {
    // 在需要訪問共享資料的視圖中，使用 @EnvironmentObject 注入
    // 注意：這裡不初始化，它會從環境中取得
    @EnvironmentObject var sharedData: SharedData

    var body: some View {
        NavigationStack { 
            VStack(spacing: 20) {
                Text("FirstView: \(sharedData.sharedText)") // 顯示共享的值

                // 綁定 TextField 到 sharedData.sharedText
                TextField("在這裡輸入文字", text: $sharedData.sharedText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                NavigationLink(destination: SecondView()) { // 第二個 View
                    Text("前往 SecondView")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: ThirdView()) { // 第三個 View
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
    @Environment(\.presentationMode) var presentationMode // 用於返回上一頁

    var body: some View {
        VStack(spacing: 20) {
            Text("SecondView: \(sharedData.sharedText)") // 顯示共享的值

            // 在這裡也可以修改共享的值
            TextField("在 SecondView 修改", text: $sharedData.sharedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("返回上一頁") {
                presentationMode.wrappedValue.dismiss() // 返回操作
            }
            .font(.headline)
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("第二個視圖")
        // .navigationBarBackButtonHidden(true) // 如果你想隱藏默認的返回按鈕
    }
}
```


```swift
// ThirdView.swift
import SwiftUI

struct ThirdView: View {
    @EnvironmentObject var sharedData: SharedData
    @Environment(\.presentationMode) var presentationMode // 用於返回上一頁

    var body: some View {
        VStack(spacing: 20) {
            Text("ThirdView: \(sharedData.sharedText)") // 顯示共享的值

            // 這裡 TextField 綁定到 sharedData.sharedText
            // 在這裡輸入或修改，會同步更新 FirstView 和 SecondView
            TextField("在 ThirdView 修改", text: $sharedData.sharedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("返回上一頁") {
                presentationMode.wrappedValue.dismiss() // 返回操作
            }
            .font(.headline)
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("第三個視圖")
        // .navigationBarBackButtonHidden(true)
    }
}
```




在這個例子中，SharedData 是依賴 (Dependency) ，而 FirstView 及其子孫視圖是被依賴者。你沒有讓每個視圖自己去創建 SharedData，而是從外部 (WindowGroup 層) 提供給它。