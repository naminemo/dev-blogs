# JSON 的操作

JSON (JavaScript Object Notation) 是一種輕量級的資料交換格式，非常適合用來儲存或傳輸結構化的資料。  
Swift 語言提供了強大的 Codable 協定和相關的 JSONEncoder，可以輕鬆地將自定義的 Swift 物件轉換成 JSON 格式並寫入檔案。

## 資料模型符合 Codable 協定

首先，要儲存到 JSON 的資料結構 (通常是 struct 或 class) 必須符合 Codable 協定。  
Codable 是一個便利的型別別名，  
結合了 Encodable (用於將 Swift 物件轉換為其他格式，例如 JSON) 和  
Decodable (用於將其他格式轉換回 Swift 物件)。

```swift
import SwiftUI

struct ContentView: View {
    
    @State private var userData = MyData(name: "Jim", age: 30, items: ["book", "pen"])
    
    var body: some View {
        
        Form {
            Section(header: Text("個人資訊")) {
                Text("Name: \(userData.name)")
                
                TextField("Age", text: Binding(
                    get: { String(userData.age) },
                    set: { newValue in
                        if let intVal = Int(newValue) {
                            userData.age = intVal
                        }
                    }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // 可選，限制鍵盤為數字
            }

            Section(header: Text("物品清單")) {
                Text(userData.items.joined(separator: ", "))
            }

            Section {
                Button("儲存資料至 JSON") {
                    saveDataToJSON()
                }
                Button("從 JSON 載入資料") {
                    loadDataFromJSON()
                }
            }
        }
        
        VStack {
            Text("Name: \(userData.name)")
            
            TextField("Age", text: Binding(
                get: { String(userData.age) },
                set: { newValue in
                    if let intVal = Int(newValue) {
                        userData.age = intVal
                    }
                }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad) // 限制鍵盤為數字
            
            Text("Items: \(userData.items.joined(separator: ", "))")
            
            Button("Save Data to JSON") {
                saveDataToJSON()
            }
        }
        .padding([.top, .bottom, .trailing, .leading], 50)
        .onAppear {
            loadDataFromJSON() // 當 View 載入時，嘗試從 JSON 檔案載入資料
        }
    }
    
    func saveDataToJSON() {
        if let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
            .first {
            
            let fileURL = documentDirectory.appendingPathComponent("myData.json")
            print(fileURL)
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                print(encoder)
                let jsonData = try encoder.encode(userData) // 編碼當前的 userData 狀態
                
                print("=== jsonData ===")
                print(jsonData)
                print(type(of: jsonData))
                
                try jsonData.write(to: fileURL)
                print("Data successfully written to \(fileURL.absoluteString)")
            } catch {
                print("Error writing JSON data to file: \(error.localizedDescription)")
            }
        }
    }
    
    func loadDataFromJSON() {
        
        // 嘗試獲取應用程式的沙盒文件目錄 (Documents 資料夾) 。
        // 這是應用程式可以讀寫檔案的標準位置之一。
        if let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,  // 指定要查找的是 Documents 目錄
            in: .userDomainMask       // 指定在用戶的主目錄下查找
        ).first {
            
            let fileURL = documentDirectory.appendingPathComponent("myData.json")
            
            print(fileURL)
            // "/Users/XXX/Library/Developer/CoreSimulator/Devices/A0CE847-4007/data/Containers/Data/Application/0D0-E847-4007-8BA9/Documents/myData.json"
            
            // 檢查檔案是否存在
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // 從檔案路徑讀取資料到 Data 物件中
                    let data = try Data(contentsOf: fileURL)
                    
                    // 初始化 JSONDecoder。
                    // 它是一個「食譜」，
                    // 定義如何將 JSON 資料 (食材) 轉換成 Swift 物件 (成品) ，
                    // 但它本身不儲存任何實際的資料。
                    let decoder = JSONDecoder()
                    
                    // 這裡 'print(decoder)' 會輸出 decoder 物件的內部設定，
                    // 例如解碼日期、資料、鍵值等的策略。
                    // 如前所述，這段輸出的內容是 JSONDecoder 的配置信息，而非被解碼的資料本身：
                    /*
                     (Foundation.JSONDecoder) 0x00006000033206e0 {
                       assumesTopLevelDictionaryKey = (rawValue = "_NSAssumesTopLevelDictionaryJSON5")
                       options = {
                         dateDecodingStrategy = deferredToDate      // 日期解碼策略：延遲到 Date 類型處理
                         dataDecodingStrategy = base64              // Data 解碼策略：Base64 編碼
                         nonConformingFloatDecodingStrategy = throw // 非標準浮點數策略：拋出錯誤
                         keyDecodingStrategy = useDefaultKeys       // 鍵值解碼策略：使用預設鍵名
                         userInfo = 0 key/value pairs {}            // 用戶資訊：空
                         json5 = false                              // 是否支援 JSON5：否
                       }
                       optionsLock = {
                         _buffer = 0x0000600000275340 (header = () @ 0x0000600000275350)
                       }
                     }
                     */
                    // 使用設定好的 decoder 將讀取到的 `data` 解碼成 `MyData` 類型的物件
                    userData = try decoder.decode(MyData.self, from: data)
                    print("Data successfully loaded from \(fileURL.absoluteString)")
                } catch {
                    // 如果在讀取或解碼過程中發生錯誤，則捕捉並印出錯誤訊息
                    print("Error loading JSON data from file: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct MyData: Codable {
    var name: String
    var age: Int
    var items: [String]
}


#Preview {
    ContentView()
}
```

