# JSON 處理

```swift
import SwiftUI
import Foundation // 引入 Foundation 框架用於檔案操作

// 定義一個 Codable 結構，用於示範讀取 JSON 內容
struct LawItem: Codable, Identifiable {
    var id: UUID = UUID() // 為了在 List 中使用，需要 Identifiable
    let title: String
    let description: String
    
    enum CodingKeys: CodingKey {
        case title, description
    }
     
}

struct ContentView: View {
    @State private var statusMessage: String = "正在檢查檔案..."
    @State private var lawItems: [LawItem] = [] // 用來存放從 JSON 讀取的資料

    var body: some View {
        NavigationStack {
            VStack {
                Text(statusMessage)
                    .font(.headline)
                    .padding()
                
                if !lawItems.isEmpty {
                    List(lawItems) { item in
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text(item.description)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    Text("尚未載入法律條文。")
                        .foregroundColor(.secondary)
                }

                Spacer()
                
                Button("在 Documents 目錄中移除 laws.json") {
                    removeFileFromDocuments()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("JSON 檔案管理範例")
            .onAppear(perform: checkAndCopyJSON) // 當 View 出現時執行檢查和複製邏輯
        }
    }

    /// 檢查 Documents 目錄中是否存在 laws.json，如果沒有則從 Bundle 複製。
    func checkAndCopyJSON() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            statusMessage = "無法找到 Documents 目錄。"
            return
        }

        let targetURL = documentsURL.appendingPathComponent("laws.json")

        // 檢查 Documents 目錄中是否存在 laws.json
        if FileManager.default.fileExists(atPath: targetURL.path) {
            statusMessage = "laws.json 檔案已存在於 Documents 目錄。"
            print("檔案已存在於：\(targetURL.absoluteString)")
            loadJSONFromDocuments(url: targetURL)
        } else {
            // 檔案不存在，從 App Bundle 複製
            statusMessage = "laws.json 不存在於 Documents 目錄，正在從 Bundle 複製..."
            print("laws.json 不存在，正在從 Bundle 複製。")
            
            guard let bundleURL = Bundle.main.url(forResource: "laws", withExtension: "json") else {
                statusMessage = "錯誤：無法在 App Bundle 中找到 laws.json。"
                print("錯誤：無法在 App Bundle 中找到 laws.json。請確保檔案已添加到專案 Target。")
                return
            }

            do {
                try FileManager.default.copyItem(at: bundleURL, to: targetURL)
                statusMessage = "laws.json 已成功從 App Bundle 複製到 Documents 目錄。"
                print("檔案已成功複製到：\(targetURL.absoluteString)")
                loadJSONFromDocuments(url: targetURL)
            } catch {
                statusMessage = "複製檔案時發生錯誤：\(error.localizedDescription)"
                print("複製檔案時發生錯誤：\(error.localizedDescription)")
            }
        }
    }
    
    /// 從指定的 URL 載入並解碼 JSON 資料
    func loadJSONFromDocuments(url: URL) {
        // 讀取檔案
        do {
            let data = try Data(contentsOf: url)
            print("JSON 原始文字內容：", String(data: data, encoding: .utf8) ?? "無法轉換成文字")
            
            // 如果成功讀取檔案，再進行 JSON 解碼
            do {
                let decoder = JSONDecoder()
                lawItems = try decoder.decode([LawItem].self, from: data)
                print("成功從 Documents 目錄載入 JSON 資料。")
            } catch {
                statusMessage = "解碼 JSON 檔案時發生錯誤：\(error.localizedDescription)"
                print("解碼 JSON 檔案時發生錯誤：\(error.localizedDescription)")
                lawItems = []
            }
            
        } catch {
            statusMessage = "讀取 JSON 檔案時發生錯誤：\(error.localizedDescription)"
            print("讀取 JSON 檔案時發生錯誤：\(error.localizedDescription)")
            lawItems = []
        }
    }
    
    /// 從 Documents 目錄移除 laws.json 檔案
    func removeFileFromDocuments() {
        guard let documentsURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            print("無法找到 Documents 目錄。")
            return
        }
        let fileToRemoveURL = documentsURL.appendingPathComponent("laws.json")
        
        do {
            if FileManager.default.fileExists(atPath: fileToRemoveURL.path) {
                try FileManager.default.removeItem(at: fileToRemoveURL)
                statusMessage = "laws.json 已從 Documents 目錄移除。請重新啟動 App 觀察複製行為。"
                lawItems = [] // 清空顯示的資料
                print("laws.json 已從 Documents 目錄移除。")
            } else {
                statusMessage = "Documents 目錄中沒有 laws.json 可供移除。"
                print("Documents 目錄中沒有 laws.json 可供移除。")
            }
        } catch {
            statusMessage = "移除檔案時發生錯誤：\(error.localizedDescription)"
            print("移除檔案時發生錯誤：\(error.localizedDescription)")
        }
    }
}
```

```json
[
    {
        "title": "版權法第一條",
        "description": "本法所稱著作，指文學、科學、藝術或其他學術範圍之創作。"
    },
    {
        "title": "版權法第二條",
        "description": "著作人於著作完成時即享有著作權。"
    },
    {
        "title": "商標法第三條",
        "description": "商標指任何可識別商品或服務來源之標誌。"
    },
    {
        "title": "商標法第四條",
        "description": "商標權因註冊而取得。"
    }
]
```