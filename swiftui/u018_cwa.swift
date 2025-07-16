import SwiftUI

struct ContentView: View {
    // 常用的 CWA API 端點：
    // F-C0032-001：一般天氣預報
    // F-C0032-005：鄉鎮天氣預報
    // F-D0047-089：即時天氣
    @State private var inputText: String = "F-C0032-005"
    @State private var statusMessage: String = ""
    
    // 你的 API KEY
    let apiKey = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("輸入資料代碼", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("取得天氣資料並存檔") {
                fetchWeatherData()
            }
            .padding()
            
            Text(statusMessage)
                .padding()
                .foregroundColor(.gray)
        }
        .padding()
    }

    func fetchWeatherData() {
        let baseURL = "https://opendata.cwa.gov.tw/api/v1/rest/datastore/"
        let fullURLString = "\(baseURL)\(inputText)?Authorization=\(apiKey)"
        
        guard let url = URL(string: fullURLString) else {
            statusMessage = "URL 無效"
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    statusMessage = "錯誤：\(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    statusMessage = "沒有收到資料"
                }
                return
            }

            do {
                // 存檔
                let filename = "\(inputText).json"
                let fileURL = try saveDataToDocuments(data: data, filename: filename)
                
                DispatchQueue.main.async {
                    statusMessage = "已儲存：\n\(fileURL.path)"
                    print("檔案儲存位置：", fileURL.path)
                }
            } catch {
                DispatchQueue.main.async {
                    statusMessage = "儲存失敗：\(error.localizedDescription)"
                }
            }
        }

        task.resume()
    }

    func saveDataToDocuments(data: Data, filename: String) throws -> URL {
        let fileManager = FileManager.default
        let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = docsURL.appendingPathComponent(filename)
        try data.write(to: fileURL)
        return fileURL
    }
}

#Preview {
    ContentView()
}