MyData 這個 struct 符合 Codable，代表它的實例可以被編碼 (encode) 成 JSON，也可以從 JSON 解碼 (decode) 回來。

## 簡單讀 hardcode 的 jsonString

先來看看一個硬編碼的 jsonString

```swift
import SwiftUI

struct Question: Codable {
    let text: String
    let answers: [String: String]
}

let jsonString = """
{
    "text": "衝剪機械使用具起動控制功能之光電式安全裝置者，應符合下列規定：\\n一、台盤之水平面須距離地面 [ A ] 毫米以上。\\n二、台盤深度須在 [ B ] 毫米以下。\\n三、衝程在 [ C ] 毫米以下。\\n四、曲軸衝床之過定點停止監視裝置之停止點設定，須在 [ D ] 度以內。",
    "answers": {
        "A": "750",
        "B": "1000",
        "C": "600",
        "D": "15"
    },
}
"""

struct ContentView: View {
    
    @State private var questionData: Question?
    
    var body: some View {
        VStack {
            Button("click me") {
                questionData = loadQuestion()
            }
            .padding() // 給按鈕內容增加內邊距
            .background(Color.blue) // 按鈕背景顏色
            .foregroundStyle(.white) // 按鈕文字顏色
            .cornerRadius(10) // 圓角方框
            
            
            // 根據 questionData 是否為 nil 來顯示不同的內容
            if let question = questionData {
                // 顯示問題內容
                Text(question.text)
                    .font(.body) // 設定字體大小
                    .padding(.horizontal) // 左右內邊距
                    .multilineTextAlignment(.leading) // 文字左對齊
            }
        }
        .padding()
    }
    
    func loadQuestion() -> Question? {
        if let jsonData = jsonString.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let question = try decoder.decode(Question.self, from: jsonData)
                
                print("====")
                print(question)
                return question
               
                
            } catch {
                // 在這裡捕獲並列印出詳細的錯誤資訊
                print("解碼錯誤：\(error)")
                // 您可以根據錯誤類型進行更精細的處理
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        print("資料損壞：\(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        print("找不到鍵 '\(key.stringValue)'：\(context.debugDescription)")
                    case .typeMismatch(let type, let context):
                        print("類型不匹配，預期 \(type) 但找到其他：\(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        print("找不到值，預期類型為 \(type)：\(context.debugDescription)")
                    default:
                        print("未知的解碼錯誤")
                    }
                }
            }
        } else {
            print("無法將 JSON 字串轉換為 Data。")
        }
        
        return nil
    }
    
}

#Preview {
    ContentView()
}
```

以上是一個簡單讀寫在程式碼裡面的 json 格式範例。

來看看故意出錯的話會出現什麼錯誤  
"text": "衝剪機械使用具起動控制功能之光電式安全裝置者，應符合下列規定：\\n一、台盤之水平面須距離地面 [ A ] 毫米以上。  
把 \\n 的一個反斜線去掉，也就是變成 \n
或者 \\n 整個刪掉，再按 enter 換行
"text": "衝剪機械使用具起動控制功能之光電式安全裝置者，應符合下列規定：
一、台盤之水平面須距離地面 [ A ] 毫米以上。

按執行的話應該都會看到下面這樣的錯誤訊息：

