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
