
# Use CocoaPods in SwiftUI

## 步驟 1：建立一個新的 Xcode 專案
首先，打開 Xcode，建立一個新的 iOS 專案。
您可以選擇任何應用程式模板，例如 App。
給您的專案取一個名字，例如 CocoaDemo。



## 步驟 2：初始化 Podfile
關閉 Xcode 專案後，打開 終端機，並使用 cd 指令進入到您的專案根目錄。

例如，如果您的專案在桌面上：

```bash
cd ~/Desktop/CocoaDemo
```

然後，執行以下指令來初始化一個 Podfile：

```bash
pod init
```
這將在您的專案根目錄中創建一個名為 Podfile 的檔案。



### 步驟 3：編輯 Podfile

```bash
code .
```

使用任何文字編輯器，打開您剛剛建立的 Podfile 檔案。您會看到類似以下的內容：



```Ruby
# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

target 'CocoaDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CocoaDemo

end
```

在 target 'CocoaDemo' do ... end 區塊內，添加 Alamofire 這個 Pod。

修改後的 Podfile 應該看起來像這樣：

```ruby
# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

target 'CocoaDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CocoaDemo
  pod 'Alamofire'

end
```


### 步驟 4：安裝 Pods
儲存 Podfile 後，回到終端機，確保你還在專案根目錄，然後執行以下命令：

```bash
pod install
```

Analyzing dependencies
Adding spec repo `trunk` with CDN `https://cdn.cocoapods.org/`
Downloading dependencies
Installing Alamofire (5.10.2)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `CocoaDemo.xcworkspace` for this project from now on.
Pod installation complete! There is 1 dependency from the Podfile and 1 total pod installed.

[!] Automatically assigning platform `iOS` with version `18.5` on target `CocoaDemo` because no platform was specified. Please specify a platform for this target in your Podfile. See `https://guides.cocoapods.org/syntax/podfile.html#platform`.



### 步驟 5：開啟 .xcworkspace 檔案
重要！ 從現在開始，你不再開啟原來的 .xcodeproj 檔案，而是開啟由 CocoaPods 生成的 .xcworkspace 檔案。


### 模擬器 run
此時直接點擊跑模擬器應該會跑不起來的
必須把 User Script Sandboxing 改為 No 才行

點擊 CocoaDemo 藍色專案 icon
點擊 TARGETS CocoaDemo
頁籤選擇 ALL
找到 Build Options
=> User Script Sandboxing

### 範例

```swift
import SwiftUI
import Alamofire

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            AF.request("https://httpbin.org/get").responseJSON { response in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }

                if let error = response.error {
                    print("Error: \(error)")
                }
            }
        }
    }
}

```