```bash
解碼錯誤：dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 "Unescaped control character '0xa' around line 3, column 0." UserInfo={NSDebugDescription=Unescaped control character '0xa' around line 3, column 0., NSJSONSerializationErrorIndex=108})))
資料損壞：The given data was not valid JSON.
```

當在 Swift 中使用 JSONDecoder 解析 JSON 字串時，  
如果遇到 dataCorrupted 和 Unescaped control character 這兩個錯誤，  
這表示 JSON 字串格式有問題，無法被正確識別。  

### dataCorrupted (資料損壞)

這個錯誤訊息的意思是，JSON 解析器認為提供的數據不是一個有效的 JSON 格式。它可能是：

- 完全無法辨識的數據：例如，您傳入了一個空的字串，或者一個完全不符合 JSON 語法的亂碼。
- 部分有效但整體損壞：JSON 結構可能部分正確，但在某個地方出現了嚴重的語法錯誤，導致解析器無法繼續。
- 編碼問題：雖然較少見，但也可能是字串的編碼與預期不符，導致解析器讀取到錯誤的字元。

當 JSONDecoder 遇到這種情況時，它會拋出 DecodingError.dataCorrupted 錯誤，  
表示它無法將您提供的 Data 物件解析成任何有效的 JSON 結構。

### Unescaped control character (未轉義的控制字元)

這是 dataCorrupted 錯誤的一個更具體的解釋，通常會在 underlyingError（底層錯誤）中顯示。

- 控制字元：指的是 ASCII 表中一些特殊的非列印字元，例如換行符（\n）、回車符（\r）、Tab 符（\t）等。
- JSON 規範：JSON 對於字串中的這些控制字元有嚴格的規定。
  如果它們出現在 JSON 字串的值中，必須被「轉義」，
  也就是說，要在這些字元前面加上一個反斜槓 \。
  例如，換行符 \n 需要寫成 \\n，Tab 符 \t 需要寫成 \\t。
- Unescaped (未轉義)：如果 JSON 解析器在預期是普通字元的地方，遇到了這些控制字元，但它們前面又沒有 \ 進行轉義，解析器就會報錯，認為這是無效的語法。
  
### 訊息解讀

當收到類似「Unescaped control character '0xa' around line 3, column 0.」的錯誤時：

