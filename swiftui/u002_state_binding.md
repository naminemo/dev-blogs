### 關於 State 和 Binding 的那些二三事 (下)

使用 @State 和 @Binding 來實現三個或者更多 View 共享資料並同步更新，會變得非常麻煩和不切實際，尤其當 View 層級較深時。


### 為什麼會很麻煩？

資料傳遞鏈 (Prop Drilling):
  - @State 只能在聲明它的 View 內部直接讀寫。
  - 如果你想把 @State 的值傳遞給子 View 讓它也能讀寫，你需要將它轉化為 @Binding ($stateName) 並作為參數傳遞下去。
  - 想像一下，如果你的 FirstView -> SecondView -> ThirdView -> FourthView...，你需要將這個 Binding 一層一層地傳遞下去，即使中間的 View 不需要直接使用這個資料，它也必須作為參數接受並傳遞。這會讓程式碼變得非常冗長和脆弱。

單向資料流的挑戰：
  - 雖然 Binding 允許雙向綁定 (子 View 修改會影響父 View)，但它的設計初衷主要還是用於父子 View 之間直接的資料互動。
  - 當你需要跨越**兄弟 View**或**非直接父子關係**的 View 進行資料同步時，@State 和 @Binding 的機制就顯得力不從心。這必須讓所有相關的 View 都綁定到同一個最頂層的 @State，這會使得傳遞鏈變得非常複雜。


### 如何使用 @State 和 @Binding 實現

這裡做一個 RootView 來放最頂層的 @State  
然後 FirstView、SecondView、ThirdView 使用 Binding 來做資料的同步  

RootView 此頁面也是管理導航路徑的設定。

```swift
import SwiftUI

// 用於管理導航路徑
enum Destination: Hashable {
    case secondView
    case thirdView
}

struct RootView: View {
    @State private var sharedText: String = "" // 共享資料
    @State private var path = NavigationPath() // 管理導航路徑
    
    var body: some View {
        NavigationStack(path: $path) { // 將 path 綁定到 NavigationStack
            FirstView(sharedText: $sharedText, path: $path) // 傳遞共享資料和 path
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                        case .secondView:
                            SecondView(sharedText: $sharedText, path: $path)
                        case .thirdView:
                            ThirdView(sharedText: $sharedText, path: $path)
                    }
                }
        }
    }
}

#Preview {
    RootView()
}
```


```swift
import SwiftUI

struct FirstView: View {
    @Binding var sharedText: String
    @Binding var path: NavigationPath // 接收 path 綁定

    var body: some View {
        VStack(spacing: 20) {
            Text("FirstView: \(sharedText)")
                .font(.title2)
                .foregroundStyle(.indigo)

            TextField("在這裡輸入文字", text: $sharedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // 使用 NavigationLink(value: ...)
            NavigationLink(value: Destination.secondView) {
                Text("前往 SecondView")
                    .font(.headline)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }

            // 使用 NavigationLink(value: ...)
            NavigationLink(value: Destination.thirdView) {
                Text("前往 ThirdView")
                    .font(.headline)
                    .padding()
                    .background(.green)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("第一個視圖")
    }
}

#Preview {
    FirstView(
        sharedText: .constant("123"),
        path: .constant(NavigationPath())
    )
}
```


```swift
import SwiftUI

struct SecondView: View {
    @Binding var sharedText: String
    @Binding var path: NavigationPath // 接收 path 綁定

    var body: some View {
        VStack(spacing: 20) {
            Text("SecondView: \(sharedText)")
                .font(.title2)
                .foregroundStyle(.indigo)

            TextField("在 SecondView 修改", text: $sharedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            NavigationLink(value: Destination.thirdView) {
                Text("前往 ThirdView")
                    .font(.headline)
                    .padding()
                    .background(.green)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }

            Button("返回上一頁") {
                path.removeLast() // 使用 path 來返回
            }
            .font(.headline)
            .padding()
            .background(Color.orange)
            .foregroundStyle(.white)
            .cornerRadius(10)
        }
        .navigationTitle("第二個視圖")
    }
}

#Preview {
    SecondView(
        sharedText: .constant("456"),
        path: .constant(NavigationPath())
    )
}
```


```swift
import SwiftUI

struct ThirdView: View {
    @Binding var sharedText: String
    @Binding var path: NavigationPath // 接收 path 綁定

    var body: some View {
        VStack(spacing: 20) {
            Text("ThirdView: \(sharedText)")
                .font(.title2)
                .foregroundStyle(.indigo)

            TextField("在 ThirdView 修改", text: $sharedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            NavigationLink(value: Destination.secondView) {
                Text("前往 SecondView")
                    .font(.headline)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }

            Button("返回上一頁") {
                path.removeLast() // 使用 path 來返回
            }
            .font(.headline)
            .padding()
            .background(.purple)
            .foregroundStyle(.white)
            .cornerRadius(10)
        }
        .navigationTitle("第三個視圖")
    }
}

#Preview {
    ThirdView(
        sharedText: .constant("789"),
        path: .constant(NavigationPath())
    )
}
```

```swift
import SwiftUI

@main
struct TestViewPassingValueApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
```

為了讓 SecondView 和 ThirdView 都能修改並影響 FirstView，並且彼此也能同步，必須讓所有 View 都綁定到 RootView 中的那個 @State。

  - RootView 擁有 sharedText 的 @State。
  - FirstView 接收一個 Binding<String> 作為參數。
  - SecondView 接收一個 Binding<String> 作為參數。
  - ThirdView 接收一個 Binding<String> 作為參數。
  - 如果想讓 SecondView 直接與 ThirdView 進行同步，而它們之間沒有父子關係，這裡必須通過一個共同的祖先 View 來作為資料的中繼站。

### 缺點

這個方案雖然能運行，但有幾個明顯的缺點：

  - 複雜的初始化： 每個子 View 都需要一個初始化器參數來接收 Binding，這增加了程式碼的複雜性。
  - 資料傳遞的冗餘： 如果未來有 FourthView、FifthView 等，都必須一層層地傳遞這個 Binding，即使某些中間 View 並不需要直接使用這個資料。
  - 脆弱性： 任何一個層級的 View 忘記傳遞 Binding 都會導致編譯錯誤或運行時問題。
  - 不適合大規模應用： 在大型複雜應用中，這種方式會讓資料流變得混亂，難以追蹤和維護。


### 結論
理論上使用 @State 和 @Binding 來實現多層視圖資料共享，但它會導致**資料傳遞鏈 (Prop Drilling)**的問題，使得程式碼變得臃腫、難以閱讀和維護。


對於需要跨多個不相關或深層級的 View 共享狀態的情況，@ObservableObject 結合 @EnvironmentObject 或 @StateObject 是更優雅、更推薦的 SwiftUI 模式。  
它將共享的資料抽離到一個獨立的物件中，並通過環境自動提供給需要它的 View，極大地簡化了資料傳遞。