- 0xa 是換行符的十六進位表示。
- 這表示在提供的 JSON 字串中，大約在第三行的開頭，JSON 解析器遇到了一個沒有被轉義的換行符。
- 在這樣的情況下，這通常發生在您使用了 Swift 的多行字串字面量（用三個雙引號 """ 包裹）來定義 JSON 字串時。
  Swift 的多行字串會保留所有內部的換行，但 JSON 規範要求這些換行（如果它們是 JSON 值的一部分）必須明確地被轉義為 \\n，否則 JSON 解析器會認為這是一個格式錯誤。

## 從 Bundle 載入 JSON

主要就更改 loadQuestion() 的邏輯就行  

```swift
    func loadQuestion() -> Question? {
        guard let url = Bundle.main.url(forResource: "question", withExtension: "json") else {
            print("找不到 question.json 檔案")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let question = try decoder.decode(Question.self, from: data)
            return question
        } catch {
            print("解碼錯誤：\(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print("資料損壞：\(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("找不到鍵 '\(key.stringValue)'：\(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("類型不匹配，預期 \(type)：\(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("找不到值，預期類型為 \(type)：\(context.debugDescription)")
                @unknown default:
                    print("未知的解碼錯誤")
                }
            }
            return nil
        }
    }
```

然後在專案底下加入 json 資料  
命名一支 question.json  

```json
{
    "text": "衝剪機械使用具起動控制功能之光電式安全裝置者，應符合下列規定：\n一、台盤之水平面須距離地面 [ A ] 毫米以上。\n二、台盤深度須在 [ B ] 毫米以下。\\n三、衝程在 [ C ] 毫米以下。\\n四、曲軸衝床之過定點停止監視裝置之停止點設定，須在 [ D ] 度以內。",
    "answers": {
        "A": "750",
        "B": "1000",
        "C": "600",
        "D": "15"
    },
}
```

順利的話直接執行按下按鈕應該要能順利跑出資料才對

如果遇到下面這樣的錯誤訊息：
找不到 question.json 檔案  

那麼就要開始查找  

一般原因看起來像是還沒加入 Bundle  
可由程式面先來確認一下

印出 bundle 所有檔案
這會看到目前 app 的 main bundle 到底有哪些檔案被成功打包進去，  
幫助確認 question.json 有沒有真的在裡面

```swift
    func loadQuestion() -> Question? {
        guard let url = Bundle.main.url(forResource: "question", withExtension: "json") else {
            print("找不到 question.json 檔案")
            
            // 🔍 印出 bundle 所有檔案
            let resourcePaths = Bundle.main.paths(forResourcesOfType: nil, inDirectory: nil)
            print("📦 目前 bundle 包含檔案:")
            for path in resourcePaths {
                print("→ \(path)")
            }
            
            return nil
        }

        ...
    }
```

### 確認檔案沒有被放進 Compile Sources

操作步驟：

1. 點選左上角你的 App 專案名稱（藍色圖示）。
2. 選擇「Build Phases」頁籤。
3. 展開 Copy Bundle Resources。
4. ✅ 確認 question.json 有列在裡面。

📌 如果不在裡面，請點「+」將它加進來。

![ss 2025-07-10 15-42-43](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-07-10%2015-42-43.jpg)

現在如果執行的話應該能順利看到畫面

![ss 2025-07-10 16-04-45](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-07-10%2016-04-45.jpg)

可以看到原始資料有 \\n，卻顯示了 \n 這樣的文字

### bundle 裡的 json 換行

在 Bundle 裡放的 my_data.json 是一個 真正的 JSON 檔案  
而不是 Swift 字串

所以我們把資料改成如下就能順利讓畫面正常了

而 Json 裡的字串內容，不能包含真正的 Enter 換行  
要使用 \n 才行

```json
{
    "text": "衝剪機械使用具起動控制功能之光電式安全裝置者，應符合下列規定：\n一、台盤之水平面須距離地面 [ A ] 毫米以上。\n二、台盤深度須在 [ B ] 毫米以下。\n三、衝程在 [ C ] 毫米以下。\n四、曲軸衝床之過定點停止監視裝置之停止點設定，須在 [ D ] 度以內。",
    "answers": {
        "A": "750",
        "B": "1000",
        "C": "600",
        "D": "15"
    },
}
```

- JSON 中的 \n 本來就表示「換行字元」，這是合法且正確的用法。
- 不需要也不應該寫成 \\n，否則字串中會變成兩個字元：「反斜線」和「n」，而不是換行。

會需要 \\n 是在 swift 裡寫硬編碼時

```swift
let jsonString = """
{
  "text": "這是第一行\\n這是第二行"
}
"""
```

這裡 Swift 的 """ 字串會先處理 escape 字元，所以你要打 \\n 才會變成 JSON 中的 \n。

JSON 檔案（my_data.json）    \n ✅
Swift 字串內的 JSON         \\n ✅

以下為目前程式碼

```swift
import SwiftUI

struct Question: Codable {
    let text: String
    let answers: [String: String]
}

struct ContentView: View {
    
    @State private var questionData: Question?
    
    var body: some View {
        VStack {
            Button("click me") {
                questionData = loadQuestion()
            }
            .padding() // 給按鈕內容增加內邊距
            .background(Color.blue) // 按鈕背景顏色
            .foregroundStyle(.white) // 按鈕文字顏色
            .cornerRadius(10) // 圓角方框
            
            
            // 根據 questionData 是否為 nil 來顯示不同的內容
            if let question = questionData {
                // 顯示問題內容
                Text(question.text)
                    .font(.body) // 設定字體大小
                    .padding(.horizontal) // 左右內邊距
                    .multilineTextAlignment(.leading) // 文字左對齊
            }
        }
        .padding()
    }
    
    func loadQuestion() -> Question? {
        guard let url = Bundle.main.url(forResource: "question", withExtension: "json") else {
            print("找不到 question.json 檔案")
            
            // 🔍 印出 bundle 所有檔案
            let resourcePaths = Bundle.main.paths(forResourcesOfType: nil, inDirectory: nil)
            print("📦 目前 bundle 包含檔案:")
            for path in resourcePaths {
                print("→ \(path)")
            }
            
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let question = try decoder.decode(Question.self, from: data)
            print(question)
            return question
        } catch {
            print("解碼錯誤：\(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print("資料損壞：\(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("找不到鍵 '\(key.stringValue)'：\(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("類型不匹配，預期 \(type)：\(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("找不到值，預期類型為 \(type)：\(context.debugDescription)")
                @unknown default:
                    print("未知的解碼錯誤")
                }
            }
            return nil
        }
    }
    
}

#Preview {
    ContentView()
}
```
